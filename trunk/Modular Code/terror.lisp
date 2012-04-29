;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module TError
  (import IError)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect t t)
  
  (defproperty make-error-propogates-error
    (msg :value (random-string))
    (equal (make-error msg) (cons :error msg)))
  
  (defproperty error-p-equals-first-x-is-:error
    (x   :value (random-list-of (random-string)) :where (consp x))
    (equal (error-p x) (equal :error (first x))))
 
  (defproperty error-p-equals-first-x-is-:error-2
    (x   :value (cons :error (random-list-of (random-string))))
    (equal (error-p x) (equal :error (first x))))
)