;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date April 28, 2012
;@version 1.0

(require "specifications.lisp")

(module mimprovements
  (defun is-mantissa (str)
    (if (and (stringp str) (> (length str) 0))
        (if (> (length str) 1)
            (and (digit-char-p (char str 0))
                 (is-mantissa (subseq str 1 (length str))))
            (digit-char-p (char str 0)))
        nil))
  
  (defun is-decimal (str)
    (if (and (stringp str) (> (length str) 0))
        (if (> (length str) 1)
            (if (equal (char str 0) #\.)
                (is-mantissa (subseq str 1 (length str)))
                (and (digit-char-p (char str 0))
                     (is-decimal (subseq str 1 (length str)))))
            (or (digit-char-p (char str 0))
                (equal (char str 0) #\.)))
        nil))
  
  (defun new-is-numeric (str)
    (if (and (stringp str) (> (length str) 0))
        (if (> (length str) 1)
            (and (or (equal (char str 0) #\-)
                     (equal (char str 0) #\+)
                     (digit-char-p (char str 0)))
                 (is-decimal (subseq str 1 (length str))))
            (digit-char-p (char str 0)))
        nil))
  
  (defun new-is-string (token)
    (and (stringp token)
         (equal (char token 0) #\")
         (equal (char token (1- (length token))) #\")))
  
  (export iimprovements))