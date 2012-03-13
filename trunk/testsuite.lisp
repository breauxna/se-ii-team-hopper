;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin, Kyle Morse
;@date Mar 13, 2012
;@version 1.0

(require "moperation.lisp")
(require "toperation.lisp")

(require "mcolor.lisp")
(require "tcolor.lisp")

(link TestSuite (Moperation Toperation MColor TColor))
(invoke TestSuite)