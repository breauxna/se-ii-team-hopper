;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module TColor
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (import IColor)
  
  ;set-rgb tests
  (check-expect (set-rgb nil)nil)
  (check-expect (set-rgb '(-19 0 0)) nil)
  (check-expect (set-rgb '(0 0 0)) '(0 0 0 0 0 0))
  (check-expect (set-rgb '(30/255 30/255 30/255))
                '(30/255 30/255 30/255 0 0 2/17))
  (check-expect (set-rgb '(30/255 60/255 90/255))
                '(30/255 60/255 90/255 7/12 2/3 6/17))
  (check-expect (set-rgb '(0 0 255/255)) '(0 0 255/255 2/3 1 1))
  (check-expect (set-rgb '(255/255 0 255/255))
                '(255/255 0 255/255 5/6 1 1))
  (check-expect (set-rgb '(255/255 0 0)) '(255/255 0 0 0 1 1))
  
  ;set-hsv tests
  (check-expect (set-hsv nil) nil)
  (check-expect (set-hsv '(2 0 0)) nil)
  (check-expect (set-hsv '(0 0 0)) '(0 0 0 0 0 0))
  (check-expect (set-hsv '(1/2 0 0)) '(0 0 0 1/2 0 0))
  (check-expect (set-hsv '(1/4 1/2 1/2)) '(3/8 1/2 1/4 1/4 1/2 1/2))
  (check-expect (set-hsv '(1 1 1)) '(255/255 0 0 1 1 1))
  (check-expect (set-hsv '(0 0 1)) '(255/255 255/255 255/255 0 0 1))
  (check-expect (set-hsv '(0 1 1)) '(255/255 0 0 0 1 1))
  
  ;get-rgb tests
  (check-expect (get-rgb '(0 0 0 0 0 0)) '(0 0 0))
  (check-expect (get-rgb '(30/255 30/255 30/255 0 0 2/17))
                '(30/255 30/255 30/255))
  (check-expect (get-rgb '(30/255 60/255 90/255 7/12 2/3 6/17))
                '(30/255 60/255 90/255))
  
  ;get-hsv tests
  (check-expect (get-hsv '(0 0 0 0 0 0)) '(0 0 0))
  (check-expect (get-hsv '(30/255 30/255 30/255 0 0 2/17)) '(0 0 2/17))
  (check-expect (get-hsv '(30/255 60/255 90/255 7/12 2/3 6/17))
                '(7/12 2/3 6/17))
  
  ;get-r tests
  (check-expect (get-r '(0 0 0 0 0 0)) 0)
  (check-expect (get-r '(30/255 30/255 30/255 0 0 2/17)) 30/255)
  (check-expect (get-r '(30/255 60/255 90/255 7/12 2/3 6/17)) 30/255)
  
  ;get-g tests
  (check-expect (get-g '(0 0 0 0 0 0)) 0)
  (check-expect (get-g '(30/255 30/255 30/255 0 0 2/17)) 30/255)
  (check-expect (get-g '(30/255 60/255 90/255 7/12 2/3 6/17)) 60/255)
  
  ;get-b tests
  (check-expect (get-b '(0 0 0 0 0 0)) 0)
  (check-expect (get-b '(30/255 30/255 30/255 0 0 2/17)) 30/255)
  (check-expect (get-B '(30/255 60/255 90/255 7/12 2/3 6/17)) 90/255)
  
  ;get-h tests
  (check-expect (get-h '(0 0 0 0 0 0)) 0)
  (check-expect (get-h '(30/255 30/255 30/255 0 0 2/17)) 0)
  (check-expect (get-h '(30/255 60/255 90/255 7/12 2/3 6/17)) 7/12)
  
  ;get-s tests
  (check-expect (get-s '(0 0 0 0 0 0)) 0)
  (check-expect (get-s '(30/255 30/255 30/255 0 0 2/17)) 0)
  (check-expect (get-s '(30/255 60/255 90/255 7/12 2/3 6/17)) 2/3)
  
  ;get-v tests
  (check-expect (get-v '(0 0 0 0 0 0)) 0)
  (check-expect (get-v '(30/255 30/255 30/255 0 0 2/17)) 2/17)
  (check-expect (get-v '(30/255 60/255 90/255 7/12 2/3 6/17)) 6/17)
  
  ;color? tests
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
    (equal (list r g b)
           (get-rgb (set-hsv (get-hsv (set-rgb (list r g b)))))))
  )