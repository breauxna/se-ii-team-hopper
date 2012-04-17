;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin and Nathan Breaux
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module MTestFunctions
  (import IImage)
  
  ;Check if tree contains color
  (defun color-in-image-tree? (img1 color x y)
    (if (and (natp x) (natp y) (< y (img-height img1)))
        (if (< x (img-width img1))
            (if (equal (get-color x y img1)
                       color)
                (color-in-image-tree? img1 color (1+ x) y)
                nil)
            (color-in-image-tree? img1 color 0 (1+ y)))
        t))
  
  (defun image-tree-equal? (img1 img2 x y)
    (if (and (equal (img-width img1)
                    (img-width img2))
             (equal (img-height img1)
                    (img-height img2)))
        (if (and (natp x) (natp y) (< y (img-height img1)))
            (if (< x (img-width img1))
                (if (equal (get-color x y img1)
                           (get-color x y img2))
                    (image-tree-equal? img1 img2 (1+ x) y)
                    nil)
                (image-tree-equal? img1 img2 0 (1+ y)))
            t)
        nil))
  
  (defun image-equal? (img1 img2)
    (image-tree-equal? img1 img2 0 0))
  
  (defun color-in-image? (img1 color)
    (color-in-image-tree? img1 color 0 0))
  
  (export ITestFunctions))