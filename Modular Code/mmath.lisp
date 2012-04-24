;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 24, 2012
;@version 1.0

(require "specifications.lisp")

(module MMath
  (defun count (nums)
    (len nums))
  
  (defun sum (nums)
    (if (and (consp nums) (rational-listp nums))
        (+ (car nums) (sum (cdr nums)))
        0))
  
  (defun mean (nums)
    (if (and (consp nums) (rational-listp nums))
        (/ (sum nums) (len nums))
        nil))
  
  (defun difference-square-sum (nums avg)
    (if (and (consp nums) (rational-listp nums) (rationalp avg))
        (+ (expt (- (car nums) avg) 2) (difference-square-sum (cdr nums) avg))
        0))
  
  (defun population-variance (nums)
    (if (and (consp nums) (rational-listp nums))
        (/ (difference-square-sum nums (mean nums)) (len nums))
        nil))
  
  (defun sample-variance (nums)
    (if (and (consp (cdr nums)) (rational-listp nums))
        (/ (difference-square-sum nums (mean nums)) (1- (len nums)))
        nil))
  
  (defun maximum (nums)
    (if (rational-listp nums)
        (if (consp (cdr nums))
            (max (car nums) (maximum (cdr nums)))
            (if (equal (len nums) 1)
                (car nums)
                nil))
        nil))
  
  (defun minimum (nums)
    (if (rational-listp nums)
        (if (consp (cdr nums))
            (min (car nums) (minimum (cdr nums)))
            (if (equal (len nums) 1)
                (car nums)
                nil))
        nil))
        
  (export IMath))