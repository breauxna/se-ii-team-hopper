;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Mar 13, 2012
;@version 1.0

;MColor module
;RGB->HSV and HSV->RGB conversion algorithms are from
;http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

(require "specifications.lisp")

(module MColor
  
  (defun rgb? (r g b)
    (and (natp r) (< r 256)
         (natp g) (< g 256)
         (natp b) (< b 256)))
  
  (defun hsv? (h s v)
    (and (rationalp h) (>= h 0) (<= h 1)
         (rationalp s) (>= s 0) (<= s 1)
         (rationalp v) (>= v 0) (<= v 1)))
  
  ;red, green, blue are [0, 255]
  (defun set-rgb (red green blue)
    (if (rgb? red green blue)
        (let* ((r (/ red 255))
               (g (/ green 255))
               (b (/ blue 255))
               (minimum (min (min r g) b))
               (maximum (max (max r g) b))
               (v maximum)
               (delta (- maximum minimum))
               (s (if (equal maximum 0)
                      0 ;s = 0, h is undefined
                      (/ delta maximum)))
               (h ( / (if (equal maximum minimum)
                          0 ;achromatic
                          (cond
                            ((equal maximum r) (+ (/ (- g b) delta)
                                                  (if (< g b)
                                                      6
                                                      0)))
                            ((equal maximum g) (+ (/ (- b r) delta) 2))
                            ((equal maximum b) (+ (/ (- r g) delta) 4))))
                      6)))
          (list red green blue h s v))
        nil))
  
  (defun set-hsv (h s v)
    (if (hsv? h s v)
        (let* ((i (floor (* h 6) 1))
               (f (- (* h 6) i))
               (p (* v (- 1 s)))
               (q (* v (- 1 (* f s))))
               (u (* v (- 1 (* (- 1 f) s)))))
          (cond
            ((equal (mod i 6) 0) (list (round (* v 255) 1) (round (* u 255) 1) (round (* p 255) 1) h s v))
            ((equal (mod i 6) 1) (list (round (* q 255) 1) (round (* v 255) 1) (round (* p 255) 1) h s v))
            ((equal (mod i 6) 2) (list (round (* p 255) 1) (round (* v 255) 1) (round (* u 255) 1) h s v))
            ((equal (mod i 6) 3) (list (round (* p 255) 1) (round (* q 255) 1) (round (* v 255) 1) h s v))
            ((equal (mod i 6) 4) (list (round (* u 255) 1) (round (* p 255) 1) (round (* v 255) 1) h s v))
            ((equal (mod i 6) 5) (list (round (* v 255) 1) (round (* p 255) 1) (round (* q 255) 1) h s v))))
        nil))
  
  (defun get-rgb (color)
    (mv-let (r g b h s v)
            color
            (list r g b)))
  
  (defun get-hsv (color)
    (mv-let (r g b h s v)
            color
            (list h s v)))
  
  (defun color? (color)
    (if (equal (len color) 6)
        (mv-let (r g b h s v)
                color
                (and (natp r) (< r 256)
                     (natp g) (< g 256)
                     (natp b) (< b 256)
                     (rationalp h) (>= h 0) (<= h 1)
                     (rationalp s) (>= s 0) (<= s 1)
                     (rationalp v) (>= v 0) (<= v 1)
                     (equal (set-rgb r g b) color)))
        nil))
  
  (export IColor))