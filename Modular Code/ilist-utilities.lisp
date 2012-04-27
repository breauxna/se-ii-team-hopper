;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(interface IList-Utilities
  
  (sig booleanify (x))
  
  (sig first-n (n xs))
  
  ; Discards the first and last element of a list.
  (sig sandwich-material (xs))
  
  (sig chunk-by-helper (delimiter xs so-far))
  
  (sig chunk-by (delimiter xs))
  
  (sig remove-nils (xs)))




