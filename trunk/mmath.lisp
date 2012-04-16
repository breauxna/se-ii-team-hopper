;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

(require "specifications.lisp")

;MMath provides some commonly used functions
(module MMath
  ;finds sum of a list of numbers
  ;@param nums - list of numbers
  ;@return sum - sum of the list of numbers
  (defun sum (nums)
    (if (consp nums)
        (+ (car nums) (sum (cdr nums)))
        0))
  
  ;finds average of a list of numbers
  ;@param nums - list of numbers
  ;@param avg - average of the list of numbers
  (defun average (nums)
    (/ (sum nums) (len nums)))
 
  (export IMath))