;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MList-Utilities
  ;added include-book
  (include-book "list-utilities" :dir :teachpacks)
  
  ; Converts a character to a boolean
  (defun booleanify (x)
    (not (not x)))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;simplified algorithm
  (defun first-n (n xs) 
    (car (break-at-nth n xs)))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Discards the first and last element of a list.
  (defun sandwich-material (xs)
    (if (> (length xs) 1)
        (rest (first-n (1- (length xs)) xs))
        nil))
  
  (defun chunk-by-helper (delimiter xs so-far)
    (cond ((endp xs)
           (list (reverse so-far)))
          ((equal delimiter (first xs))
           (cons (reverse so-far)
                 (chunk-by-helper delimiter (rest xs) (cons (first xs) nil))))
          (t
           (chunk-by-helper delimiter (rest xs) (cons (first xs) so-far))))) 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;modifieid output to match the correct output
  (defun chunk-by (delimiter xs)
    (cdr (chunk-by-helper delimiter xs nil)))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (export IList-Utilities))