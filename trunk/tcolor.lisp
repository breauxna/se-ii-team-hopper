;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

(require "mcolor.lisp")

(module TColor
  (import IColor)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect (set-rgb nil) nil)
  (check-expect (set-rgb '(-19 0 0)) nil)
  (check-expect (set-rgb '(0 0 0)) '(0 0 0 0 0 0))
  (check-expect (set-rgb '(30/255 30/255 30/255)) '(30/255 30/255 30/255 0 0 2/17))
  (check-expect (set-rgb '(30/255 60/255 90/255)) '(30/255 60/255 90/255 7/12 2/3 6/17))
  (check-expect (set-rgb '(0 0 255/255)) '(0 0 255/255 2/3 1 1))
  (check-expect (set-rgb '(255/255 0 255/255)) '(255/255 0 255/255 5/6 1 1))
  (check-expect (set-rgb '(255/255 0 0)) '(255/255 0 0 0 1 1))
  
  (check-expect (set-hsv nil) nil)
  (check-expect (set-hsv '(2 0 0)) nil)
  (check-expect (set-hsv '(0 0 0)) '(0 0 0 0 0 0))
  (check-expect (set-hsv '(1/2 0 0)) '(0 0 0 1/2 0 0))
  (check-expect (set-hsv '(1/4 1/2 1/2)) '(3/8 1/2 1/4 1/4 1/2 1/2))
  (check-expect (set-hsv '(1 1 1)) '(255/255 0 0 1 1 1))
  (check-expect (set-hsv '(0 0 1)) '(255/255 255/255 255/255 0 0 1))
  (check-expect (set-hsv '(0 1 1)) '(255/255 0 0 0 1 1))
  
  (check-expect (get-rgb '(0 0 0 0 0 0)) '(0 0 0))
  (check-expect (get-rgb '(30/255 30/255 30/255 0 0 2/17)) '(30/255 30/255 30/255))
  (check-expect (get-rgb '(30/255 60/255 90/255 7/12 2/3 6/17)) '(30/255 60/255 90/255))
  
  (check-expect (get-hsv '(0 0 0 0 0 0)) '(0 0 0))
  (check-expect (get-hsv '(30/255 30/255 30/255 0 0 2/17)) '(0 0 2/17))
  (check-expect (get-hsv '(30/255 60/255 90/255 7/12 2/3 6/17)) '(7/12 2/3 6/17))
  
  (check-expect (color? nil) nil)
  (check-expect (color? '(0 0 0 0 0 0)) t)
  (check-expect (color? '(30/255 60/255 90/255 7/12 2/3 6/17)) t)
  (check-expect (color? '(30/255 60/255 90/255 0 0 0)) nil)
  (check-expect (color? '(-30/255 60/255 90/255 7/12 2/3 6/17)) nil)
  (check-expect (color? '(30/255 60/255 90/255 -7/12 2/3 6/17)) nil)
  
  (defproperty rgb-round-trip :repeat 100
    (r :value (random-rational)
       :where (and (>= r 0) (<= r 1))
     g :value (random-rational)
       :where (and (>= g 0) (<= g 1))
     b :value (random-rational)
       :where (and (>= b 0) (<= b 1)))
    (equal (list r g b) (get-rgb (set-hsv (get-hsv (set-rgb (list r g b)))))))
  )