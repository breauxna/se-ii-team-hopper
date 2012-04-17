;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Nathan Breaux
;@date: March 13, 2012
;@version: 1.0

(require "specifications.lisp")

(module MCrop
  
  (import IImage)
  (import IColor)
  (import IMath)
  
  (defun build-crop-image (img1 img2 x y min-x min-y max-x max-y)
    (if (AND (natp x) (natp y) (<= y max-y) (< y (img-height img1)))
        (if (AND (<= x max-x) (< x (img-width img1)))
            (build-crop-image img1
                              (add-pixel (- x min-x) (- y min-y) 
                                         (get-color x y img1) img2)
                              (+ x 1)
                              y
                              min-x
                              min-y
                              max-x
                              max-y)
            (build-crop-image img1 img2 min-x (+ y 1)
                              min-x min-y max-x max-y))
        img2))
  
  ;Check if image is empty and return image if it is else build the crop image
  (defun crop (image x1 y1 x2 y2)
    (if (OR (is-image-empty? image) (< (- x2 x1) 0) (< (- y2 y1) 0)
            (>= y1 (img-height image)) (>= x1 (img-width image))
            (NOT (natp x1)) (NOT (natp x2)) (NOT (natp y1)) (NOT (natp y2)))
        image
        (if (OR (>= x2 (img-width image)) (>= y2 (img-height image)))
            (build-crop-image image (empty-image (- (img-width image) x1)
                                                 (- (img-height image) y1))
                              x1 y1 x1 y1 x2 y2)
            (build-crop-image image (empty-image (+ (- x2 x1) 1)
                                                 (+ (- y2 y1) 1))
                              x1 y1 x1 y1 x2 y2)
            )
        )
    )
  
  (export ICrop))