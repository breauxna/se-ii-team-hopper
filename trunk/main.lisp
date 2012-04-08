;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

(require "mmath.lisp")
(require "mcolor.lisp")
(require "mimage.lisp")
(require "moperation.lisp")
(require "mread-operations.lisp")
(require "minput.lisp")
(require "mblur.lisp")
(require "mborder.lisp")
(require "mcolormod.lisp")
(require "mcontrast.lisp")
(require "mcrop.lisp")
(require "mdespeckle.lisp")
(require "mgreyscale.lisp")
(require "mhistogram.lisp")
(require "mhue.lisp")
(require "mmerge.lisp")
(require "mmirror.lisp")
(require "mnegative.lisp")
(require "moutput.lisp")
(require "mresize.lisp")
(require "mrotate.lisp")
(require "msaturation.lisp")
(require "msplitcolor.lisp")

(module MMain
  (set-state-ok t)
  
  (import IInput)
  (import INegative)
  (import IOperation)
  (import IOutput)
  (import IRead-Operations)
  
  (defun main (ops-file bmp-input bmp-output)
    (write-bmp-file (negative (read-bmp-file bmp-input)) bmp-output))
  
  (export IMain))

(link Run (MMath MColor MImage MOperation MRead-Operations
                  MInput MBlur MBorder MColormod MContrast
                  MCrop MDespeckle MGreyscale MHistogram MHue
                  MMerge MMirror MNegative MOutput MResize
                  MRotate MSaturation MSplitcolor MMain))
(invoke Run)