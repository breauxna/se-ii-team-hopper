;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IRun.lisp")
(require "IExecute.lisp")

(module MRun
  
  (import IExecute)
  
  (include-book "io-utilities" :dir :teachpacks)
  
  (defun read-transform-write (data-in query-in f-out state)
    (mv-let (rows error-open state)
            (file->string data-in state)
            (if error-open
                (mv error-open state)
                (mv-let (queries error-open state)
                        (file->string query-in state)
                        (if error-open
                            (mv error-open state)
                            
                            (mv-let (error-close state)
                                    (string-list->file f-out
                                                       (list (queries-data-str->query-results-str rows queries))
                                                       state)
                                    (if error-close
                                        (mv error-close state)
                                        (mv (concatenate 'string
                                                         "Input files: "
                                                         data-in
                                                         ", "
                                                         query-in
                                                         " - Output files: "
                                                         f-out)
                                            state))))))))
  
  (defun run (data-in query-in f-out)
    (read-transform-write data-in query-in f-out state))
  
  (export IRun))