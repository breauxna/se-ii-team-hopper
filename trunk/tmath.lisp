;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

(module TMath
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (import IMath)
  
  (check-expect (sum nil) 0)
  (check-expect (sum '(1)) 1)
  
  (check-expect (average '(10)) 10)
  (check-expect (average '(1 2)) 3/2)
  
  (defproperty inductive-sum :repeat 100
    (xs :value (random-list-of (random-rational))
        :where (consp xs))
    (equal (+ (car xs) (sum (cdr xs))) (sum xs)))
  
  (defproperty average-round-trip :repeat 100
    (xs :value (random-list-of (random-rational))
        :where (consp xs))
    (equal (/ (sum xs) (len xs)) (average xs)))
  
  )