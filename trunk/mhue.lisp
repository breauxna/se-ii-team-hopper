;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Nathan Breaux
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module Mhue
  
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;Check to make sure addition will return a val between 0-1
  (defun add-hue-val (h hue-val)
    (if (> (+ h hue-val) 1)
        ;If add is between 1-2 return addition-1 else recurse with hue-val-1
        (if (<= (+ h hue-val) 2)
            (- (+ h hue-val) 1)
            (add-hue-val h (- hue-val 1))
            )
        ;If <= 1 just return addition
        (+ h hue-val)
        )
    )
  
  (defun build-hue (img1 img2 x y hue-value)
    
    ;TODO: Not sure if img-height and width return starting from 0 or 1, assuming 1
    ;Check to see if reached the height of the image
    (if (< y (img-height img1))
        
        ;Get new hsv value
        (let* ((color (get-color x y img1))
               (h (get-h color))
               (s (get-s color))
               (v (get-v color))
               (hsv (list (add-hue-val h hue-value) s v)))
          
          ;Check to see if reached the width of the image 
          ;if yes: add hsv reset x and increase y
          ;if no: add hsv increase x and pass y
          (if (< x (img-width img1))
              (build-hue img1 (add-pixel x y (set-hsv hsv) img2) (+ x 1) y hue-value)
              (build-hue img1 (add-pixel x y (set-hsv hsv) img2) 0 (+ y 1) hue-value)
              )
          )
        img2)
    )       
  
  ;@param image original image
  ;@param hue-value hue value specified by the user
  (defun hue (image hue-value)
    (if (OR (is-image-empty? image) (equal hue-value 0))
        image
        (build-hue image image 0 0 hue-value)
        )
    )
  (export IHue)
  )
            