;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Nathan Breaux
;@date: March 13, 2012
;@version: 1.0

(require "specifications.lisp")

(module MCrop
  
  (import IImage)
  (import IColor)
  (import IMath)
  
  ;Move along the x-axis until you reach x2 then move back to x1 with y1 increased by 1,
  ;if reach (x2, y2) insert (x2, y2)
  (defun build-crop-image (image x1 y1 x2 y2 x-count crop-image)
                    (if (AND (> x-count x2) (equal y1 y2))
                        (add-pixel x-count y1 (get-color x-count y1 image) crop-image)
                        (if (> x-count x2)
                            (build-crop-image image x1 (+ y1 1) x2 y2 x1 crop-image)
                            (build-crop-image image x1 y1 x2 y2 (+ x-count 1)
                                             (add-pixel x-count y1 (get-color x-count y1 image) crop-image))
                            )
                        )
                    )
  
  ;Check if image is empty and return image if it is else build the crop image
  (defun crop (image x1 y1 x2 y2)
        (if (is-image-empty? image)
            image
            (build-crop-image image x1 y1 x2 y2 x1 (empty-image (img-header image)))
            )
        )
  (export ICrop)
  )