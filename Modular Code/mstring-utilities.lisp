;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@date April 22, 2012

(require "specifications.lisp")

(module MString-Utilities
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
  (import IList-Utilities)
  (import IError)
  
  (defun strs->chrss (strs)
    (if (endp strs)
        nil
        (cons (str->chrs (first strs))
              (strs->chrss (rest strs)))))
  
  (defun chrss->strs (chrss)
    (if (endp chrss)
        nil
        (cons (chrs->str (first chrss))
              (chrss->strs (rest chrss)))))
  
  (defun whitespacep (c)
    (member-equal c '(#\space #\newline #\return #\tab)))
  
  (defun quotationp (c)
    (member-equal c '(#\")))
  
  (defun alphanump (c)
    (booleanify (and (characterp c)
                     (or (alpha-char-p c)
                         (digit-char-p c)))))
  
  (defun make-string (x)
    (cond ((stringp x)
           x)
          ((characterp x)
           (coerce (list x) 'string))
          ((character-listp x)
           (coerce x 'string))
          ((rationalp x)
           (rat->str x 0))))
  
  (defun has-prefix (xs prefix)
    (or (endp prefix)
        (and (equal (first xs) 
                    (first prefix))
             (has-prefix (rest xs) 
                         (rest prefix)))))
  
  (defun cut-keyword (cs keywords)
    (if (endp keywords)
        (mv nil cs)
        (if (has-prefix cs (first keywords))
            (mv (first keywords) 
                (nthcdr (length (first keywords)) cs))
            (cut-keyword cs (rest keywords)))))
  
  (defun cut-alphanum (cs)
    (if (alphanump (first cs))
        (mv-let (word remainder)
                (cut-alphanum (rest cs))
                (mv (cons (first cs) word) 
                    remainder))
        (mv nil cs)))
  
  (defun cut-to-quotation (cs)
    (if (endp cs)
        (mv (make-error "Missing closing quotation mark")
            nil)
        (if (quotationp (first cs))
            (mv (list (first cs)) (rest cs))
            (mv-let (word remainder)
                    (cut-to-quotation (rest cs))
                    (mv (error-cons (first cs) word)
                        remainder)))))
  
  (defun string+ (xs)
    (if (endp xs)
        ""
        (concatenate 'string (make-string (first xs))
                     (string+ (rest xs)))))
  
  (defun break-by-line (str)
    (chrs->str-all (tokens '(#\NewLine #\return) (str->chrs str))))
  
  (export IString-Utilities))

