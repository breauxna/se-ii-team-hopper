;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author: Nathan Breaux
;@date: Feb 20, 2012
;@version: 1.0

(require "specifications.lisp")

(module MRead-Operations
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
  (import IOperation)
  
  ;Read in file and return list of characters
  (defun read-file (file state)
    (mv-let (string error state)
            (file->string file state)
            (if error
                (mv nil error state)
                (mv (remove nil (packets-set '(#\newline #\return) 
                                             (str->chrs string))) 
                    error state))
            )
    )
  
  ;Remove spaces from list of characters
  (defun packets-spaces (chrs)
    (if (consp chrs)
        (cons (remove nil (packets-set '(#\space) (car chrs))) 
              (packets-spaces (cdr chrs)))
        nil
        )
    )
  
  ;Take in list of character and return a string
  (defun input-format-helper (chrs)
    (if (consp chrs)
        (cons (coerce (car chrs) 'string) (input-format-helper (cdr chrs)))
        nil
        )
    )
  
  ;Get the file in the proper format
  (defun input-format (chrs)
    (if (consp chrs)
        (cons (input-format-helper (car chrs)) (input-format (cdr chrs)))
        nil
        )
    )
  
  ;Give read operations list of "operation" "parameters"
  (defun read-operations-helper (ops)
    (if (consp ops)
        (cons (operation (caar ops) (cdar ops)) 
              (read-operations-helper (cdr ops)))
        nil
        )
    )
  
  ;@param file the path of the operations text file
  (defun read-operations (file)
    (read-operations-helper 
     (input-format 
                   (packets-spaces (car (read-file file state))))))
  
  (export IRead-Operations))