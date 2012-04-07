;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Nathan Breaux
;@date Apr 6, 2012
;@version 1.0

(require "specifications.lisp")

(module MBorder
  
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;Add the bottom horizontal border to the image
  ;@param img1(x, y) border image
  (defun build-bottom-border (img1 border-size border-color x y)
    (if (< y (img-height img1))
        (if (< x (img-width img1))
            (build-bottom-border (add-pixel x y border-color img1) 
                                 border-size border-color 
                                 (+ x 1) y)
            (build-bottom-border (add-pixel x y border-color img1) 
                                 border-size border-color 
                                 x (+ y 1))
            )
        img1
        )
    )
            
               
  
  ;Build the middle vertical borders
  ;@param img1(x1, y1) original image
  ;@param img2(x2, y2) border image
  (defun build-middle-border (img1 img2 border-size border-color x1 y1 x2 y2)
    (if (< y2 (+ border-size (img-height img1)))
        (if (> (- x2 (img-width img2)) (+ border-size (img-width img1)))
            
            ;Left vertical border
            (build-middle-border img1 (add-pixel x2 y2 border-color img2) 
                                 border-size border-color x1 y1 (+ x2 1) y2)
            
            (if (< (- x2 (img-width img2)) (+ border-size (img-width img1)))
                ;Right vertical border
                (build-middle-border img1 (add-pixel x2 y2 border-color img2) 
                                     border-size border-color x1 y1 (+ x2 1) y2)
                ;Then in the picture, no border
                (build-middle-border img1 (add-pixel x2 y2 (get-color x1 y1 img1) img2)
                                     border-size border-color (+ x1 1) y1 (+ x2 1) y2)
                )
            
            )
        ;Bottom of the picture, add bottom border
        (build-bottom-border img2 border-size border-color x2 y2)
        )
    )
                
  
  ;Build the top horizontal border
  ;@param img1 original image
  ;@param img2(x2, y2) border image
  (defun build-top-border (img1 img2 border-size border-color x y)
    ;Add top border
    (if (< y border-size)
        (if (< x (img-width img2))
            (build-top-border img1 (add-pixel x y border-color img2) 
                          border-size border-color (+ x 1) y)
            (build-top-border img1 (add-pixel x y border-color img2)
                          border-size border-color 0 (+ y 1))
            )
        (build-middle-border img1 img2 border-size border-color x y 0 0)
        )
    )
                          
  
  ;@param image original image
  ;@param border-size size of border
  ;@param border-color color data structure
  (defun border (image border-size border-color)
    (if (OR (is-image-empty? image) (equal border-size 0))
        image   
        (build-top-border image (change-size 
                             (+ (* border-size 2) (img-width image))
                             (+ (* border-size 2) (img-width image))
                             image) border-size border-color 0 0)
        )
    )
  (export IBorder)
  )
        