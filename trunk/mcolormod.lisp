;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Nathan Breaux
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module MColormod
  
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;Get range
  (defun get-range (target-color radius)
    (if (>= (+ target-color radius) 1)
        (if (<= (- target-color radius) 0)
            (list 0 1)
            (list (- target-color radius) 1))
        (if (<= (- target-color radius) 0)
            (list 0 (+ target-color radius))
            (list (- target-color radius) (+ target-color radius)))
        )
    )
  
  (defun build-color (img1 img2 x y r-range g-range b-range update-color)
    
    ;Check to see if reached the height of the image
    (if (< y (img-height img1))
        
        (if (< x (img-width img1))
            
            ;Get rgb values
            (let* ((color (get-color x y img1))
                   (r (get-r color))
                   (g (get-g color))
                   (b (get-b color)))
              
              ;Check if all rgb values lie within the specified range
              (if (AND (>= r (car r-range)) (<= r (cadr r-range))
                       (>= g (car g-range)) (<= g (cadr g-range))
                       (>= b (car b-range)) (<= b (cadr b-range)))
                  
                  (build-color img1 
                               (add-pixel x y update-color img2) 
                               (+ x 1) 
                               y 
                               r-range 
                               g-range
                               b-range 
                               update-color)
                  
                  (build-color img1 
                               (add-pixel x y color img2) 
                               (+ x 1)
                               y 
                               r-range
                               g-range
                               b-range
                               update-color)))
            
            ;End x move y down by 1
            (build-color img1 img2 0 (+ y 1) 
                         r-range g-range b-range update-color))
        img2)
    )
  
  ;@param image original image
  ;@param target-color rgb color structure
  ;@param radius creates a range around the target-color from (tc-r - tc+r)
  ;@param update-color change all target-colors to this color
  (defun colormod (image target-color radius update-color)
    ;Check if empty image or nil color
    (if (OR (is-image-empty? image) 
            (equal target-color nil) 
            (equal update-color nil))
        image
        
        ;Get the range for r, g, b
        (let* ((r-range (get-range (get-r target-color) radius))
               (g-range (get-range (get-g target-color) radius))
               (b-range (get-range (get-b target-color) radius)))
          (build-color image 
                       (empty-image (img-width image) (img-height image))
                       0 
                       0 
                       r-range
                       g-range
                       b-range
                       update-color)
          )
        )
    )
    
  (export IColormod)
  )
      