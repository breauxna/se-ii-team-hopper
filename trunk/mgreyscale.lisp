;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date:April 5, 2012
;@version: 1.0

(require "specifications.lisp")

; Module that applies a greyscale to an img that results in a new "black-and-white" image
(module MGrayscale
  
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  (import IImage)
  (import IColor)
  
  ;applies the greyscale to every pixel of the original image and returns a new image
  (defun greyscale-xy (img1 img2 x y h w)
     (if (< y h)
        (if (< x w)
            (let* ((r (get-r (get-color x y img1)))
                   (g (get-g (get-color x y img1)))
                   (b (get-b (get-color x y img1)))
                   (r-grey (* r .30))
                   (g-grey (* g .59))
                   (b-grey (* b .11)))
              (greyscale-xy img1 (add-pixel x y (set-rgb (list r-grey g-grey b-grey)) img2) (+ 1 x) y h w)))
        (greyscale-xy img1 img2 0 (+ 1 y) h w))
    img2)
  
  ;gets the h and w from the image, and calls greyscale-xy to apply greyscaling
  (defun greyscale (img)
    (let* ((h (img-height img))
           (w (img-height img)))
    (greyscale-xy img (empty-image (img-header img)) 0 0 h w))) 
  
  (export IGreyscale))