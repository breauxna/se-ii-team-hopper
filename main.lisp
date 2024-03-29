;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin, Michael Brandt
;@date Apr 8, 2012
;@version 1.0

(require "mmath.lisp")
(require "mcolor.lisp")
(require "mimage.lisp")
(require "moperation.lisp")
(require "mread-operations.lisp")
(require "minput.lisp")
(require "mblur.lisp")
(require "mborder.lisp")
(require "mbrightness.lisp")
(require "mcolormod.lisp")
(require "mcontrast.lisp")
(require "mcrop.lisp")
(require "mgreyscale.lisp")
(require "mhistogram.lisp")
(require "mhue.lisp")
(require "mmask.lisp")
(require "mmerge.lisp")
(require "mmirror.lisp")
(require "mnegative.lisp")
(require "moutput.lisp")
(require "mresize.lisp")
(require "mrotate.lisp")
(require "msaturation.lisp")
(require "msplitcolor.lisp")

(module MMain
  (include-book "io-utilities" :dir :teachpacks)
  (set-state-ok t)
  
  (import IBrightness)
  (import IBorder)
  (import IBlur)
  (import IContrast)
  (import IColormod)
  (import ICrop)
  (import IGreyscale)
  (import IHistogram)
  (import IHue)
  (import IInput)
  (import IMask)
  (import IMirror)
  (import IMerge)
  (import INegative)
  (import IOperation)
  (import IOutput)
  (import IRead-Operations)
  (import IResize)
  (import IRotate)
  (import ISaturation)
  (import ISplitcolor)
  
  (defun perform-op (operation img)
    (if (listp operation)
        (let ((args (cadr operation))
              (op (car operation)))
          (cond ((equal op 'crop)
                 (crop img (first args) (second args) (third args)
                       (fourth args)))
                ((equal op 'colormod)
                 (colormod img (first args) (second args) (third args)))
                ((equal op 'blur)
                 (blur img))
                ((equal op 'mask)
                 (mask img (read-bmp-file (first args))))
                ((equal op 'merge)
                 (merge img (read-bmp-file (first args)) (second args)))
                ((equal op 'border) 
                 (border img (first args) (second args)))
                ((equal op 'negative)
                 (negative img))
                ((equal op 'histogram) 
                 (let ((out 
                        (string-list->file (first args)
                                           (histogram img) 
                                           state)))
                   img))
                 ((equal op 'rotate)
                  (rotate img (first args)))
                 ((equal op 'resize) 
                  (resize-scale img (first args)))
                 ((equal op 'greyscale)
                  (greyscale img))
                 ((equal op 'saturation)
                  (saturation img (first args)))
                 ((equal op 'contrast)
                  (contrast img (first args)))
                 ((equal op 'splitcolor)
                  (splitcolor img (first args)))
                 ((equal op 'mirror)
                  (mirror img (first args)))
                 ((equal op 'hue)
                  (hue img (first args)))
                 ((equal op 'brightness)
                  (brightness img (first args)))
                 (t nil)))
          nil))
    
    (defun process-ops (ops img-in)
      (if (endp ops)
          img-in
          (process-ops (cdr ops) (perform-op (car ops) img-in))))
    
    (defun main (ops-file bmp-input bmp-output)
      (let ((ops (read-operations ops-file))
            (img-in (read-bmp-file bmp-input)))
        (write-bmp-file (process-ops ops img-in) bmp-output)))
    
    (export IMain))
  
  (link Run (MMath MColor MImage MOperation MRead-Operations
                   MInput MBlur MBorder MBrightness MColormod
                   MContrast MCrop MGreyscale MHistogram MHue
                   MMask MMerge MMirror MNegative MOutput MResize
                   MRotate MSaturation MSplitcolor MMain))
  (invoke Run)