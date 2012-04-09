;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

;MBlur module blurs the entire image
(module MBlur
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;helper function that iterates through the entire image
  ;and blurs every pixel
  ;@param img1 - orginal image
  ;@param img2 - new image
  ;@param x - current x location
  ;@param y - current y location
  ;@return image - newly blurred image
  (defun blend-color (img1 img2 x y)
    (if (is-image-empty? img1)
        img1
        (if (and (natp x) (natp y) (< y (img-height img1)))
            (if (< x (img-width img1))
                (let* ((center (get-color x y img1))
                       (ul (get-color (1- x) (1+ y) img1))
                       (up (get-color x (1+ y) img1))
                       (ur (get-color (1+ x) (1+ y) img1))
                       (dl (get-color (1- x) (1- y) img1))
                       (down (get-color x (1- y) img1))
                       (dr (get-color (1+ x) (1- y) img1))
                       (left (get-color (1- x) y img1))
                       (right (get-color (1+ x) y img1))
                       (avg-r (average (remove nil (list (get-r center) ;average r value
                                                         (get-r ul)
                                                         (get-r up)
                                                         (get-r ur)
                                                         (get-r dl)
                                                         (get-r down)
                                                         (get-r dr)
                                                         (get-r left)
                                                         (get-r right)))))
                       (avg-g (average (remove nil (list (get-g center) ;average g value
                                                         (get-g ul)
                                                         (get-g up)
                                                         (get-g ur)
                                                         (get-g dl)
                                                         (get-g down)
                                                         (get-g dr)
                                                         (get-g left)
                                                         (get-g right)))))
                       (avg-b (average (remove nil (list (get-b center) ;average b value
                                                         (get-b ul)
                                                         (get-b up)
                                                         (get-b ur)
                                                         (get-b dl)
                                                         (get-b down)
                                                         (get-b dr)
                                                         (get-b left)
                                                         (get-b right))))))
                  (blend-color img1 (add-pixel x y (set-rgb (list avg-r avg-g avg-b)) img2) (1+ x) y))
                (blend-color img1 img2 0 (1+ y)))
            img2)))
  
  ;blur blurs the entire image
  ;@param img - original image
  ;@return image - newly blurred image
  (defun blur (img)
    (if (is-image-empty? img)
        img
        (blend-color img (empty-image (img-width img) (img-height img)) 0 0)))
  
  (export IBlur))