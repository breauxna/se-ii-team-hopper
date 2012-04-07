;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")

(require "specifications.lisp")

(module MImage
  
  (include-book "avl-rational-keys" :dir :teachpacks)
  
  ;utilities -all private
  (defun byte->rat-rec (byte exponent)
    (if (or (endp byte) (< exponent 1))
        0
        (+ (* (car byte) exponent)
           (byte->rat-rec (cdr byte) (/ exponent 2)))))
  
  (defun byte->rat (byte)
    (byte->rat-rec byte 128))
  
  (defun word-align (x)
    (* 32 (round x 32)))
  
  ;header ------------------------------------------------------------------
  
  ;length and offset are in bytes
  (defun get-header-bytes (offset length xs)
    (if (= length 0)
        nil
        (cons (byte->rat (take 8 (nthcdr (* offset 8) xs)))
              (get-header-bytes (+ offset 1) (- length 1) xs))))
  
  (defun get-header-value-rec (bytes exponent)
    (if (endp bytes)
        0
        (+ (* exponent (car bytes))
           (get-header-value-rec (cdr bytes) (* 128 exponent)))))
  
  (defun get-header-value (offset length xs)
    (get-header-value-rec (get-header-bytes offset length xs) 1))
  
  (defun header (pixel-offset bits-per-pixel row-length row-count 
                              red-mask blue-mask green-mask
                              alpha-mask raw-header)
    (list pixel-offset bits-per-pixel row-length row-count raw-header))
  
  (defun bits->header (bits)
    (header (get-header-value 10 4 bits)
            (get-header-value 28 2 bits)
            (get-header-value 18 4 bits)
            (get-header-value 22 4 bits)
            nil
            nil
            nil
            nil
            (take (get-header-value 10 4 bits) bits)))
  
  ;color --------------------------------------
  
  (defun word->color (word red-mask green-mask blue-mask alpha-mask)
    (list (byte->rat (take 8 word))
          (byte->rat (take 8 (nthcdr 8 word)))
          (byte->rat (take 8 (nthcdr 16 word)))
          255))
  
  
  (defun bits->color (x y pixel-length row-length offset red-mask green-mask blue-mask alpha-mask bits)
    (word->color 
     (take pixel-length 
           (nthcdr 
            (+ (* x pixel-length) 
               (+ (* offset 8) 
                  (* y 
                     (word-align 
                      (* row-length pixel-length))))) 
            bits)) nil nil nil nil))
  
  ;tree ---------------
  
  (defun add-pixel-to-tree (x y color tree)
    (avl-insert tree x
                (let ((row (avl-retrieve tree x)))
                  (if (not row)
                      (avl-insert (empty-tree) y color)
                      (avl-insert (cdr row) y color)))))
  
  ;(pixel-offset bits-per-pixel row-length row-count 
  ;              red-mask blue-mask green-mask
  ;              alpha-mask raw-header)
  
  ;public
  (defun image (hdr tr)
    (list hdr tr))
  
  (defun add-pixel (x y color img)
    (image (car img)
           (add-pixel-to-tree x y color (cadr img))))
  
  (defun get-color (x y img)
    (cdr (avl-retrieve
          (cdr (avl-retrieve (cadr img)
                             x))
          y)))
  
  (defun empty-image (hdr)
    (image hdr (empty-tree)))
  
  (defun is-image-empty? (img)
    (if (consp (cadr img))
        nil
        t))
  
  (defun img-width (img)
    (caddr (car img)))
  
  (defun img-height (img)
    (cadddr (car img)))
  
  (defun img-pixel-offset (img)
    (car (car img)))
  
  (defun img-bits-per-pixel (img)
    (cadr (car img)))
  
  (defun img-red-mask (img)
    (cadddr (cdr (car img))))
  
  (defun img-blue-mask (img)
    (cadddr (cddr (car img))))
  
  (defun img-green-mask (img)
    (cadddr (cdddr (car img))))
  
  (defun img-alpha-mask (img)
    (cadddr (cddddr (car img))))
  
  ; TODO - need to modify raw header from other header values
  (defun img-raw-header (img)
    (cadddr (cddddr (cdr (car img)))))
  
  (defun img-header (img)
    (car img))
  
  (defun change-size (width height img)
    (header (img-pixel-offset img)
            (img-bits-per-pixel img)
            width
            height
            (img-red-mask img) 
            (img-blue-mask img)
            (img-green-mask img)
            (img-alpha-mask img)
            (img-raw-header img)))
  
  ;this is here for scope TODO: figure out a better organization
  (defun add-pixels (x y img bits)
    (if (< y 2)
        (add-pixel x y (bits->color x y 24 2 54 nil nil nil nil bits) 
                   (add-pixels (if (< x 1) (+ x 1) 0) (if (< x 1) y (+ y 1)) img bits))
        img))
  
  
  (defun bits->img (bits)
    (add-pixels 0 0 (empty-image (bits->header bits)) bits))
  
  (defconst *example1*
    '(
      0 1 0 0 0 0 1 0 ;42
        0 1 0 0 1 1 0 1 ;4D
        0 1 0 0 0 1 1 0 ;46
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 1 1 0 1 1 0 ;36
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 1 0 1 0 0 0 ;28
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 1 0 ;02
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 1 0 ;02
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 1 ;01
        0 0 0 0 0 0 0 0 ;00
        0 0 0 1 1 0 0 0 ;18
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 1 0 0 0 0 ;10
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 1 0 0 1 1 ;13
        0 0 0 0 1 0 1 1 ;0B
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 1 0 0 1 1 ;13
        0 0 0 0 1 0 1 1 ;0B
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        1 1 1 1 1 1 1 1 ;FF
        1 1 1 1 1 1 1 1 ;FF
        1 1 1 1 1 1 1 1 ;FF
        1 1 1 1 1 1 1 1 ;FF
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        1 1 1 1 1 1 1 1 ;FF
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        1 1 1 1 1 1 1 1 ;FF
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        0 0 0 0 0 0 0 0 ;00
        ))
  
  ;output TODO remove
  
  (defun binary-write (byte-list channel state)
    (if (atom byte-list)
        (mv channel state)
        (let ((state (write-byte$ (car byte-list) channel state)))
          (binary-write (cdr byte-list) channel state))))
  
  (defun byte-list->binary-file (fname byte-list state)
    (mv-let (channel state)
            (open-output-channel fname :byte state)
            (if (null channel)
                (mv (string-append "Error while opening file for output: " fname)
                    state)
                (mv-let (channel state)
                        (binary-write byte-list channel state)
                        (let ((state (close-output-channel channel state)))
                          (mv nil state))))))
  (export IImage))

