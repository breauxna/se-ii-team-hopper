;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IStructures.lisp")
(require "MStructures.lisp")

(module TStructures
  
  (import IStructures)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect t t)
  

	; can't really test a structure...
  )

(link RTStructures (MStructures TStructures))
(invoke RTStructures)