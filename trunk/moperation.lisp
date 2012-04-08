;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
;@author: Kyle Morse
;@date: Feb 20, 2012
;@version: 1.0

(require "specifications.lisp")

;Creates an operation data structure that checks
;if the particular operation was given the right arguments
(module MOperation
  (include-book "io-utilities" :dir :teachpacks)
  
  ;Checks if string is a number
  ;(str == number) ? t:nil
  (defun number? (str)
    (if (equal (rat->str (str->rat str) 0) str)
        t
        nil))
  
  ;Checks if crop has right arguments
  ;Format - (crop x1 y1 x2 y2)
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
  
  ;Checks if blur has no arguments
  ;Format - (blur)
  (defun blur (args)
    (if (equal args nil)
        (list 'blur args)
        nil))
  
  ;Checks if merge has right arguments
  ;Format - (merge path)
  (defun merge (args)
    (if (and (consp args)
             (stringp (car args))
             (equal (cdr args) nil))
        (list 'merge args)
        nil))
  
  ;Checks if border has right arguments
  ;Format - (border width)
  (defun border (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'border (list (str->rat (car args))))
        nil))
  
  ;Checks if negative has no arguments
  ;Format - (negative)
  (defun negative (args)
    (if (equal args nil)
        (list 'negative args)
        nil))
  
  ;Checks if histogram has no arguments
  ;Format - (histogram)
  (defun histogram (args)
    (if (equal args nil)
        (list 'histogram args)
        nil))
  
  ;Checks if rotate has right arguments
  ;Format - (rotate degrees)
  (defun rotate (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'rotate (list (str->rat (car args))))
        nil))
  
  ;Checks if resize has right arguments
  ;Format - (resize scale)
  (defun resize (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'resize (list (str->rat (car args))))
        nil))
  
  ;Checks if greyscale has no arguments
  ;Format - (greyscale)
  (defun greyscale (args)
    (if (equal args nil)
        (list 'greyscale args)
        nil))
  ;Checks if saturation has right arguments
  ;Format - (saturation amount)
  (defun saturation (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'saturation (list (str->rat (car args))))
        nil))
  
  ;Checks if contrast has right arguments
  ;Format - (contrast)
  (defun contrast (args)
    (if (equal args nil)
        (list 'contrast args)
        nil))
  
  ;Checks if splitcolor has right arguments
  ;Format - (splitcolor)
  (defun splitcolor (args)
    (if (equal args nil)
        (list 'splitcolor args)
        nil))
  
  ;Checks if mirror has right arguments
  ;Format - (mirror)
  (defun mirror (args)
    (if (equal args nil)
        (list 'mirror args)
        nil))
  
  ;Checks if hue has right arguments
  ;Format - (hue amount)
  (defun hue (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'hue (list (str->rat (car args))))
        nil))
  
  ;Checks if brightness has right arguments
  ;Format - (despeckle amount)
  (defun brightness (args)
    (if (and (consp args)
             (number? (car args))
             (equal (cdr args) nil))
        (list 'brightness (list (str->rat (car args))))
        nil))
  
  ;Wrapper function that creates an operation data structure
  ;Returns nil if the arguments are wrong
  (defun operation (op args)
    (if (stringp op)
        (cond ((string-equal op "crop") (crop args))
              ((string-equal op "blur") (blur args))
              ((string-equal op "merge") (merge args))
              ((string-equal op "border") (border args))
              ((string-equal op "negative") (negative args))
              ((string-equal op "histogram") (histogram args))
              ((string-equal op "rotate") (rotate args))
              ((string-equal op "resize") (resize args))
              ((string-equal op "greyscale") (greyscale args))
              ((string-equal op "saturation") (saturation args))
              ((string-equal op "contrast") (contrast args))
              ((string-equal op "splitcolor") (splitcolor args))
              ((string-equal op "mirror") (mirror args))
              ((string-equal op "hue") (hue args))
              ((string-equal op "brightness") (brightness args))
              (t nil))
        nil)) 
  
  (export IOperation))