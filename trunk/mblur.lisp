;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module MBlur
  (import IImage)
  (import IColor)
  (import IMath)
  
  (defun blend-color (img1 img2 x y centerx centery radius)
    (if (< y (img-height img1))
        (if (< x (img-width img1))
            (if (<= (distance x y centerx centery) radius)
                (let* ((center (get-color x y img1))
                       (up (get-color x (1- y) img1))
                       (down (get-color x (1+ y) img1))
                       (left (get-color (1- x) y img1))
                       (right (get-color (1+ x) y img1))
                       (avg-r (average (remove nil (list (get-r center)
                                                         (get-r up)
                                                         (get-r down)
                                                         (get-r left)
                                                         (get-r right)))))
                       (avg-g (average (remove nil (list (get-g center)
                                                         (get-g up)
                                                         (get-g down)
                                                         (get-g left)
                                                         (get-g right)))))
                       (avg-b (average (remove nil (list (get-b center)
                                                         (get-b up)
                                                         (get-b down)
                                                         (get-b left)
                                                         (get-b right))))))
                  (blend-color img1(add-pixel x y (set-rgb (list avg-r avg-g avg-b)) img2) (1+ x) y centerx centery radius))
                (blend-color img1 img2 (1+ x) y centerx centery radius))
            (blend-color img1 img2 0 (1+ y) centerx centery radius))
        img2))
  
  (defun blur (img x y radius)
    (blend-color img img 0 0 x y radius))
  
  (export IBLur))