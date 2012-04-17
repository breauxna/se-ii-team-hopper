;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: April 16, 2012
;@version: 1.0

(require "specifications.lisp")

;Takes an image and returns the negative of the picture
;This operation subtracts the max value of each rgb value
;by the actual value to get the negative
(module MNegative
  (import IImage)
  (import IColor)
  
  ;This is the recursive function for getting a negative image. 
  (defun get-negative (old new x y)
    (if (< y (img-height old))
        (if (< x (img-width old))
            (get-negative old 
                          (add-pixel x
                                     y
                                     (set-rgb (list (- 1 
                                                       (get-r 
                                                          (get-color x 
                                                                     y 
                                                                     old)))
                                                    (- 1 
                                                       (get-g 
                                                          (get-color x 
                                                                     y 
                                                                     old)))
                                                    (- 1 
                                                       (get-b 
                                                          (get-color x 
                                                                     y 
                                                                     old)))
                                                    ))
                                     new)  
                          (+ 1 x) 
                          y)
            (get-negative old new 0 (+ 1 y)))
        new))
  
  ;This is the wrapper function for negative.
  ;Takes in an image and makes sure the width and height
  ;is right and then does the operation. If it can't then 
  ;it just returns the original image
  (defun negative (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img))
             (< 0 (img-height img)))
        (get-negative img (empty-image (img-width img) 
                                       (img-height img)) 0 0)
        img))
  
  (export INegative))