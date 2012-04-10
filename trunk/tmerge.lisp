;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 9, 2012
;@version 1.0

(require "specifications.lisp")

(module TMerge
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (import IColor)
  (import IImage)
  (import IMerge)
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
  
  (check-expect (merge nil nil 'up) nil)
  (check-expect (merge nil (empty-image 5 5) 'down) (empty-image 5 5))
  (check-expect (merge (empty-image 10 10) nil 'left) nil)
  (check-expect (merge (empty-image 10 10) (add-pixel 0 0 (empty-image 10 5) (set-rgb '(0 0 0))) 'right) (add-pixel 0 0 (empty-image 10 5) (set-rgb '(0 0 0))))
  (check-expect (merge (empty-image 10 10) (empty-image 5 10) 'up) (empty-image 5 10))
  
  (defproperty merge-up-correct-size :repeat 100
    (width   :value (random-between 1 10)
     height1 :value (random-between 1 10)
     height2 :value (random-between 1 10)
     img1    :value (random-image width height1)
     img2    :value (random-image width height2))
    (let ((new-img (merge img1 img2 'up)))
      (and (equal (img-width new-img) width)
           (equal (img-height new-img) (+ height1 height2)))))
  
  (defproperty merge-down-correct-size :repeat 100
    (width   :value (random-between 1 10)
     height1 :value (random-between 1 10)
     height2 :value (random-between 1 10)
     img1    :value (random-image width height1)
     img2    :value (random-image width height2))
    (let ((new-img (merge img1 img2 'down)))
      (and (equal (img-width new-img) width)
           (equal (img-height new-img) (+ height1 height2)))))
  
  (defproperty merge-left-correct-size :repeat 100
    (width1  :value (random-between 1 10)
     width2  :value (random-between 1 10)
     height :value (random-between 1 10)
     img1    :value (random-image width1 height)
     img2    :value (random-image width2 height))
    (let ((new-img (merge img1 img2 'left)))
      (and (equal (img-width new-img) (+ width1 width2))
           (equal (img-height new-img) height))))
  
  (defproperty merge-right-correct-size :repeat 100
    (width1  :value (random-between 1 10)
     width2  :value (random-between 1 10)
     height :value (random-between 1 10)
     img1    :value (random-image width1 height)
     img2    :value (random-image width2 height))
    (let ((new-img (merge img1 img2 'right)))
      (and (equal (img-width new-img) (+ width1 width2))
           (equal (img-height new-img) height))))
  
  (defproperty merge-up-down-round-trip :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     img1   :value (random-image width height)
     img2   :value (random-image width height))
    (image-equal? (merge img1 img2 'up) (merge img2 img1 'down)))
  
  (defproperty merge-left-down-round-trip :repeat 100
    (width  :value (random-between 1 10)
     height :value (random-between 1 10)
     img1   :value (random-image width height)
     img2   :value (random-image width height))
    (image-equal? (merge img1 img2 'left) (merge img2 img1 'right)))
  )