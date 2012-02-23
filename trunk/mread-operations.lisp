;@author: Nathan Breaux
;@date: Feb 20, 2012
;@version: 1.0

;(require "specifications.lisp")

(module Mread-operations
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
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
  
  (defun packets-spaces (chrs)
    (if (consp chrs)
        (cons (remove nil (packets-set '(#\space) (car chrs))) 
              (packets-spaces (cdr chrs)))
        nil
        )
    )
  
  (defun input-format-helper (chrs)
    (if (consp chrs)
        (cons (coerce (car chrs) 'string) (input-format-helper (cdr chrs)))
        nil
        )
    )
  
  (defun input-format (chrs)
    (if (consp chrs)
        (cons (input-format-helper (car chrs)) (input-format (cdr chrs)))
        nil
        )
    )
  
  (defun read-operations-helper (ops)
    (if (consp ops)
        (cons (operation (caar ops) (cdar ops)) 
              (read-operations-helper (cdr ops)))
        nil
        )
    )
  
  (defun read-operations (file)
    (read-operations-helper 
     ((input-list (input-format 
                   (packets-spaces (car (read-file file state))))))
     )
    )
  
  ;(export Iread-operations)
  )
  