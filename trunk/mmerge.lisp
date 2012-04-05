;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5 2012
;@version 1.0

(require "specifications.lisp")

(module MMerge
  (import IImage)
  
  (defun merge-right (img1 img2 x y)
    (if (< y (img-height img2))
        (if (< x (img-width img2))
            (merge-right (add-pixel (+ x (img-width img1)) y (get-color x y img2) img1) img2 (1+ x) y)
            (merge-right img1 img2 0 (1+ y)))
        img1))
  
  (defun merge-down (img1 img2 x y)
    (if (< y (img-height img2))
        (if (< x (img-width img2))
            (merge-right (add-pixel x (+ y (img-height img1)) (get-color x y img2) img1) img2 (1+ x) y)
            (merge-right img1 img2 0 (1+ y)))
        img1))
  
  (defun merge (img1 img2 dir)
    (let* ((w1 (img-width img1))
           (w2 (img-width img2))
           (h1 (img-height img1))
           (h2 (img-height img2)))
      (cond
        ((equal dir 'up)
         (if (equal w1 w2)
             (change-size w1 (+ h1 h2) (merge-down img2 img1 0 0))
             img1))
        ((equal dir 'down)
         (if (equal w1 w2)
             (change-size w1 (+ h1 h2) (merge-down img1 img2 0 0))
             img1))
        ((equal dir 'left)
         (if (equal h1 h2)
             (change-size (+ w1 w2) h1 (merge-right img2 img1 0 0))
             img1))
        ((equal dir 'right)
         (if (equal h1 h2)
             (change-size (+ w1 w2) h1 (merge-right img1 img2 0 0))
             img1))
        (t img1))))
  
  (export IMerge))