;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Toby Kraft
;@date: Mar 10, 2012
;@version: 1.0

(require "specifications.lisp")

; Module for resizing an image based on a scale given as a %.
(module MResize  
  
  (import IImage)
  
  ; uses nearest-neighbor pixel resixe algorithm to shrink the image based on a scale
  (defun shrink-xy (scale x y img1 img2 w2 h2 hratio wratio)
    (if (< y h2)
        (if (< x w2)
            (let * ((px (floor (* x wratio)))
                    (py (floor (* y hratio))))
              (shrink-xy scale (+ x 1) y img1 (add-pixel x y (get-color px py img1) img2) w2 h2 hratio wratio)))
        (shrink-xy scale 0 (+ 1 y) img1 img2 w2 h2 hratio wratio))
    (change-size w2 h2 img2))
  
  ; finds the old width and height, calculates the new h&w, finds a height ratio and width ratio, and
  ; passes data to shrink-xy function
  (defun shrink-scale (scale img1 img2)
   (let* ((w1 (img-width img1))
           (w2 (round (* w1 (/ scale 100)) 1))
           (h1 (img-height img1))
           (h2 (round (* h1 (/ scale 100)) 1))
           (hratio (/ h1 h2))
           (wratio (/ w1 w1)))
      
    (shrink-xy scale 0 0 img1 img2 w2 h2 hratio wratio)))
  
   ; uses nearest neighbor pixel resize to enlarge given image 
  (defun enlarge-xy (scale x y img1 img2 w2 h2 hratio wratio) 
    (if (< y h2)
        (if (< x w2)
            (let * ((px (floor (* x wratio)))
                    (py (floor (* y hratio))))
              (enlarge-xy scale (+ x 1) y img1 (add-pixel x y (get-color px py img1) img2) w2 h2 hratio wratio)))
        (enlarge-xy scale 0 (+ 1 y) img1 img2 w2 h2 hratio wratio))
    img2)
  
  ; finds the old width and height, calculates the new h&w, finds a height ratio and width ratio, and
  ; passes data to enlarge-xy function
  (defun enlarge-scale (scale img1 img2)
    (let* ((w1 (img-width img1))
           (w2 (round (* w1 (/ scale 100)) 1))
           (h1 (img-height img1))
           (h2 (round (* h1 (/ scale 100)) 1))
           (hratio (/ h1 h2))
           (wratio (/ w1 w1)))
      
    (enlarge-xy scale 0 0 img1 (change-size w2 h2 img2) w2 h2 hratio wratio)))
  
  ; calls the enlarge function if scale is > 100%, calls shrink if scale is <100%, or returns the image is scale == 100%
  (defun resize-scale (img scale)
    (if (> scale 0)
        (cond
          ((equal scale 100)
           img)
          ((> scale 100)
           (enlarge-scale scale img (empty-image (get-header img))))
          ((< scale 100)
           (shrink-scale scale img (empty-image (get-header img))))))
    img)
  (export IResize))