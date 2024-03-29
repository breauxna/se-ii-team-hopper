;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: Apr 16, 2012
;@version: 1.0

(require "specifications.lisp")

;Takes in an image and edits the value.
;This essentially either raises or lowers
;the brightness. The change amount needs to be
;between -1 and 1.
(module MBrightness
  (import IImage)
  (import IColor)
  
  ;Recursive function that does the brightness operation
  (defun edit-b (old new amount x y)
    (if (< y (img-height old))
        (if (< x (img-width old))
            (edit-b old 
                    (add-pixel x
                               y
                               (set-hsv (list (get-h (get-color x y old))
                                              (get-s (get-color x y old))
                                              (let ((v 
                                                     (* 
                                                      (get-v 
                                                       (get-color x 
                                                                  y 
                                                                  old)) 
                                                          amount)))
                                                (cond ((< v 0) 0)
                                                      ((> v 1) 1)
                                                      (t v)))))
                               new)
                    amount
                    (+ 1 x)
                    y)
            (edit-b old new amount 0 (+ 1 y)))
        new))
  
  ;Wrapper function that takes an image and checks to make sure
  ;width and height is correct. If it is, it performs the operation
  ;If not then it returns the original image
  (defun brightness (img amount)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img)) 
             (< 0 (img-height img)))
        (edit-b img 
                (empty-image (img-width img) 
                                 (img-height img)) 
                (/ amount 100) 0 0)
        img))
  
  (export IBrightness))