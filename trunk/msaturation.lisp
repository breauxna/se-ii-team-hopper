;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date:April 5, 2012
;@version: 1.0

(require "specifications.lisp")

; Module for increasing or decreasing pixel color saturation 
; based on a scale +%
(module MSaturation
  
  (import IImage)
  (import IColor)
  
  ;applies the scaled saturation value for every pixel in the image and saves
  ;as a new image
  ;@param img1 - original image
  ;@param img2 - new image after saturation is applied
  ;@param scale - the amount to saturate the image given as a %
  ;@param x - row value
  ;@param y - col value
  ;return img2 - the new image with the saturation applied
  (defun apply-sat-xy (img1 img2 scale x y)
    (if (< y (img-height img1))
        (if (< x (img-width img1))
            (let* ((colr (get-color x y img1))
                   (s (get-s colr))
                   (h (get-h colr))
                   (v (get-v colr))
                   (scaledsat (* s (/ scale 100)))
                   (scaledsat (+ s scaledsat)))
              (cond 
                ((> scaledsat 1)
                 (apply-sat-xy img1 (add-pixel x y (set-hsv (list h 1 v)) img2) scale (1+ x) y))
                ((< scaledsat 0)
                 (apply-sat-xy img1 (add-pixel x y (set-hsv (list h 0 v)) img2) scale (+ 1 x) y))
                (t (apply-sat-xy img1 (add-pixel x y (set-hsv (list h scaledsat v)) img2) scale (+ 1 x) y))))
        (apply-sat-xy img1 img2 scale 0 (+ 1 y)))
    img2))
  
  ;gets the h and w of the img and calls apply-sat-xy 
  ;param img - the original img
  ;param scale - the amount to saturate the image given as a %
  (defun saturation (img scale)
    (let* ((h (img-height img))
           (w (img-width img)))
      (if (equal img nil)
          nil
    (apply-sat-xy img (empty-image w h) scale 0 0))))
  
  (export ISaturation))