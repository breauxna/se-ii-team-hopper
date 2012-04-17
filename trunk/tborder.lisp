;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Nathan Breaux
;@date: April 16, 2012
;@version: 1.0

(require "specifications.lisp")

;Testing Module for crop
(module TBorder
  (import IBorder)
  (import ICrop)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  ;Check for null case
  (check-expect (border nil 0 (set-rgb (list 0 0 0))) nil)
  
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
  
  ;Add border and crop border should return same image
  (defproperty border-round-trip :repeat 100
    (width       :value (random-between 1 10)
     height      :value (random-between 1 10)
     img         :value (random-image width height)
     border-size :value (random-between 1 10)
     color       :value (random-color)
     border-img  :value (border img border-size color))
    (image-equal? img (crop border-img 
                            border-size
                            border-size
                            (- (+ width border-size) 1)
                            (- (+ height border-size) 1))))
  
  ;Check that when the border is added the new width and height is 2*border
  (defproperty border-check-size :repeat 100
    (width       :value (random-between 1 10)
     height      :value (random-between 1 10)
     border-size :value (random-between 1 10)
     color       :value (random-color)
     img         :value (random-image width height))
    (let ((new-img (border img border-size color)))
      (and (equal (+ height (* border-size 2)) (img-height new-img))
           (equal (+ width (* border-size 2)) (img-width new-img))))))