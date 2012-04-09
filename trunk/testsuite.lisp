;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin, Kyle Morse
;@date Apr 6, 2012
;@version 1.0

(require "mmath.lisp")

(require "moperation.lisp")
(require "toperation.lisp")

(require "mcolor.lisp")
(require "tcolor.lisp")

(require "mimage.lisp")
(require "minput.lisp")
(require "tinput.lisp")

(require "mnegative.lisp")
(require "tnegative.lisp")

(link TestSuite (MMath Moperation Toperation MColor TColor MImage MInput TInput MNegative TNegative))
(invoke TestSuite)