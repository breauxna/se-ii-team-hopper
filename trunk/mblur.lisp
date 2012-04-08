;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

(require "specifications.lisp")

(module MBlur
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;helper function that iterates through the entire image and blurs
  ;pixels that fall within the circle
  ;@param img1 - orginal image
  ;@param img2 - new image
  ;@param x - current x location
  ;@param y - current y location
  ;@param centerx - x center of blur
  ;@param centery - y center of blur
  ;@param radius  - radius of blur circle
  (defun blend-color (img1 img2 x y centerx centery radius)
    (if (< y (img-height img1))
        (if (< x (img-width img1))
            (if (<= (distance x y centerx centery) radius)
                (let* ((center (get-color x y img1))
                       (up (get-color x (1- y) img1))
                       (down (get-color x (1+ y) img1))
                       (left (get-color (1- x) y img1))
                       (right (get-color (1+ x) y img1))
                       (avg-r (average (remove nil (list (get-r center) ;average r value
                                                         (get-r up)
                                                         (get-r down)
                                                         (get-r left)
                                                         (get-r right)))))
                       (avg-g (average (remove nil (list (get-g center) ;average g value
                                                         (get-g up)
                                                         (get-g down)
                                                         (get-g left)
                                                         (get-g right)))))
                       (avg-b (average (remove nil (list (get-b center) ;average b value
                                                         (get-b up)
                                                         (get-b down)
                                                         (get-b left)
                                                         (get-b right))))))
                  (blend-color img1(add-pixel x y (set-rgb (list avg-r avg-g avg-b)) img2) (1+ x) y centerx centery radius))
                (blend-color img1 img2 (1+ x) y centerx centery radius))
            (blend-color img1 img2 0 (1+ y) centerx centery radius))
        img2))
  
  ;blur blurs a circle in the image centered at x y with a given radius
  ;@param img - original image
  ;@param x - x center of blur
  ;@param y - y center of blur
  ;@param radius - radius of blur circle
  (defun blur (img x y radius)
    (blend-color img img 0 0 x y radius))
  
  (export IBLur))