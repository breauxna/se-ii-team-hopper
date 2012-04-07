;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: March 27, 2012
;@version: 1.0

(require "specifications.lisp")

;Splits an image into three images that are respectively each
;color channel. There will be a red image, a green image, and 
;a blue image
(module MSplitcolor
  (import IImage)
  (import IColor)
  
  ;Takes an image and extracts the red value and zeroes out
  ;other values recursively.
  (defun get-red-tree (img red x y)
    (if (< x (img-width img))
        (get-red-tree img 
                      (add-pixel x
                                 y
                                 (set-rgb (list (get-r (get-color x y img)) 
                                                0 
                                                0))
                                 red)  
                      (+ 1 x) 
                      y)
        (if (< y (img-height img))
            (get-red-tree img 
                          red  
                          0 
                          (+ 1 y))
            red)))
  
  ;Takes an image and extracts the green value and zeroes out
  ;other values recursively.
  (defun get-green-tree (img green x y)
    (if (< x (img-width img))
        (get-green-tree img 
                        (add-pixel x
                                   y
                                   (set-rgb (list 0 
                                                  (get-g (get-color x y img)) 
                                                  0))
                                   green)  
                        (+ 1 x) 
                        y)
        (if (< y (img-height img))
            (get-green-tree img 
                            green 
                            0 
                            (+ 1 y))
            green)))
  
  ;Takes an image and extracts the blue value and zeroes out
  ;other values recursively.
  (defun get-blue-tree (img blue x y)
    (if (< x (img-width img))
        (get-blue-tree img 
                       (add-pixel x
                                  y
                                  (set-rgb (list 0
                                                 0 
                                                 (get-b (get-color x y img))))
                                  blue)  
                       (+ 1 x) 
                       y)
        (if (< y (img-height img))
            (get-blue-tree img 
                           blue  
                           0 
                           (+ 1 y))
            blue)))
  
  ;Wrapper function that takes in an image and returns
  ;a list of three images with a red image, green image,
  ;and blue image.
  (defun splitcolor (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img)) 
             (< 0 (img-height img)))
        (list (get-red-tree img (empty-image (img-header img)) 0 0) 
              (get-green-tree img (empty-image (img-header img)) 0 0) 
              (get-blue-tree img (empty-image (img-header img)) 0 0))
        img))
  
  (export ISplitcolor))