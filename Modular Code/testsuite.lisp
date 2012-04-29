;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date April 29, 2012
;@version 1.0

;unified test suite

(require "merror.lisp")
(require "mimprovements.lisp")
(require "mstructures.lisp")
(require "mlist-utilities.lisp")
(require "mstring-utilities.lisp")
(require "mparse-queries.lisp")
(require "mparse-data.lisp")
(require "mexecute.lisp")

(require "terror.lisp")
(require "texecute.lisp")
(require "tlist-utilities.lisp")
(require "tparse-data.lisp")
(require "tparse-queries.lisp")
(require "tstring-utilities.lisp")
(require "timprovements.lisp")

(link TestSuite (MError MImprovements MStructures MList-Utilities
                        MString-Utilities MParse-Queries MParse-Data
                        MExecute
                 
                 TError TExecute TList-Utilities TParse-Data
                        TParse-Queries TString-Utilities TImprovements))
(invoke TestSuite)