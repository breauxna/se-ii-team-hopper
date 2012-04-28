;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "iimprovements.lisp")

(module mimprovements
  (defun is-string (token)
    (and (equal (char token 0) #\")
         (equal (char token (1- (length token))) #\")))
  
  (export iimprovements))