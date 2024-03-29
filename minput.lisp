;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Kyle Morse
;@date Apr 16, 2012
;@version 1.0

(require "specifications.lisp")

(module MInput
  (import IColor)
  (import IImage)
  (include-book "binary-io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
  (defconst *hdrsize* 54)
  
  ;This is the number of junk bytes in a file.
  ;Junk bytes are what separates columns in byte format.
  (defun junk-width (width)
    (if (equal (mod width 4) 0)
        0
        (- 4 (mod (* width 3) 4))))
  
  ;little endian
  ;1 word is 4 bytes
  (defun word->num (word index sum)
    (if (consp word)
        (word->num (cdr word) 
                   (+ index 1) 
                   (+ sum (* (expt 256 index) (car word))))
        sum))
  
  ;Starts at bottom left and moves up
  (defun make-image (pixels img junk_width x y)
    (if (consp pixels)
        (if (< y (img-height img))
            (if (< x (img-width img))
                (mv-let (front back)
                        (break-at-nth 3 pixels)
                        (mv-let (b g r)
                                front
                                (make-image back 
                                            (add-pixel x 
                                                       y 
                                                       (set-rgb 
                                                        (list (/ r 255)
                                                              (/ g 255)
                                                              (/ b 255)))
                                                       img) 
                                            junk_width (1+ x) y)))
                (make-image (nthcdr junk_width pixels) 
                            img 
                            junk_width 
                            0 
                            (1+ y)))
            img)
        img))
  
  ;Reads in a bitmap file
  (defun r-bmp (path state)
    (mv-let (input-bytes error-open state)
            (binary-file->byte-list path state)
            (if error-open
                (mv state error-open nil)
                (mv state
                    (string-append path
                                   (coerce '(#\newline) 'STRING))
                    input-bytes))))
  
  ;Separates the header and image
  (defun read-bmp-file (path)
    (let* ((file (break-at-nth *hdrsize* (caddr (r-bmp path state))))
           (hdr (car file))
           (width (word->num (subseq hdr 18 22) 0 0))
           (height (word->num (subseq hdr 22 26) 0 0))
           (img (make-image (cadr file) 
                            (empty-image width height) 
                            (junk-width width) 
                            0 
                            0)))
      img))
  
  (export IInput))