;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module TMirror
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (import IColor)
  (import IImage)
  (import IMirror)
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
  
  ;mirror tests
  (check-expect (mirror nil 'x) nil)
  (check-expect (mirror nil 'y) nil)
  (check-expect (mirror (empty-image 10 10) 'x) (empty-image 10 10))
  (check-expect (mirror (empty-image 10 10) 'y) (empty-image 10 10))
  
  (defproperty x-mirror-same-size :repeat 100
    (img :value (random-image (random-between 1 10) (random-between 1 10)))
    (let ((img2 (mirror img 'x)))
      (and (equal (img-width img) (img-width img2))
           (equal (img-height img) (img-height img2)))))
  
  (defproperty y-mirror-same-size :repeat 100
    (img :value (random-image (random-between 1 10) (random-between 1 10)))
    (let ((img2 (mirror img 'y)))
      (and (equal (img-width img) (img-width img2))
           (equal (img-height img) (img-height img2)))))
  
  (defproperty x-mirror-round-trip :repeat 100
    (img :value (random-image (random-between 1 10) (random-between 1 10)))
    (image-equal? img (mirror (mirror img 'x) 'x)))
  
  (defproperty y-mirror-round-trip :repeat 100
    (img :value (random-image (random-between 1 10) (random-between 1 10)))
    (image-equal? img (mirror (mirror img 'y) 'y)))
  )