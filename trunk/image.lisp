(include-book "avl-rational-keys" :dir :teachpacks)

;TODO
(defun set-image (hdr-bytes img-bytes)
  nil)

(defun byte->rat-rec (byte exponent)
  (if (or (endp byte) (< exponent 1))
      0
      (+ (* (car byte) exponent)
         (byte->rat-rec (cdr byte) (/ exponent 2)))))

(defun byte->rat (byte)
  (byte->rat-rec byte 128))


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

(defun word->color (word red-mask green-mask blue-mask alpha-mask)
  (list (byte->rat (take 8 word))
        (byte->rat (take 8 (nthcdr 8 word)))
        (byte->rat (take 8 (nthcdr 16 word)))
        255))

(defun word-align (x)
            (* 32 (round x 32)))

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

(defun add-pixel-to-tree (x y color tree)
          (avl-insert tree x
                      (let ((row (avl-retrieve tree x)))
                        (if (not row)
                            (avl-insert (empty-tree) y color)
                            (avl-insert (cdr row) y color)))))

(defun add-pixel (x y color img)
  (list (car img)
        (add-pixel-to-tree x y color (cadr img))))

(defun empty-image (hdr)
  (list hdr (empty-tree)))

(defun add-pixels (x y img bits)
  (if (< y 2)
      (add-pixel x y (bits->color x y 24 2 54 nil nil nil nil bits) 
                 (add-pixels (if (< x 1) (+ x 1) 0) (if (< x 1) y (+ y 1)) img bits))
      img))

(defun bits->img (bits)
          (add-pixels 0 0 (empty-image (bits->header bits)) bits))

(defun image (hdr tr)
  (list hdr tr))

(defun get-x (pixel)
  (car pixel))

(defun get-y (pixel)
  (cadr pixel))

(defun get-color (pixel)
  (caddr pixel))

;pixel = (x y color)
(defun build-tree (pixels)
  (if (endp pixels)
      (empty-tree)
      (add-pixel-to-tree (caar pixels)
                         (cadar pixels)
                         (caddar pixels)
                         (build-tree (cdr pixels)))))

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
   
   