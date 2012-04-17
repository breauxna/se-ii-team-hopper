;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: Apr 16, 2012
;@version: 1.0

(require "specifications.lisp")

;Creates an operation data structure thacolort checks
;if the particular operation was given the right arguments
(module MOperation
  (include-book "io-utilities" :dir :teachpacks)
  (import IColor)
  
  ;Checks if string is a number
  ;(str == number) ? t:nil
  (defun number? (str)
    (if (equal (rat->str (str->rat str) 0) str)
        t
        nil))
  
  ;Checks if string is a direction
  ;(str == up or down or right or left) ? t:nil
  (defun is-direction? (str)
    (or (string-equal str "up")
        (string-equal str "down")
        (string-equal str "left")
        (string-equal str "right")))
  
  ;Changes a direction string to an enum
  (defun direction (str)
    (cond ((string-equal str "up") 'up)
          ((string-equal str "down") 'down)
          ((string-equal str "left") 'left)
          ((string-equal str "right") 'right)))
  
  ;Checks if string is a color
  ;(str == red or green or blue) ? t:nil
  (defun is-color? (str)
    (or (string-equal str "red")
        (string-equal str "green")
        (string-equal str "blue")))
  
  ;Changes a color string to an enum
  (defun color (str)
    (cond ((string-equal str "red") 'red)
          ((string-equal str "green") 'green)
          ((string-equal str "blue") 'blue)))
  
  ;Checks if string is an axis
  ;(str == x or y) ? t:nil
  (defun is-axis? (str)
    (or (string-equal str "x")
        (string-equal str "y")))
  
  ;Changes a axis string to an enum
  (defun axis (str)
    (cond ((string-equal str "x") 'x)
          ((string-equal str "y") 'y)))
  
  ;Checks if blur has no arguments
  ;Format - (blur)
  (defun blur (args)
    (if (equal args nil)
        (list 'blur args)
        nil))
  
  ;Checks if brightness has right arguments
  ;Format - (brightness percent)
  ;Percent: natural that will be divided by 100
  (defun brightness (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'brightness (list (str->rat (car args))))
        nil))
  
  ;Checks if border has right arguments
  ;Format - (border width r g b)
  ;width: natural
  ;r: [0, 255]
  ;g: [0, 255]
  ;b: [0, 255]
  (defun border (args)
    (if (and (consp args)
             (number? (car args)) 
             (number? (cadr args)) 
             (number? (caddr args)) 
             (number? (cadddr args))
             (equal (cddddr args) nil))
        (list 'border 
              (list (str->rat (car args))
                            (set-rgb (list (/ (str->rat (cadr args)) 
                                              255)
                                           (/ (str->rat (caddr args)) 
                                              255)
                                           (/ (str->rat (cadddr args)) 
                                              255)))))
        nil))
  
  ;Checks if colormod has right arguments
  ;Format - (colormod r g b offset r g b)
  ;r: [0, 255]
  ;g: [0, 255]
  ;b: [0, 255]
  ;offset: [0, 255]
  (defun colormod (args)
    (if (and (consp args)
             (number? (car args)) 
             (number? (cadr args)) 
             (number? (caddr args))
             (number? (nth 3 args))
             (number? (nth 4 args))
             (number? (nth 5 args))
             (number? (nth 6 args))
             (equal (nthcdr 7 args) nil))
        (list 'colormod (list (set-rgb (list (/ (str->rat (car args)) 
                                                255)
                                             (/ (str->rat (cadr args)) 
                                                255)
                                             (/ (str->rat (caddr args)) 
                                                255)))
                              (str->rat (nth 3 args))
                              (set-rgb (list (/ (str->rat (nth 4 args)) 
                                                255)
                                             (/ (str->rat (nth 5 args)) 
                                                255)
                                             (/ (str->rat (nth 6 args)) 
                                                255)))))
        nil))
  
  ;Checks if contrast has right arguments
  ;Format - (contrast percent)
  ;percent: natural that will be divided by 100
  (defun contrast (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'contrast (list (str->rat (car args))))
        nil))
  
  ;Checks if crop has right arguments
  ;Format - (crop x1 y1 x2 y2)
  ;x1: natural
  ;y1: natural
  ;x2: natural
  ;y2: natural
  (defun crop (args)
    (if (and (consp args)
             (number? (car args)) 
             (number? (cadr args)) 
             (number? (caddr args)) 
             (number? (cadddr args))
             (equal (cddddr args) nil))
        (list 'crop (list (str->rat (car args))
                          (str->rat (cadr args))
                          (str->rat (caddr args))
                          (str->rat (cadddr args))))
        nil))
  
  ;Checks if greyscale has no arguments
  ;Format - (greyscale)
  (defun greyscale (args)
    (if (equal args nil)
        (list 'greyscale args)
        nil))
  
  ;Checks if histogram has right arguments
  ;Format - (histogram path)
  ;Path: string
  (defun histogram (args)
    (if (and (consp args)
             (stringp (car args))
             (equal (cdr args) nil))
        (list 'histogram args)
        nil))
  
  ;Checks if hue has right arguments
  ;Format - (hue degree)
  ;degree:  [-360, 360]
  (defun hue (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'hue (list (str->rat (car args))))
        nil))
  
  ;Checks if merge has right arguments
  ;Format - (merge path direction)
  ;direction is up down right left
  (defun merge (args)
    (if (and (consp args)
             (stringp (car args))
             (is-direction? (cadr args))
             (equal (cddr args) nil))
        (list 'merge (list (car args)
                           (direction (cadr args))))
        nil))

  ;Checks if mask has the right arguments
  ;Format - (mask path)
  (defun mask (args)
    (if (and (consp args)
             (stringp (car args))
             (equal (cdr args) nil))
        (list 'mask (list (car args)))
        nil))
  
  ;Checks if mirror has right arguments
  ;Format - (mirror axis)
  ;Axis is what it mirrors along
  ;Axis can be x or y
  (defun mirror (args)
    (if (and (consp args)
             (is-axis? (car args))
             (equal (cdr args) nil))
        (list 'mirror (list (axis (car args))))
        nil))
  
  ;Checks if negative has no arguments
  ;Format - (negative)
  (defun negative (args)
    (if (equal args nil)
        (list 'negative args)
        nil))
  
  ;Checks if resize has right arguments
  ;Format - (resize scale)
  ;scale: natural that will be divided by 100
  (defun resize (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'resize (list (str->rat (car args))))
        nil))
  
  ;Checks if rotate has right arguments
  ;Format - (rotate degrees)
  ;degrees: natural
  (defun rotate (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'rotate (list (str->rat (car args))))
        nil))
  
  
  ;Checks if saturation has right arguments
  ;Format - (saturation percent)
  ;percent: natural that will be divided by 100
  (defun saturation (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'saturation (list (str->rat (car args))))
        nil))
  
  ;Checks if splitcolor has right arguments
  ;Format - (splitcolor color)
  ;Color is what color you want picture to be made of.
  ;Color can be red, green, or blue
  (defun splitcolor (args)
    (if (and (consp args)
             (is-color? (car args))
             (equal (cdr args) nil))
        (list 'splitcolor (list (color (car args))))
        nil))
  
  ;Wrapper function that creates an operation data structure
  ;Returns nil if the arguments are wrong
  (defun operation (op args)
    (if (stringp op)
        (cond ((string-equal op "blur") (blur args))
              ((string-equal op "border") (border args))
              ((string-equal op "brightness") (brightness args))
              ((string-equal op "colormod") (colormod args))
              ((string-equal op "contrast") (contrast args))  
              ((string-equal op "crop") (crop args))
              ((string-equal op "greyscale") (greyscale args))
              ((string-equal op "histogram") (histogram args))
              ((string-equal op "hue") (hue args))
              ((string-equal op "mask") (mask args))
              ((string-equal op "merge") (merge args))
              ((string-equal op "mirror") (mirror args))
              ((string-equal op "negative") (negative args))
              ((string-equal op "resize") (resize args))
              ((string-equal op "rotate") (rotate args))
              ((string-equal op "saturation") (saturation args))
              ((string-equal op "splitcolor") (splitcolor args))
              (t nil))
        nil)) 
  
  (export IOperation))