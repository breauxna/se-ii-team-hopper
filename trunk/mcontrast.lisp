;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date: April 6, 2012
;@version: 1.0

(require "specifications.lisp")

; Module for adjusting the contrast of an image based on a scalar value
; specifying a scalar value > 100% will increase contrast by making brighter pixels 
; brighter and darker ones darker. A scalar < 100% will do the opposite
(module MContrast
 
  (import IImage)
  (import IColor)
  
  ;given a value, places in the range [0,1] for color
  ;@param num - a value for color
  ;@return number - [0,1]
  (defun find-val-in-range (num)
    (cond
      ((> num 1) 1)
      ((< num 0) 0)
      (t num)))
  
  ;recursively adjusts the contrast of each pixel by applying the contrast to 
  ;the r, g, and b vals independently and returns a new image with the 
  ;applied contrast
  ;@param img1 - original image
  ;@param img2 - new image
  ;@param x - row value
  ;@param y - col value
  ;@param contrast - value that determines the application of contrast
  ;@return img2 - an image with the applied contrast
  (defun contrast-adjust (img1 img2 x y contrast)
    (if (< y (img-height img1))
        (if (< x (img-width img1))
            (let* ((newr (+ .5 (* contrast (- (get-r (get-color x y img1)) .5))))
                   (newg (+ .5 (* contrast (- (get-g (get-color x y img1)) .5))))
                   (newb (+ .5 (* contrast (- (get-b (get-color x y img1)) .5)))))
              (contrast-adjust img1 (add-pixel x y (set-rgb (list (find-val-in-range newr)
                                                                  (find-val-in-range newg)
                                                                  (find-val-in-range newb))) img2) (+ x 1) y contrast))
        (contrast-adjust img1 img2 0 (+ 1 y) contrast))
    img2))
  
  ;gets the height and width of the image to pass to the contrast-adjust function
  ;@param img - original image
  ;@param scalar - value of the contrast in +%
  ;@return img - an image with the applied contrast
  (defun contrast (img scalar)
    (let* ((h (img-height img))
           (w (img-width img))
           (scale (/ scalar 100)))
      (if (equal img nil)
          nil
      (contrast-adjust img (empty-image w h) 0 0 scale))))
  
  (export IContrast))