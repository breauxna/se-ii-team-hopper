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
  
  (defun build-color (img1 img2 x y range update-color)
    
    ;TODO: Not sure if img-height and width return starting from 0 or 1, assuming 1
    ;Check to see if reached the height of the image
    (if (< y (img-height img1))
        
        ;Get hsv values
        (let* ((color (get-color x y img1))
               (h (get-h color))
               (s (get-s color))
               (v (get-v color)))
          
          ;TODO: Could make this a little less confusing
          (if (< x (img-width img1))
              (if (AND (>= h (car range)) (<= h (cadr range)))
                  (build-color img1 (add-pixel x y (set-hsv (list update-color s v)) img2) 
                               (+ x 1) y range update-color)
                  (build-color img1 (add-pixel x y (set-hsv (list h s v)) img2) 
                               (+ x 1) y range update-color))
              (if (AND (>= h (car range)) (<= h (cadr range)))
                  (build-color img1 (add-pixel x y (set-hsv (list update-color s v)) img2) 
                               0 (+ y 1) range update-color)
                  (build-color img1 (add-pixel x y (set-hsv (list h s v)) img2) 
                               0 (+ y 1) range update-color))
              )
          )
        
        img2)
    )
  
  ;@param image original image
  ;@param target-color the hue value of the color you wish to change
  ;@param radius creates a range around the target-color from (tc-r - tc+r)
  ;val should be between 0-1 if 0 targets target color, if 1 targets all colors
  ;@param update-color change all target-colors to this hue value between 0-1
  (defun colormod (image target-color radius update-color)
    (if (is-image-empty? image) 
        image
        (if (>= update-color 1)
            (build-color image image 0 0 (get-range target-color radius) 1)
            (if (<= update-color 0)
                (build-color image image 0 0 (get-range target-color radius) 0)
                (build-color image image 0 0 (get-range target-color radius) update-color)
                )
            )
        )
    )
  
  (export IColormod)
  )
      