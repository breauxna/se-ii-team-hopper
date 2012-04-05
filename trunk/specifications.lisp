;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 5, 2012
;@version 1.0

;Specifications files
;Contains all of the interfaces for all of the modules

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;data structures
(interface IColor
  ;checks to see if a list of r, g, and b values falls within to proper ranges
  (sig rgb? (rgb))
  
  ;checks to see if a list of h, s, and v values falls within to proper ranges
  (sig hsv? (hsv))
  
  ;generates a color data structure given r, g, and b values
  ;red, green, blue are [0, 1]
  (sig set-rgb (rgb))
  
  ;generates a color data structure given h, s, and v values
  ;hue, saturation, and value are [0, 1]
  (sig set-hsv (hsv))
  
  ;returns the r, g, and b values of the color
  (sig get-rgb (color))
  
  ;returns the h, s, and v values of the color
  (sig get-hsv (color))
  
  ;returns the r value of the color
  (sig get-r (color))
  
  ;returns the g value of the color
  (sig get-g (color))
  
  ;returns the b value of the color
  (sig get-b (color))
 
  ;returns the h value of the color 
  (sig get-h (color))
  
  ;returns the s value of the color
  (sig get-s (color))
  
  ;returns the v value of the color
  (sig get-v (color))
  
  ;checks to see whether or not the given list is a proper color structure
  (sig color? (color)))

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
;helper modules
(interface IMath
  (sig sum (nums))
  (sig average (nums))
  (sig distance (x1 y1 x2 y2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;main function
(interface IWrapper)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;I/O
(interface IInput)

(interface IOutput)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Features
(interface IBlur
  (sig blur (img x y radius)))

(interface IBorder)

(interface ICrop)

(interface IContrast)

(interface IDespeckle)

(interface IGreyscale)

(interface IHistogram)

(interface IHue)

(interface IMask
  (sig mask (img1 img2)))

(interface IMerge
  (sig merge (img1 img2 dir)))

(interface IMirror
  (sig mirror (img axis)))

(interface INegative)

(interface IResize)

(interface IRotate)

(interface ISaturation)

(interface ISplitcolor)

(interface IUnsharpmask
  (sig unsharpmask (img)))