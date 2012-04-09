;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: March 4, 2012
;@version: 1.0

(require "moperation.lisp")

;Testing Module for operations data structure
(module TOperation
  (import IOperation)
  (import IColor)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  ;creates a random color
  (defrandom random-color ()
    (set-rgb (list (/ (random-between 0 255) 255) 
                   (/ (random-between 0 255) 255) 
                   (/ (random-between 0 255) 255))))
  
  ;creates a random direction
  (defrandom random-direction ()
    (let ((r (random-between 0 3))) 
      (cond ((= r 0) "up")
            ((= r 1) "down")
            ((= r 2) "left")
            ((= r 3) "right"))))
  
  ;figures out what string is for direction
  (defun enum-direction (str)
    (cond ((string-equal str "up") 'up)
          ((string-equal str "down") 'down)
          ((string-equal str "left") 'left)
          ((string-equal str "right") 'right)))
  
  ;creates a random axis
  (defrandom random-axis ()
    (let ((r (random-between 0 1))) 
      (cond ((= r 0) "x")
            ((= r 1) "y"))))
  
  ;figures out what string is for axis
  (defun enum-axis (str)
    (cond ((string-equal str "x") 'x)
          ((string-equal str "y") 'y)))
  
  ;creates a random color string
  (defrandom random-color-string ()
    (let ((r (random-between 0 2))) 
      (cond ((= r 0) "red")
            ((= r 1) "green")
            ((= r 2) "blue"))))
  
  ;figures out what string is for color string
  (defun enum-color-string (str)
    (cond ((string-equal str "red") 'red)
          ((string-equal str "green") 'green)
          ((string-equal str "blue") 'blue)))
  
  ;-------------------------------------------------------------------
  ;Boundary case
  (check-expect (operation nil nil) nil)
  (check-expect (operation "" nil) nil)
  
  ;Blur Tests
  (check-expect (operation "blur" nil) '(blur nil))
  (check-expect (operation "blur" "a") nil)
  (check-expect (operation "blur" "1") nil)
  (check-expect (operation "blur" '("a")) nil)
  (check-expect (operation "blur" '("1")) nil)
  (check-expect (operation "blurs" nil) nil)
  
  ;Border Tests
  (check-expect (operation "border" (list "1" "1" "1" "1"))
                (list 'border (list 1 (set-rgb (list (/ 1 255) 
                                                     (/ 1 255) 
                                                     (/ 1 255))))))
  (check-expect (operation "border" nil) nil)
  (check-expect (operation "border" "1") nil)
  (check-expect (operation "border" '("a")) nil)
  (check-expect (operation "border" '("1" "2")) nil)
  (check-expect (operation "borders" '("1")) nil)
  (defproperty border-type-check :repeat 100
    (x1 :value (random-natural)
     c  :value (random-color))
    (equal (operation "border" (list (rat->str x1 0) 
                                     (rat->str (* (get-r c) 255) 0)
                                     (rat->str (* (get-g c) 255) 0)
                                     (rat->str (* (get-b c) 255) 0))) 
           (list 'border (list x1 c))))
  
  ;Brightness Tests
  (check-expect (operation "brightness" '("1")) '(brightness (1)))
  (check-expect (operation "brightness" nil) nil)
  (check-expect (operation "brightness" "1") nil)
  (check-expect (operation "brightness" '("a")) nil)
  (check-expect (operation "brightness" '("1" "2")) nil)
  (check-expect (operation "brightnesss" '("1")) nil)
  (defproperty brightness-type-check :repeat 100
    (x1 :value (random-natural))
    (equal (operation "brightness" (list (rat->str x1 0))) 
           (list 'brightness (list x1))))
  
  ;Colormod Tests
  (check-expect (operation "colormod" (list "1" "1" "1" "1" "1" "1" "1"))
                (list 'colormod (list (set-rgb (list (/ 1 255) 
                                                     (/ 1 255) 
                                                     (/ 1 255)))
                                      1
                                      (set-rgb (list (/ 1 255) 
                                                     (/ 1 255) 
                                                     (/ 1 255))))))
  (check-expect (operation "colormod" nil) nil)
  (check-expect (operation "colormod" "1") nil)
  (check-expect (operation "colormod" '("a" "1" "1" "1" "1" "1" "1")) nil)
  (check-expect (operation "colormod" '("1" "a" "1" "1" "1" "1" "1")) nil)
  (check-expect (operation "colormod" '("1" "1" "a" "1" "1" "1" "1")) nil)
  (check-expect (operation "colormod" '("1" "1" "1" "a" "1" "1" "1")) nil)
  (check-expect (operation "colormod" '("1" "1" "1" "1" "a" "1" "1")) nil)
  (check-expect (operation "colormod" '("1" "1" "1" "1" "1" "a" "1")) nil)
  (check-expect (operation "colormod" '("1" "1" "1" "1" "1" "1" "a")) nil)
  (check-expect (operation "colormod" '("1" "2")) nil)
  (check-expect (operation "colormod" '("1")) nil)
  (defproperty colormod-type-check :repeat 100
    (c   :value (random-color)
     offset   :value (random-between 0 255)
     c2  :value (random-color))
    (equal (operation "colormod" (list (rat->str (* (get-r c) 255) 0)
                                       (rat->str (* (get-g c) 255) 0)
                                       (rat->str (* (get-b c) 255) 0)
                                       (rat->str offset 0)
                                       (rat->str (* (get-r c2) 255) 0)
                                       (rat->str (* (get-g c2) 255) 0)
                                       (rat->str (* (get-b c2) 255) 0))) 
           (list 'colormod (list c offset c2))))
  
  ;Contrast Tests
  (check-expect (operation "contrast" '("1")) '(contrast (1)))
  (check-expect (operation "contrast" nil) nil)
  (check-expect (operation "contrast" "1") nil)
  (check-expect (operation "contrast" '("a")) nil)
  (check-expect (operation "contrast" '("1" "2")) nil)
  (check-expect (operation "contrasts" '("1")) nil)
  (defproperty contrast-type-check :repeat 100
    (x1 :value (random-natural))
    (equal (operation "contrast" (list (rat->str x1 0))) 
           (list 'contrast (list x1))))
  
  ;Crop Tests
  (check-expect (operation "crop" '("1" "2" "3" "4")) '(crop (1 2 3 4)))
  (check-expect (operation "crop" nil) nil)
  (check-expect (operation "crop" "1") nil)
  (check-expect (operation "crop" '("a" "2" "3" "4")) nil)
  (check-expect (operation "crop" '("1" "a" "3" "4")) nil)
  (check-expect (operation "crop" '("1" "2" "a" "4")) nil)
  (check-expect (operation "crop" '("1" "2" "3" "a")) nil)
  (check-expect (operation "crop" '("1" "2" "3" "4" "5")) nil)
  (check-expect (operation "crops" '("1" "2" "3" "4")) nil)
  (defproperty crop-type-check :repeat 100
    (x1 :value (random-natural)
     x2 :value (random-natural)
     x3 :value (random-natural)
     x4 :value (random-natural))
    (equal (operation "crop" (list (rat->str x1 0) 
                                   (rat->str x2 0) 
                                   (rat->str x3 0) 
                                   (rat->str x4 0))) 
           (list 'crop (list x1 x2 x3 x4))))
  
  ;Greyscale Tests
  (check-expect (operation "greyscale" nil) '(greyscale nil))
  (check-expect (operation "greyscale" "a") nil)
  (check-expect (operation "greyscale" "1") nil)
  (check-expect (operation "greyscale" '("a")) nil)
  (check-expect (operation "greyscale" '("1")) nil)
  (check-expect (operation "greyscales" nil) nil)
  
  ;Histogram Tests
  (check-expect (operation "histogram" '("a")) '(histogram ("a")))
  (check-expect (operation "histogram" nil) nil)
  (check-expect (operation "histogram" "a") nil)
  (check-expect (operation "histogram" '("a" "b")) nil)
  (check-expect (operation "histograms" '("a")) nil)
  (defproperty histogram-type-check :repeat 100
    (x1 :value (coerce (random-list-of (random-char)) 'string))
    (equal (operation "histogram" (list x1)) 
           (list 'histogram (list x1))))
  
  ;Hue Tests
  (check-expect (operation "hue" '("1")) '(hue (1)))
  (check-expect (operation "hue" nil) nil)
  (check-expect (operation "hue" "1") nil)
  (check-expect (operation "hue" '("a")) nil)
  (check-expect (operation "hue" '("1" "2")) nil)
  (check-expect (operation "hues" '("1")) nil)
  (defproperty hue-type-check :repeat 100
    (x1 :value (random-between -360 360))
    (equal (operation "hue" (list (rat->str x1 0))) 
           (list 'hue (list x1))))
  
  ;Merge Tests
  (check-expect (operation "merge" '("a" "up")) (list 'merge (list "a" 'up)))
  (check-expect (operation "merge" '("a" "down")) (list 'merge (list "a" 'down)))
  (check-expect (operation "merge" '("a" "left")) (list 'merge (list "a" 'left)))
  (check-expect (operation "merge" '("a" "right")) (list 'merge (list "a" 'right)))
  (check-expect (operation "merge" nil) nil)
  (check-expect (operation "merge" "a") nil)
  (check-expect (operation "merge" '("a" "b")) nil)
  (check-expect (operation "merges" '("a")) nil)
  (defproperty merge-type-check :repeat 100
    (x1 :value (coerce (random-list-of (random-char)) 'string)
        str :value (random-direction))
    (equal (operation "merge" (list x1 str)) 
           (list 'merge (list x1 (enum-direction str)))))
  
  
  ;Mirror Tests
  (check-expect (operation "mirror" '("x")) (list 'mirror (list 'x)))
  (check-expect (operation "mirror" '("y")) (list 'mirror (list 'y)))
  (check-expect (operation "mirror" '("a")) nil)
  (check-expect (operation "mirror" nil) nil)
  (check-expect (operation "mirror" "a") nil)
  (check-expect (operation "mirror" '("a" "b")) nil)
  (check-expect (operation "mirrors" '("a")) nil)
  (defproperty mirror-type-check :repeat 100
    (str :value (random-axis))
    (equal (operation "mirror" (list str)) 
           (list 'mirror (list (enum-axis str)))))
  
  ;Negative Tests
  (check-expect (operation "negative" nil) '(negative nil))
  (check-expect (operation "negative" "a") nil)
  (check-expect (operation "negative" "1") nil)
  (check-expect (operation "negative" '("a")) nil)
  (check-expect (operation "negative" '("1")) nil)
  (check-expect (operation "negatives" nil) nil)
  
  ;Resize Tests
  (check-expect (operation "resize" '("1")) '(resize (1)))
  (check-expect (operation "resize" nil) nil)
  (check-expect (operation "resize" "1") nil)
  (check-expect (operation "resize" '("a")) nil)
  (check-expect (operation "resize" '("1" "2")) nil)
  (check-expect (operation "resizes" '("1")) nil)
  (defproperty resize-type-check :repeat 100
    (x1 :value (random-natural))
    (equal (operation "resize" (list (rat->str x1 0))) 
           (list 'resize (list x1))))
  
  ;Rotate Tests
  (check-expect (operation "rotate" '("1")) '(rotate (1)))
  (check-expect (operation "rotate" nil) nil)
  (check-expect (operation "rotate" "1") nil)
  (check-expect (operation "rotate" '("a")) nil)
  (check-expect (operation "rotate" '("1" "2")) nil)
  (check-expect (operation "rotates" '("1")) nil)
  (defproperty rotate-type-check :repeat 100
    (x1 :value (random-natural))
    (equal (operation "rotate" (list (rat->str x1 0))) 
           (list 'rotate (list x1))))
  
  ;Saturation Tests
  (check-expect (operation "saturation" '("1")) '(saturation (1)))
  (check-expect (operation "saturation" nil) nil)
  (check-expect (operation "saturation" "1") nil)
  (check-expect (operation "saturation" '("a")) nil)
  (check-expect (operation "saturation" '("1" "2")) nil)
  (check-expect (operation "saturations" '("1")) nil)
  (defproperty saturation-type-check :repeat 100
    (x1 :value (random-natural))
    (equal (operation "saturation" (list (rat->str x1 0))) 
           (list 'saturation (list x1))))
  
  ;Splitcolor Tests
  (check-expect (operation "splitcolor" '("red")) (list 'splitcolor (list 'red)))
  (check-expect (operation "splitcolor" '("green")) (list 'splitcolor (list 'green)))
  (check-expect (operation "splitcolor" '("blue")) (list 'splitcolor (list 'blue)))
  (check-expect (operation "splitcolor" '("a")) nil)
  (check-expect (operation "splitcolor" nil) nil)
  (check-expect (operation "splitcolor" "a") nil)
  (check-expect (operation "splitcolor" '("a" "b")) nil)
  (check-expect (operation "splitcolors" '("a")) nil)
  (defproperty splitcolor-type-check :repeat 100
    (str :value (random-color-string))
    (equal (operation "splitcolor" (list str)) 
           (list 'splitcolor (list (enum-color-string str))))))