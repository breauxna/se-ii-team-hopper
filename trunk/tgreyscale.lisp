;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date: Apr 16, 2012
;@version: 1.0

(require "mgreyscale.lisp")

(module TGreyscale
  (import IGreyscale)
  (import IImage)
  (import IColor)
  (import ITestFunctions)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (check-expect (greyscale nil) nil)
  
  ;Creates a random color data structure
  (defrandom random-color ()
    (set-rgb (list (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255))))
  
  ;Creates a random color atom
  (defrandom random-color-atom ()
    (let ((r (random-between 0 2))) 
      (cond ((= r 0) 'red)
            ((= r 1) 'green)
            ((= r 2) 'blue))))
  
   ;Creates a random tree
  (defrandom generate-random-image (x y img)
    (if (and (natp x) (natp y) (< y (img-height img)))
        (if (< x (img-width img))
            (generate-random-image (1+ x) y (add-pixel x y (random-color) img))
            (generate-random-image 0 (1+ y) img))
        img))
  
  ;Creates a random image data structure
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
   ;Checks if you split an image into a color
  ;that the resulting image is the same size
  (defproperty split-same-size :repeat 100
    (img   :value (random-image (random-between 1 10) (random-between 1 10))
     color :value (random-color-atom))
    (let ((new-img (greyscale img)))
      (and (equal (img-width img) (img-width new-img))
           (equal (img-height img) (img-height new-img))))))
  