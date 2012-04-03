;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 3 2012
;@version 1.0

;Specifications files
;Contains all of the interfaces for all of the modules

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;data structures
(interface IColor
  (sig set-rgb (rgb))
  (sig set-hsv (hsv))
  (sig get-rgb (color))
  (sig get-hsv (color))
  (sig get-r (color))
  (sig get-g (color))
  (sig get-b (color))
  (sig get-h (color))
  (sig get-s (color))
  (sig get-v (color))
  (sig color? (color)))

(interface IHeader)

(interface IImage
  (sig image (hdr tree))
  (sig add-pixel (x y color img))
  (sig get-color (x y img))
  (sig empty-image (hdr))
  (sig is-image-empty? (img))
  (sig img-header (img))
  (sig change-size (width height img))
  (sig img-height (img))
  (sig img-width (img)))

(interface IOperation
  (sig operation (op args)))

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

(interface IMerge
  (sig merge (img1 img2 dir)))