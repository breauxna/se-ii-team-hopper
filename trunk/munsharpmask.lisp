;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

(require "specifications.lisp")

(module MUnsharpmask
  (import IBlur)
  (import IImage)
  (import IMath)
  
  (defun unsharpmask (img)
    (blur img 0 0 (distance 0 0 (img-width img) (img-height img))))
  
  (export IUnsharpmask))