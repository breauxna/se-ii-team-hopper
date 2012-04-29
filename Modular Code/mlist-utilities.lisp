;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MList-Utilities
  ;added include-book
  (include-book "list-utilities" :dir :teachpacks)
  
  ; Converts a character to a boolean
  (defun booleanify (x)
    (not (not x)))
  
  ; Takes the first n values of xs
  ;  (defun first-n (n xs) 
  ;    (if (equal 0 n)
  ;        nil
  ;        (cons (first xs)
  ;              (first-n (1- n) (rest xs)))))
  
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
  
  ; Separates a list of xs into chunks starting with a given delimiter
  ; (chunk-by 'foo '(foo 1 2 foo 3 4))
  ; ->
  ; '((foo 1 2) (foo 3 4))
  ;@param delimiter - single delimiter
  ;  (defun chunk-by (delimiter xs)
  ;    (chunk-by-helper delimiter xs nil))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;modifieid output to match the correct output
  (defun chunk-by (delimiter xs)
    (cdr (chunk-by-helper delimiter xs nil)))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Removes nil values from a list
  ;  (defun remove-nils (xs)
  ;    (cond ((endp xs)
  ;           nil)
  ;          ((null (first xs))
  ;           (remove-nils (rest xs)))
  ;          (t
  ;           (cons (first xs)
  ;                 (remove-nils (rest xs))))))
  
  (export IList-Utilities))