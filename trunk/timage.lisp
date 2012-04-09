;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module TImage
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (import IColor)
  (import IImage)
  (import ITestFunctions)
  
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
  
  (defproperty image-get-add-same-color :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     x      :value (mod (random-natural) width)
     y      :value (mod (random-natural) height)
     img    :value (random-image width height))
    (image-equal? img (add-pixel x y (get-color x y img) img)))
  
  )