;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: March 25, 2012
;@version: 1.0

(require "specifications.lisp")

;Takes an image and rotates it by the designated amount
;of degrees. The degrees has to be dividable by 90. There
;are separate methods for 90, 180, and 270 in order to 
;not have to rotate multiple times for a single rotate
(module MRotate
  (import IImage) 
  
  ;Recursive function to rotate image 90 degress.
  (defun rotate90 (old new x y)
    (if (< x (img-width old))
        (rotate90 old 
                  (add-pixel y 
                             (- (- (img-width old) x) 1) 
                             (get-color x y old) 
                             new)  
                  (+ 1 x) 
                  y)
        (if (< y (img-height old))
            (rotate90 old 
                      new  
                      0 
                      (+ 1 y))
            (change-size (img-width old)
                         (img-height old) 
                         new)))) 
  
  ;Checks if image has proper height and width and then performs
  ;a rotation of 90 degrees
  (defun rotate90-check (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img))
             (< 0 (img-height img)))
        (rotate90 img (empty-image img) 0 0)
        img))
  
  ;Recursive function to rotate image 180 degress.
  (defun rotate180 (old new x y)
    (if (< x (img-width old))
        (rotate180 old 
                   (add-pixel (- (- (img-width old) x) 1)
                              (- (- (img-height old) y) 1)
                              (get-color x y old) 
                              new)  
                   (+ 1 x) 
                   y)
        (if (< y (img-height old))
            (rotate180 old 
                       new  
                       0 
                       (+ 1 y))
            new)))
  
  ;Checks if image has proper height and width and then performs
  ;a rotation of 180 degrees
  (defun rotate180-check (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img))
             (< 0 (img-height img)))
        (rotate180 img (empty-image img) 0 0)
        img))
  
  ;Recursive function to rotate image 270 degress.
  (defun rotate270 (old new x y)
    (if (< x (img-width old))
        (rotate270 old 
                   (add-pixel (- (- (img-height old) y) 1) 
                              x 
                              (get-color x y old) 
                              new)  
                   (+ 1 x) 
                   y)
        (if (< y (img-height old))
            (rotate270 old 
                       new  
                       0 
                       (+ 1 y))
            (change-size (img-width old) 
                         (img-height old) 
                         new))))
  
  ;Checks if image has proper height and width and then performs
  ;a rotation of 270 degrees
  (defun rotate270-check (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img)) 
             (< 0 (img-height img)))
        (rotate270 img (empty-image img) 0 0)
        img))
  
  ;Wrapper function to rotate an image. It checks if degrees
  ;is greater than 360 and if so will keep subtracting till
  ;it is less so it doesn't have to do multiple rotations. 
  ;It then will perform the 270, 180, or 90 rotation if that 
  ;is what the degrees is and if it is anything else then it
  ;will just return the original image
  (defun rotate (img degrees)
    (if (and (posp degrees) (equal (mod degrees 90) 0))
        (if (>= degrees 360)
            (rotate img (- degrees 360))
            (cond ((= degrees 270) (rotate270-check img))
                  ((= degrees 180) (rotate180-check img))
                  ((= degrees 90) (rotate90-check img))
                  (t img)))
        img))
  
  (export IRotate))