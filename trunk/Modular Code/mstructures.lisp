;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IStructures.lisp")

(module MStructures
  
  (defstructure query
    fields
    filter)
  
  (defstructure query-result
    fields
    rows)
  
  (export IStructures))