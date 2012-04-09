;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 8, 2012
;@version 1.0

;Specifications files
;Contains all of the interfaces for all of the modules

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;data structures

;MColor is the underlying color data structure for image manipulation
;each color structure is '(r g b h s v)
(interface IColor
  ;checks to see if a list of r, g, and b values falls within to proper ranges
  (sig rgb? (rgb))
  
  ;checks to see if a list of h, s, and v values falls within to proper ranges
  (sig hsv? (hsv))
  
  ;generates a color data structure given a list of r, g, and b values
  ;red, green, blue are [0, 1]
  (sig set-rgb (rgb))
  
  ;generates a color data structure given a list of h, s, and v values
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

;MImage is the underlying data structure for bitmap image manipulation
(interface IImage
  (sig empty-image (width height))
  (sig add-pixel (x y color img))
  (sig get-color (x y img))
  (sig img-width (img))
  (sig img-height (img))
  (sig change-size (width height img))
  (sig is-image-empty? (img)))

(interface IOperation
  (sig operation (op args)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MMath provides some commonly used functions
(interface IMath
  ;returns sum of a list of numbers
  (sig sum (nums))
  
  ;returns the average of a list of numbers
  (sig average (nums)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;main function
(interface IMain
  (sig main (ops-file bmp-input bmp-output)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;I/O
(interface IInput
  (sig read-bmp-file (path)))

(interface IRead-Operations
  (sig read-operations (file)))

(interface IOutput
  (sig write-bmp-file (img path)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Features

;blur blurs the entire image
(interface IBlur
  (sig blur (img)))

;@param img bitmap image
;@param border-size size of the border in pixels
;@param border-color color of the border (color data structure)
;Adds specified border size and color to image
(interface IBorder
  (sig border (img border-size border-color)))

(interface IBrightness
  (sig brightness (img amount)))

;@param image bitmap image
;@param target-color an rgb color structure of the color to change
;@param radius creates a range around the target-color from (tc-r - tc+r)
;@param update-color change all target-colors to this rgb color
(interface IColormod
  (sig colormod (image target-color radius update-color)))

(interface IContrast
  (sig contrast (img scalar)))

;@param img bitmap image
;@param (x1, y1) bottom-left data point
;@param (x2, y2) top-right data point
;Crop the image from (x1, y1) to (x2, y2)
(interface ICrop
  (sig crop (img x1 y1 x2 y2)))

(interface IGreyscale
  (sig greyscale (img)))

;histogram generates a CSV formatted string for output
(interface IHistogram
  ;generates a frequenct table for r, g, b, h, s, v, and brightness
  ;values for a given image
  (sig histogram (img)))

;@param img bitmap image
;@param hue-value hue-value between 0-1
;Adds specificed hue value each pixel in picture
(interface IHue
  (sig hue (img hue-value)))

;merges two imgs in a given direction
;direction - up, down, left, or right
(interface IMerge
  (sig merge (img1 img2 dir)))

;mirrors an image according to axis of reflection
;axis - horizontal or vertical
(interface IMirror
  (sig mirror (img axis)))

(interface INegative
  (sig negative (img)))

(interface IResize
  (sig resize-scale (img scale)))

(interface IRotate
  (sig rotate (img degrees)))

(interface ISaturation
  (sig saturation (img scale)))

(interface ISplitcolor
  (sig splitcolor (img color)))