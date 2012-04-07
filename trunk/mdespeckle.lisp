;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: March 31, 2012
;@version: 1.0

(require "specifications.lisp")

;Takes in an image and tones down any bright points.
;It measures brightness by being 20% more than the surrounding
;pixels. If this happens then it will average the colors around it
;and the actual pixel to dull the color out a little.
(module MDespeckle
  (import IImage)
  (import IColor)
  
  ;Takes a list of colors and finds the average brightness of them
  (defun average-brightness (colors avg total)
    (if (consp colors)
        (if (= (car colors) nil)
            (average-brightness (cdr colors) avg (- total 1))
            (average-brightness (cdr colors) 
                                (+ avg (get-brightness (car colors)))
                                total))
        (/ avg total)))
  
  ;Takes a list of colors and returns a color data structure that
  ;is the average of all the r's, g's, and b's
  (defun average-color (colors avg total)
    (if (consp colors)
        (if (= (car colors) nil)
            (average-color (cdr colors) avg (- total 1))
            (average-color (cdr colors) 
                           (set-rgb (list (+ (get-r (car colors)) (get-r avg))
                                          (+ (get-g (car colors)) (get-g avg))
                                          (+ (get-b (car colors)) (get-b avg))))
                           total))
        (set-rgb (list (/ (get-r avg) total)
                       (/ (get-g avg) total)
                       (/ (get-b avg) total)))))
  
  ;If the current position is bright then returns the average color and
  ;if not then just return current color
  (defun is-bright (img x y)
    (let ((colorC (get-color x y img)) 
          (colorL (get-color (- x 1) y img))
          (colorR (get-color (+ x 1) y img))
          (colorU (get-color x (+ y 1) img))
          (colorD (get-color x (- y 1) img)))
      (if (> (get-brightness colorC) 
             (* 1.2 (average-brightness (list colorL
                                              colorR
                                              colorU
                                              colorD)
                                        0
                                        4)))
          (average-color (list colorL
                               colorR
                               colorU
                               colorD)
                         (set-rgb (list (get-r colorC) 
                                        (get-g colorC) 
                                        (get-b colorC)))
                         5)
          colorC)))
  
  ;Recursive function that does the despeckle operation
  (defun do-despeckle (old-img new-img x y)
    (if (< x (img-width old-img))
        (do-despeckle old-img 
                      (add-pixel x
                                 y
                                 (is-bright old-img x y)
                                 new-img)  
                      (+ 1 x) 
                      y)
        (if (< y (img-height old-img))
            (do-despeckle old-img 
                          new-img  
                          0 
                          (+ 1 y))
            new-img)))
  
  ;Wrapper function that takes an image and checks to make sure
  ;width and height is correct. If it is, it performs the operation
  ;If not then it returns the original image
  (defun despeckle (img)
    (if (and (not (is-image-empty? img))
             (< 0 (img-width img)) 
             (< 0 (img-height img)))
        (do-despeckle img (empty-image img) 0 0)
        img))
  
  (export IDespeckle))