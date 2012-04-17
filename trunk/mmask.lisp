;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Michael Brandt
;@date Apr 9, 2012
;@version 1.0

(require "specifications.lisp")

;MMask masks the first image with the second image
(module MMask
  (import IImage)
  (import IColor)
  
  ;perform-mask recurses through the images and
  ;multiplies v values together to produce the masked image
  ;@param img1 - image to be masked
  ;@param img2 - mask
  ;@param x - current x location in both images
  ;@param y - current y location in both images
  ;@return img - newly masked image
  (defun perform-mask (img1 img2 x y)
    (if (is-image-empty? img1)
        img2
        (if (is-image-empty? img2)
            img1
            (if (and (natp x) (natp y) (< y (img-height img2)))
                (if (< x (img-width img2))
                    (perform-mask (add-pixel 
                                   x y 
                                   (let ((color (get-color x y img1)))
                                     (set-hsv 
                                      (list (get-h color) 
                                            (get-s color)
                                            (* (get-v color) 
                                               (get-v 
                                                (get-color
                                                 x y img2))))))
                                   img1) 
                                  img2 (1+ x) y)
                    (perform-mask img1 img2 0 (1+ y)))
                img1))))
  
  ;masks img1 with img2 (v=1: transparent, v=0: opaque)
  ;@param img1 - first image
  ;@param img2 - second image
  ;@return img - newly masked image
  (defun mask (img1 img2)
    (if (is-image-empty? img1)
        img2
        (if (is-image-empty? img2)
            img1
            (let* ((w1 (img-width img1))
                   (w2 (img-width img2))
                   (h1 (img-height img1))
                   (h2 (img-height img2)))
              (if (and (equal w1 w2) (equal h1 h2))
                  (perform-mask img1 img2 0 0)
                  img1)))))
  
  (export IMask))