;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

;MColor module
;RGB->HSV and HSV->RGB conversion algorithms are from
;http://mjijackson.com/2008/02/rgb-to-hsl-and-rgb-to-hsv-color-model-conversion-algorithms-in-javascript

(require "specifications.lisp")

;MColor is the underlying color data structure for image manipulation
;each color structure is '(r g b h s v)
(module MColor
  (import IMath)
  
  ;checks to see if a list of r, g, and b values falls within to proper ranges
  ;@param rgb - '(r g b)
  ;@return boolean - whether or not the given list is a proper rgb value
  (defun rgb? (rgb)
    (if (equal (len rgb) 3)
        (mv-let (r g b)
                rgb
                (and (rationalp r) (>= r 0) (<= r 1)
                     (rationalp g) (>= g 0) (<= g 1)
                     (rationalp b) (>= b 0) (<= b 1)))
        nil))
  
  ;checks to see if a list of h, s, and v values falls within to proper ranges
  ;@param hsv - '(h s v)
  ;@return boolean - whether or not the given list is a proper hsv value
  (defun hsv? (hsv)
    (if (equal (len hsv) 3)
        (mv-let (h s v)
                hsv
                (and (rationalp h) (>= h 0) (<= h 1)
                     (rationalp s) (>= s 0) (<= s 1)
                     (rationalp v) (>= v 0) (<= v 1)))
        nil))
  
  ;generates a color data structure given r, g, and b values
  ;red, green, blue are [0, 1]
  ;@param rgb - '(r g b)
  ;@return color - the color value '(r g b h s v) for the given rgb
  (defun set-rgb (rgb)
    (if (rgb? rgb)
        (mv-let (r g b)
                rgb
                (let* ((minimum (min (min r g) b))
                       (maximum (max (max r g) b))
                       (v maximum)
                       (delta (- maximum minimum))
                       (s (if (equal maximum 0)
                              0 ;s = 0, h is undefined
                              (/ delta maximum)))
                       (h ( / (if (equal maximum minimum)
                                  0 ;achromatic
                                  (cond
                                    ((equal maximum r) (+ (/ (- g b) delta)
                                                          (if (< g b)
                                                              6
                                                              0)))
                                    ((equal maximum g) (+ (/ (- b r) delta) 2))
                                    ((equal maximum b) (+ (/ (- r g) delta) 4))))
                              6)))
                  (list r g b h s v)))
        nil))
  
  ;generates a color data structure given h, s, and v values
  ;hue, saturation, and value are [0, 1]
  ;@param hsv - '(h s v)
  ;@return color - the color value '(r g b h s v) for the given rgb
  (defun set-hsv (hsv)
    (if (hsv? hsv)
        (mv-let (h s v)
                hsv
                (let* ((i (floor (* h 6) 1))
                       (f (- (* h 6) i))
                       (p (* v (- 1 s)))
                       (q (* v (- 1 (* f s))))
                       (u (* v (- 1 (* (- 1 f) s)))))
                  (cond
                    ((equal (mod i 6) 0) (list v u p h s v))
                    ((equal (mod i 6) 1) (list q v p h s v))
                    ((equal (mod i 6) 2) (list p v u h s v))
                    ((equal (mod i 6) 3) (list p q v h s v))
                    ((equal (mod i 6) 4) (list u p v h s v))
                    ((equal (mod i 6) 5) (list v p q h s v)))))
        nil))
  
  ;returns the r, g, and b values of the color
  ;@param color - color value
  ;@return rgb - '(r g b)
  (defun get-rgb (color)
    (mv-let (r g b h s v)
            color
            (list r g b)))
  
  ;returns the h, s, and v values of the color
  ;@param color - color value
  ;@return hsv - '(h s v)
  (defun get-hsv (color)
    (mv-let (r g b h s v)
            color
            (list h s v)))
  
  ;returns the r value of the color
  ;@param color - color value
  ;@return r - r value
  (defun get-r (color)
    (nth 0 color))
  
  ;returns the g value of the color
  ;@param color - color value
  ;@return g - g value
  (defun get-g (color)
    (nth 1 color))
  
  ;returns the b value of the color
  ;@param color - color value
  ;@return b - b value
  (defun get-b (color)
    (nth 2 color))
 
  ;returns the h value of the color
  ;@param color - color value
  ;@return h - h value
  (defun get-h (color)
    (nth 3 color))
  
  ;returns the s value of the color
  ;@param color - color value
  ;@return s - s value
  (defun get-s (color)
    (nth 4 color))
  
  ;returns the v value of the color
  ;@param color - color value
  ;@return v - v value
  (defun get-v (color)
    (nth 5 color))
  
  ;returns the brightness of the color
  ;@param color - color value
  ;@return brightness - brightness value
  (defun get-brightness (color)
    (average (get-rgb color)))
  
  ;checks to see whether or not the given list is a proper color structure
  ;@param color - color value
  ;@return boolean - whether not the color value is plausible
  (defun color? (color)
    (if (equal (len color) 6)
        (mv-let (r g b h s v)
                color
                (and (rgb? (list r g b)) (hsv? (list h s v)) (equal (set-rgb (list r g b)) color)))
        nil))
  
  (export IColor))