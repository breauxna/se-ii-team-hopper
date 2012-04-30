;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MError
  
  (defun make-error (msg)
    (cons :error msg))
  
  (defun error-p (x)
    (and (consp x)
         (equal :error (first x))))
  
  (defun error-cons (x y)
    (cond ((error-p x)
           x)
          ((error-p y)
           y)
          (t (cons x y))))
  
  (export IError))