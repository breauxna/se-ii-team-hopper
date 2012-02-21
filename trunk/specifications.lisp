;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Feb 20, 2012
;@version 1.0

;Specifications files
;Contains all of the interfaces for all of the modules

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;data structures
(interface IColor
  (sig set-rgb (r g b))
  (sig set-hsv (h s v))
  (sig get-rgb (color))
  (sig get-hsv (color))
  (sig color? (color))
  (con get-rgb-types
       (implies (color? color)
                (mv-let (r g b)
                        (get-rgb color)
                        (and (and (natp r) (< r 256))
                             (and (natp g) (< r 256))
                             (and (natp b) (< r 256)))))))

(interface IHeader)

(interface IImage)

(interface IOperation)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;main function
(interface IWrapper)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;I/O
(interface IInput)

(interface IOutput)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Features
(interface ICrop)

(interface IResize)