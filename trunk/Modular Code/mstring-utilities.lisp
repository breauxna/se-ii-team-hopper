;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MString-Utilities
  
  (import IList-Utilities)
  (import IError)
  
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  ;@param strs - list of strings
  ;@return list of list of characters
  (defun strs->chrss (strs)
    (if (endp strs)
        nil
        (cons (str->chrs (first strs))
              (strs->chrss (rest strs)))))
  
  ;@param chrss - list of list of characters
  ;@return list of strings
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
  
  ;@param string, i.e. "team,date,points,assists\r\nBOS,20120101,85,20\r\nBOS,20120102,93,23\r\nCHI,20120102,76,14"
  ;@return list of strings, i.e. '("team,date,points,assists" "BOS,20120101,85,20" "BOS,20120102,93,23" "CHI,20120102,76,14")
  (defun break-by-line (str)
    (chrs->str-all (tokens '(#\NewLine #\return) (str->chrs str))))
  
  (export IString-Utilities))

