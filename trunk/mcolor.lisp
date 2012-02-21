;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Feb 20, 2012
;@version 1.0

;MColor module
;RGB->HSV and HSV->RGB conversion algorithms are from
;http://www.cs.rit.edu/~ncs/color/t_convert.html

(require "specifications.lisp")

(module MColor
  (defun set-rgb (r g b)
    (let* ((r2 (/ r 256))
           (g2 (/ g 256))
           (b2 (/ b 256))
           (min (min (min r2 g2) b2))
           (max (max (max r2 g2) b2))
           (v (max))
           (delta (- max min))
           (s (if (equal max 0)
                  0 ;s = 0, h is undefined
                  (/ delta max)))
           (h (if (equal max 0)
                  -1
                  (mod (+ 360
                          (* 60 ;degrees
                             (cond
                               ((equal r2 max) (/ (- g2 b2) delta)) ;between yellow and magenta
                               ((equal g2 max) (+ 2 (/ (- b2 r2) delta))) ;between cyan and yellow
                               (t (+ 4 (/ (- r2 g2) delta)))))) 360)))) ;between magenta and cyan
      (list r g b h s v)))
  
  (defun set-hsv (h s v)
    (if (equal s 0)
        (list v v v h s v) ;achromatic (grey)
        (let* ((h2 (/ h 60)) ;sector 0 to 5
               (i (floor h 1))
               (f (- h i)) ;factorial part of h
               (p (* v (- 1 s)))
               (q (* v (- 1 (* s f))))
               (tt (* v (- 1 (* s (- 1 f))))))
          (cond
            ((equal i 0) (list (* v 256) (* tt 256) (* p 256) h s v))
            ((equal i 1) (list (* q 256) (* v 256) (* p 256) h s v))
            ((equal i 2) (list (* p 256) (* v 256) (* tt 256) h s v))
            ((equal i 3) (list (* p 256) (* q 256) (* v 256) h s v))
            ((equal i 4) (list (* t 256) (* p 256) (* v 256) h s v))
            (t (list (* v 256) (* p 256) (* q 256) h s v))))))
  
  (defun get-rgb (color)
    (mv-let (r g b h s v)
            (color)
            (list r g b)))
  
  (defun get-hsv (color)
    (mv-let (r g b h s v)
            (color)
            (list h s v)))
  
  (defun color? (color)
    (mv-let (r g b h s v)
            (color)
            (and (natp r) (< r 256)
                 (natp g) (< g 256)
                 (natp b) (< b 256)
                 (natp h) (< h 361)
                 (>= s 0) (<= s 1)
                 (>= v 0) (<= v 1))))
  
  (export IColor))