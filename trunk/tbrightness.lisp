;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Michael Brandt and Kyle Morse
;@date: April 16, 2012
;@version: 1.0

(require "mrotate.lisp")

;Testing Module for brightness
(module TBrightness
  (import IBrightness)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  ;Check for null case
  (check-expect (brightness nil 0) nil)
  
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
                                                       (random-color) img))
            (generate-random-image 0 (1+ y) img))
        img))
  
  ;Creates a random image data structure
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
  ;Checks if increasing brightness and then
  ;reducing is the same as original
  (defproperty brightness-round-trip :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     img    :value (random-image width height))
    (image-equal? img (brightness img 100)))
  
  ;Checks if after doing brightness that the
  ;size of image is the same
  (defproperty brightness-same-size :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     b      :value (random-natural)
     img    :value (random-image width height))
    (let ((new-img (brightness img b)))
      (and (equal height (img-height new-img))
           (equal width (img-width new-img))))))