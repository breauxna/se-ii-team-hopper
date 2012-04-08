;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module MMirror
  (import IImage)
  
  (defun mirror-horizontal (img1 img2 x y)
    (let ((w (img-width img1))
          (h (img-height img1)))
      (if (< y h)
          (if (< x w)
              (mirror-horizontal img1 (add-pixel x (- (1- h) y) (get-color x y img1) img2) (1+ x) y)
              (mirror-horizontal img1 img2 0 (1+ y)))
          img2)))
  
  (defun mirror-vertical (img1 img2 x y)
    (let ((w (img-width img1))
          (h (img-height img1)))
      (if (< y h)
          (if (< x w)
              (mirror-horizontal img1 (add-pixel (- (1- w) x) y (get-color x y img1) img2) (1+ x) y)
              (mirror-horizontal img1 img2 0 (1+ y)))
          img2)))
  
  (defun mirror (img axis)
    (cond
      ((equal axis 'horizontal)
       (mirror-horizontal img img 0 0))
      ((equal axis 'vertical)
       (mirror-vertical img img 0 0))))
  
  (export IMirror))