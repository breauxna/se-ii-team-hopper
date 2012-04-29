;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "MImprovements.lisp")
(require "MStructures.lisp")
(require "MError.lisp")
(require "MList-Utilities.lisp")
(require "MString-Utilities.lisp")
(require "MParse-Queries.lisp")
(require "MParse-Data.lisp")
(require "MExecute.lisp")
(require "MRun.lisp")


(link RRun (MImprovements MStructures MError MList-Utilities
                          MString-Utilities MParse-Queries MParse-Data
                          MExecute MRun
                     ))

(invoke RRun)

; To run,call method run on the following parameters:
;  data-in:   address of the data file (string)
;  query-in:  address of the query file (string)
;  f-out:     address of the output file (string)

; example:
;  (run "data.txt" "query.txt" "output.txt")