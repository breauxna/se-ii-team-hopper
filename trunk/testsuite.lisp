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

(link TestSuite (MMath Moperation Toperation MColor TColor MImage MInput TInput))
(invoke TestSuite)