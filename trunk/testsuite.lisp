;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin, Kyle Morse, Nathan Breaux, Michael Brandt, Toby Kraft
;@date Apr 15, 2012
;@version 1.0

(require "mblur.lisp")
(require "mborder.lisp")
(require "mbrightness.lisp")
(require "mcolor.lisp")
(require "mcolormod.lisp")
(require "mcontrast.lisp")
(require "mcrop.lisp")
(require "mgreyscale.lisp")
(require "mhistogram.lisp")
(require "mhue.lisp")
(require "mimage.lisp")
(require "mmath.lisp")
(require "mmerge.lisp")
(require "mmirror.lisp")
(require "mnegative.lisp")
(require "moperation.lisp")
(require "mresize.lisp")
(require "mrotate.lisp")
(require "msaturation.lisp")
(require "msplitcolor.lisp")
(require "mmask.lisp")
(require "mtestfunctions.lisp")

(require "tblur.lisp")
(require "tborder.lisp")
(require "tbrightness.lisp")
(require "tcolor.lisp")
(require "tcolormod.lisp")
(require "tcontrast.lisp")
(require "tcrop.lisp")
(require "tgreyscale.lisp")
(require "thistogram.lisp")
(require "thue.lisp")
(require "timage.lisp")
(require "tmath.lisp")
(require "tmask.lisp")
(require "tmerge.lisp")
(require "tmirror.lisp")
(require "tnegative.lisp")
(require "toperation.lisp")
(require "tresize.lisp")
(require "trotate.lisp")
(require "tsaturation.lisp")
(require "tsplitcolor.lisp")

(link TestSuite (MMath MColor MImage MTestFunctions MBlur MBorder
                       MBrightness MColormod MContrast MCrop
                       MGreyscale MHistogram MHue MMask MMerge MMirror
                       MNegative MOperation MResize MRotate MSaturation
                       MSplitColor
                       ;Tests
                       TBlur TBorder TBrightness TColor TColormod TContrast
                       TCrop TGreyscale THistogram THue TImage TMath
                       TMask TMerge TMirror TNegative TOperation TResize 
                       TRotate TSaturation TSplitColor
                 ))
(invoke TestSuite)