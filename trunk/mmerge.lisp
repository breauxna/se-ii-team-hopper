;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

(require "specifications.lisp")

;MMerge merges two images together given the merge direction
(module MMerge
  (import IImage)
  
  ;merge-right merges img2 to the right of img1
  ;@param img1 - image to the left
  ;@param img2 - image to the right
  ;@param x - current x location in img2
  ;@param y - current y location in img2
  ;@return img - newly merged image
  (defun merge-right (img1 img2 x y)
    (if (< y (img-height img2))
        (if (< x (img-width img2))
            (merge-right (add-pixel (+ x (img-width img1)) y (get-color x y img2) img1) img2 (1+ x) y)
            (merge-right img1 img2 0 (1+ y)))
        img1))
  
  ;merge-down merges img2 to the bottom of img1
  ;@param img1 - image on top
  ;@param img2 - image at the bottom
  ;@param x - current x location in img2
  ;@param y - current y location in img2
  ;@return img - newly merged image
  (defun merge-down (img1 img2 x y)
    (if (< y (img-height img2))
        (if (< x (img-width img2))
            (merge-right (add-pixel x (+ y (img-height img1)) (get-color x y img2) img1) img2 (1+ x) y)
            (merge-right img1 img2 0 (1+ y)))
        img1))
  
  ;merge merges img1 with img2 given the merge direction
  ;@param img1 - first image
  ;@param img2 - second image
  ;@param dir - merge direction of img2 relative to img1
  ;@return img - newly merged image
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