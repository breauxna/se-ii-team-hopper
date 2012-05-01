;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MParse-Data
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (import IError)
  (import IImprovements)
  (import IString-Utilities)
  
  ; Converts a string delimited by commas to a list of tokens
  ;@param string, i.e. "team,date,points,assists"
  ;@return list of strings, i.e. '("team" "date" "points" "assists")
  (defun str->tkns (str)
    (chrs->str-all (tokens '(#\,) (str->chrs str))))
  
  ; Converts a list of strings to a list of list of tokens
  ;@param list of strings, i.e. '("BOS,20120101,85,20" "BOS,20120102,93,23" "CHI,20120102,76,14")
  ;@return list of list of strings, i.e. '(("BOS" "20120101" "85" "20") ("BOS" "20120102" "93" "23") ("CHI" "20120102" "76" "14"))
  (defun strs->tknss (strs)
    (if (endp strs)
        nil
        (cons (str->tkns (first strs))
              (strs->tknss (rest strs)))))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;checks to see if an entire token is a valid number before conversion
  (defun tkns->row (header-tkns str-tkns)
    (if (endp header-tkns)
        nil
        (let* ((tkn (first str-tkns))
               (val (if (is-numeric tkn)
                        (str->rat tkn)
                        tkn)))
          (cons (cons (first header-tkns) val)
                (tkns->row (rest header-tkns) (rest str-tkns))))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Given a list of header tokens, converts a list of lists of tokens to a list of data rows
  ; (See example)
  ;@param header-tkns - list of strings, i.e. '("team" "date" "points" "assists")
  ;@param str-tknss - list of list of strings, i.e. '(("BOS" "20120101" "85" "20") ("BOS" "20120102" "93" "23") ("CHI" "20120102" "76" "14"))
  ;@return list of rows of '("field" . value) pairs, i.e.
  ;'((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20))
  ;  (("team" . "BOS") ("date" . 20120102) ("points" . 93) ("assists" . 23))
  ;  (("team" . "CHI") ("date" . 20120102) ("points" . 76) ("assists" . 14)))
  (defun tknss->rows (header-tkns str-tknss)
    (if (endp str-tknss)
        nil
        (cons (tkns->row header-tkns (first str-tknss))
              (tknss->rows header-tkns (rest str-tknss)))))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;kyle, Youming Lin
  ; Given a list of types and a single row of data it will
  ; check the row to make sure it is the right length and
  ; are made up of the right types
  ;@param types i.e. '("string" "number" "number" "number")
  ;@param row i.e. '("BOS" "20120101" "85" "20")
  ;@return t or nil based on if it passes tests
  (defun right-types (types row)
    (if (and (consp types) (consp row))
        (if (or (and (string-equal (car types) "string")
                     (stringp (car row)))
                (and (string-equal (car types) "number")
                     (is-numeric (car row))))
            (right-types (cdr types) (cdr row))
            (make-error "Incorrect data type!"))
        (if (and (endp types) (endp row))
            t
            (make-error "Incorrect number of columns!"))))
  
  ;kyle, Youming Lin
  ; Given a list of types and a list of rows it will
  ; check each row to make sure it is the right length and
  ; are made up of the right types
  ;@param types i.e. '("string" "number" "number" "number")
  ;@param row i.e. '(("BOS" "20120101" "85" "20") ("BOS" "20120102" "93" "23") ("CHI" "20120102" "76" "14"))
  ;@return t or nil based on if it passes tests
  (defun right-data (types rows)
    (if (consp rows)
        (let ((type-check (right-types types (car rows))))
          (if (error-p type-check)
              type-check
              (right-data types (cdr rows))))
        t))
  
  ;kyle, Youming Lin
  ; Converts the data string (with header and data)
  ; to data rows (("field1" . value1) ... ("fieldn" . value2))
  ;@param string, i.e. "team,date,points,assists\r\nstring,number,string,string\r\nBOS,20120101,85,20\r\nBOS,20120102,93,23\r\nCHI,20120102,76,14"
  ;@return list of '("field" . value) pairs or nil if the data is incorrectly formatted
  (defun str->rows (str)
    (let* ((strs (break-by-line str))
           (header-tkns (str->tkns (first strs)))
           (types-tkns (str->tkns (second strs)))
           (row-tknss (strs->tknss (cddr strs)))
           (type-check (right-data types-tkns row-tknss)))
      (cond
        ((error-p type-check)
         type-check)
        (t
         (tknss->rows header-tkns row-tknss)))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (export IParse-Data))