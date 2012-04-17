;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Nathan Breaux
;@date: April 16, 2012
;@version: 1.0

(require "specifications.lisp")

;Testing Module for colormod
(module TColormod
  (import IColormod)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  ;Check for null case
  (check-expect (colormod nil (set-rgb (list 0 0 0)) 0 
                          (set-rgb (list 0 0 0))) nil)
  
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
  
  ;Creates a random tree of one-color
  (defrandom generate-random-image-one-color (x y img color)
    (if (and (natp x) (natp y) (< y (img-height img)))
        (if (< x (img-width img))
            (generate-random-image-one-color (1+ x) y (add-pixel x 
                                                       y 
                                                       color
                                                       img) color)
            (generate-random-image-one-color 0 (1+ y) img color))
        img))
  
  ;Creates a random image data structure
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
  (defrandom random-image-one-color (width height color)
    (generate-random-image-one-color 0 0 (empty-image width height) color))
  
  ;Checks round trip property for colormod on single color image
  (defproperty colormod-round-trip :repeat 100
    (width   :value (random-between 1 10)
     height  :value (random-between 1 10)
     tc      :value (random-color)
     os      :value (random-natural)
     uc      :value (random-color)
     img     :value (random-image-one-color width height tc)
     new-img :value (colormod (colormod img tc os uc) uc os tc))
      (image-equal? new-img img))
  
   ;Checks if after doing colormod that the
   ;target-color is not in the new image
  (defproperty colormod-change :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     tc     :value (random-color)
     os     :value (random-natural)
     uc     :value (random-color)
     img    :value (random-image width height)
            :where (not (equal tc uc)))
    (let ((new-img (colormod img tc os uc)))
      (equal (color-in-image? new-img tc)
           nil)))
  
  ;Checks if after doing colormod that the
  ;size of image is the same
  (defproperty colormod-same-size :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     tc     :value (random-color)
     os     :value (random-natural)
     uc     :value (random-color)
     img    :value (random-image width height))
    (let ((new-img (colormod img tc os uc)))
      (and (equal height (img-height new-img))
           (equal width (img-width new-img))))))