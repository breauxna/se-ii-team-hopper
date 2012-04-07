;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "minput.lisp")

;Testing Module for operations data structure
(module TInput
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (import IInput)
  (import IImage)
  
  (set-state-ok T)
  
  (check-expect (is-image-empty? (read-file "/home/michael/workspace/bmp_24.bmp" state)) nil)
  
  )