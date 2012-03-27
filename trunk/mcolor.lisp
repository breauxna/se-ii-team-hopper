;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Mar 27, 2012
;@version 1.0

;MColor module
;RGB->HSV and HSV->RGB conversion algorithms are from
;http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

(require "specifications.lisp")

(module MColor
  (defun rgb? (rgb)
    (if (equal (len rgb) 3)
        (mv-let (r g b)
                rgb
                (and (rationalp r) (>= r 0) (<= r 1)
                     (rationalp g) (>= g 0) (<= g 1)
                     (rationalp b) (>= b 0) (<= b 1)))
        nil))
  
  (defun hsv? (hsv)
    (if (equal (len hsv) 3)
        (mv-let (h s v)
                hsv
                (and (rationalp h) (>= h 0) (<= h 1)
                     (rationalp s) (>= s 0) (<= s 1)
                     (rationalp v) (>= v 0) (<= v 1)))
        nil))
  
  ;red, green, blue are [0, 1]
  (defun set-rgb (rgb)
    (if (rgb? rgb)
        (mv-let (r g b)
                rgb
                (let* ((minimum (min (min r g) b))
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
                  (list r g b h s v)))
        nil))
  
  (defun set-hsv (hsv)
    (if (hsv? hsv)
        (mv-let (h s v)
                hsv
                (let* ((i (floor (* h 6) 1))
                       (f (- (* h 6) i))
                       (p (* v (- 1 s)))
                       (q (* v (- 1 (* f s))))
                       (u (* v (- 1 (* (- 1 f) s)))))
                  (cond
                    ((equal (mod i 6) 0) (list v u p h s v))
                    ((equal (mod i 6) 1) (list q v p h s v))
                    ((equal (mod i 6) 2) (list p v u h s v))
                    ((equal (mod i 6) 3) (list p q v h s v))
                    ((equal (mod i 6) 4) (list u p v h s v))
                    ((equal (mod i 6) 5) (list v p q h s v)))))
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
                (and (rgb? (list r g b)) (hsv? (list h s v)) (equal (set-rgb (list r g b)) color)))
        nil))
  
  (export IColor))