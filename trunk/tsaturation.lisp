;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date: Apr 16, 2012
;@version: 1.0

(require "msaturation.lisp")

(module TSaturation
  (import ISaturation)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (check-expect (saturation nil 0) nil)
  
  ;Creates a random color data structure
  (defrandom random-color ()
    (set-rgb (list (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255))))
  
  ;Creates a random tree
  (defrandom generate-random-image (x y img)
    (if (and (natp x) (natp y) (< y (img-height img)))
        (if (< x (img-width img))
            (generate-random-image (1+ x) y (add-pixel x 
                                                       y 
                                                       (random-color) 
                                                       img))
            (generate-random-image 0 (1+ y) img))
        img))
  
  ;Creates a random image data structure
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
  (defproperty saturation-same-size :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     b      :value (random-natural)
     img    :value (random-image width height))
    (let ((new-img (saturation img b)))
      (and (equal height (img-height new-img))
           (equal width (img-width new-img))))))