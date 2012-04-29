;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module TList-Utilities
  
  (import IList-Utilities)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect (first-n 3 '(1 2 3 4 5))
                '(1 2 3))
  
  (check-expect (sandwich-material '(1 2 3))
                '(2))
  (check-expect (sandwich-material '(1 2))
                nil)
  (check-expect (sandwich-material '(1))
                nil)
  (check-expect (sandwich-material nil)
                nil)
  )