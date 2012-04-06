;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;TODO: contrast
;@author: Toby Kraft
;@date:April 5, 2012
;@version: 1.0

(require "specifications.lisp")

; Module for increasing or decreasing pixel color saturation based on a scale %
(module MSaturation
  
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  (import IImage)
  (import IColor)
  
  ;applies the scaled saturation value for every pixel in the image and saves
  ;as a new image
  (defun apply-sat-xy (img1 img2 scale x y h w)
    (if (< y h)
        (if (< x w)
            (let* ((rgb (get-color (x y img1)))
                   (r (get-r (get-color x y img1)))
                   (g (get-g (get-color x y img1)))
                   (b (get-b (get-color x y img1)))
                   (s (get-s (rgb)))
                   (h (get-h (rgb)))
                   (v (get-v (rgb)))
                   (scaledsat (* s (/ 100 scale)))
                   (scaledhsv (set-hsv (list r g b h scaledsat v)))
                   (scaledcolor (get-rgb scaledhsv)))
              (apply-sat-xy img1 (add-pixel (x y scaledcolor img2)) scale (+ 1 x) y h w)))
        (apply-sat-xy img1 img2 scale 0 (+ 1 y) h w))
    img2)
  
  ;gets the h and w of the img and calls apply-sat-xy 
  (defun saturation (img scale)
    (let* ((h (img-height img))
           (w (img-height img)))
    (apply-sat-xy img (empty-image (img-header img)) scale 0 0 h w)))
  
  (export ISaturation))