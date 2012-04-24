;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IString-Utilities.lisp")
(require "MString-Utilities.lisp")
(require "IList-Utilities.lisp")
(require "MList-Utilities.lisp")
(require "IError.lisp")
(require "MError.lisp")

(module TString-Utilities
  
  (import IString-Utilities)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect (alphanump #\a) t)
  (check-expect (alphanump #\B) t)
  (check-expect (alphanump #\3) t)
  (check-expect (alphanump #\space) nil)
  (check-expect (alphanump #\') nil)
  
  (check-expect (mv-let (word remainder)
                        (cut-alphanum '(#\c #\a #\t #\+ #\d #\o #\g))
                        word)
                '(#\c #\a #\t))
  
  (check-expect (break-by-line "dogs
cats")
                '("dogs" "cats"))
  )

(link RTString-Utilities (MError
                          MList-Utilities 
                          MString-Utilities 
                          TString-Utilities))
(invoke RTString-Utilities)