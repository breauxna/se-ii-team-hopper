;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Nathan Breaux, Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module MBorder
  (import IImage)
  (import IColor)
  (import IMath)
  
  (defun build-border (img1 img2 b border-color x y)
    (if (< y (img-height img2))
        (if (< x (img-width img2))
            ;Check to see if (x, y) is in the border space
            (if (OR (< x b) (>= x (- (img-width img2) b))
                    (< y b) (>= y (- (img-height img2) b)))
                
                ;Add border at (x, y) to img2
                (build-border img1 
                              (add-pixel x y border-color img2) 
                              b border-color (1+ x) y)
                
                ;Add pixel from img1 to img2 at (x, y)
                (build-border img1 
                              (add-pixel x y 
                                         (get-color (- x b) (- y b) img1) 
                                         img2) 
                              b border-color (1+ x) y))
            
            ;Recurse with y incremented by 1
            (build-border img1 img2 b border-color 0 (1+ y)))
        
        ;End of image
        img2))
  
  ;@param image original image
  ;@param border-size size of border
  ;@param border-color color data structure
  ;Add border with specified size and color to image
  (defun border (image border-size border-color)
    (if (OR (is-image-empty? image) 
            (not (posp border-size)) 
            (not (color? border-color)))
        image
        (build-border image
                      (empty-image 
                       (+ (* border-size 2) (img-width image))
                       (+ (* border-size 2) (img-height image)))
                      border-size
                      border-color
                      0
                      0)
        )
    )
  
  (export IBorder))