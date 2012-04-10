;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author: Michael Brandt
;@date: April 9, 2012
;@version: 1.0

(require "mnegative.lisp")

;Testing Module for operations data structure
(module TNegative
  (import INegative)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (defrandom random-color ()
    (set-rgb (list (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255))))
  
  (defrandom generate-random-image (x y img)
    (if (and (natp x) (natp y) (< y (img-height img)))
        (if (< x (img-width img))
            (generate-random-image (1+ x) y (add-pixel x y (random-color) img))
            (generate-random-image 0 (1+ y) img))
        img))
  
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
  (defproperty negative-round-trip :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     img    :value (random-image width height))
    (image-equal? img (negative (negative img))))
  
  ; Check expects, checking a certain pixel in a negative image for expected value.
  
  )