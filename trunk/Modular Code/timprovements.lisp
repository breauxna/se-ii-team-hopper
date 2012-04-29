;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date April 29, 2012
;@version 1.0

;timprovements

(require "specifications.lisp")

(module TImprovements
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "testing" :dir :teachpacks)
  
  (import IImprovements)
  
  (check-expect (is-numeric "00.123") 3)
  (check-expect (is-numeric "abcd") nil)
  (check-expect (is-numeric "-00.123") 3)
  (check-expect (is-numeric "\00.123") nil)
  
  (check-expect (is-string "\"BOS\"") t)
  (check-expect (is-string "\"BOS") nil)
  (check-expect (is-string "BOS") nil)
  (check-expect (is-string "\"BOS\"sdfd") nil)
  (check-expect (is-string "1234") nil)
  
  (defproperty interger-is-numeric :repeat 100
    (x :value (random-integer))
    (is-numeric (rat->str x 0)))
  
  (defproperty quotes-sandwich-is-string :repeat 100
    (str :value (random-string))
    (is-string (concatenate 'string "\"" str "\"")))
  )