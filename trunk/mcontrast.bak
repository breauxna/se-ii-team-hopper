;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date:April 6, 2012
;@version: 1.0

(require "specifications.lisp")

; Module for adjusting the contrast of an image based on a scalar value
(module MContrast
 
  (import IImage)
  (import IColor)
  
  ;recursively adjusts the contrast of each pixel by applying the contrast to the r, g, and b vals independently
  ;and returns a new image with the applied contrast
  (defun contrast-adjust (img1 img2 x y contrast h w)
    (if (< y h)
        (if (< x w)
            (let* ((newr (+ .5 (* contrast (- .5 (get-r (get-color x y img1))))))
                   (newg (+ .5 (* contrast (- .5 (get-g (get-color x y img1))))))
                   (newb (+ .5 (* contrast (- .5 (get-b (get-color x y img1)))))))
              (contrast-adjust img1 (add-pixel x y (set-rgb (list newr newg newb)) img2) (+ x 1) y contrast h w)))
        (contrast-adjust img1 img2 0 (+ 1 y) contrast h w))
    img2)
  
  ;gets the height and width of the image to pass to the contrast-adjust function
  (defun contrast (img scalar)
    (let* ((h (img-height img))
           (w (img-width img)))
      (contrast-adjust img (empty-image (img-header img)) 0 0 scalar h w)))
  
  (export IContrast))
 