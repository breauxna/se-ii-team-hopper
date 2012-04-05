;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module MMath
  ;finds sum of a list of numbers
  (defun sum (nums)
    (if (consp nums)
        (+ (car nums) (sum (cdr nums)))
        0))
  
  ;finds average of a list of numbers
  (defun average (nums)
    (/ (sum nums) (len nums)))
  
  ;Estimates ((x1 - x2)^2 + (y1 - y2)^2)^0.5 using Taylor series
  ;From http://en.wikipedia.org/wiki/Square_root#Properties
  (defun distance (x1 y1 x2 y2)
    (if (and (rationalp x1) (rationalp y1) (rationalp x2) (rationalp y2))
        (let ((x (1- (+ (expt (- x1 x2) 2) (expt (- y1 y2) 2)))))
          (- (+ (- (1+ (/ x 2))
                   (/ (expt x 2) 8))
                (/ (expt x 3) 16))
             (* 5/128 (expt x 4))))
        nil))
  
  (export IMath))