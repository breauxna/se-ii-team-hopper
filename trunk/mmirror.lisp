;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

;MMirror flips an image along an axis (horizontal or vertical
(module MMirror
  (import IImage)
  
  ;mirror-horizontal recursively flips each pixel horizontally across
  ;the middle of the picture
  ;@param img1 - original image
  ;@param img2 - new image
  ;@param x - current x location
  ;@param y - curernt y location
  ;@return img - newly flipped image
  (defun mirror-horizontal (img1 img2 x y)
    (if (is-image-empty? img1)
        img1
        (let ((w (img-width img1))
              (h (img-height img1)))
          (if (< y h)
              (if (< x w)
                  (mirror-horizontal img1
                                     (add-pixel x
                                                (- (1- h) y)
                                                (get-color x y img1)
                                                img2)
                                     (1+ x)
                                     y)
                  (mirror-horizontal img1 img2 0 (1+ y)))
              img2))))
  
  ;mirror-vertical recursively flips each pixel vertically across the middle of the picture
  ;@param img1 - original image
  ;@param img2 - new image
  ;@param x - current x location
  ;@param y - curernt y location
  ;@return img - newly flipped image
  (defun mirror-vertical (img1 img2 x y)
    (if (is-image-empty? img1)
        img1
        (let ((w (img-width img1))
              (h (img-height img1)))
          (if (< y h)
              (if (< x w)
                  (mirror-vertical img1
                                   (add-pixel (- (1- w) x)
                                              y
                                              (get-color x y img1)
                                              img2)
                                   (1+ x)
                                   y)
                  (mirror-vertical img1 img2 0 (1+ y)))
              img2))))
  
  ;mirror flips an image along the given axis
  ;@param img - original image
  ;@param axis - x or y
  ;@return img - newly flipped image
  (defun mirror (img axis)
    (if (is-image-empty? img)
        img
        (cond
          ((equal axis 'x)
           (mirror-horizontal img
                              (empty-image (img-width img)
                                           (img-height img))
                              0
                              0))
          ((equal axis 'y)
           (mirror-vertical img
                            (empty-image (img-width img)
                                         (img-height img))
                            0
                            0)))))
  
  (export IMirror))