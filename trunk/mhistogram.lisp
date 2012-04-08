;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

(require "specifications.lisp")

;MHistorgram generates a CSV string with r, g, b, h, s, v, brightness frequencies for a given image
(module MHistogram
  (include-book "io-utilities" :dir :teachpacks)
  (import IImage)
  (import IColor)
  
  ;initialize a formatted string for histogram output
  ;each sublist is a new line
  ;@return string-list - default formatted output text
  (defun initial-table ()
    (list (list "range" "," "red" "," "blue" "," "green" "," "hue" "," "saturation" "," "value" "," "brightness")
          (list "[0, 0.1)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.1, 0.2)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.2, 0.3)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.3, 0.4)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.4, 0.5)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.5, 0.6)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.6, 0.7)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.7, 0.8)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.8, 0.9)" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")
          (list "[0.9, 1.0]" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0" "," "0")))
  
  ;replace-nth replaces the nth element of a list with a given value
  ;@param n - location in list for replacement
  ;@param x - element to be replaced with in the list
  ;@param xs - list
  ;@return list - new list of xs with the nth element replaced with x
  (defun replace-nth (n x xs)
    (if (and (natp n) (> (len xs) n))
        (if (equal n 0)
            (cons x (cdr xs))
            (cons (car xs) (replace-nth (1- n) x (cdr xs))))
        xs))
  
  ;count-stats iterates through a list of stats and updates the frequency CSV string
  ;@param n - index
  ;@param stats - list of statistics, i.e., '(brightness r g b h s v)
  ;@param hist - CSV string for histogram output
  ;@return string - CSV string for histogram output
  (defun count-stats (n stats hist)
    (if (< n (len stats))
        (let* ((stat (nth n stats))
               (interval (if (> (1- (floor stat 0.1)) 8)
                             8
                             (1- (floor stat 0.1))))
               (row (nth (1+ interval) hist))
               (frequency (str->int (nth (* 2 (1+ n)) row))))
          (count-stats (1+ n) stats (replace-nth (1+ interval) (replace-nth (* 2 (1+ n)) (int->str (1+ frequency)) row) hist)))
        hist))
  
  ;count iterates through all pixels in an image and updates the frequency CSV string
  ;@param x - current x location
  ;@param y - current y location
  ;@param img - image
  ;@param hist - CSV string for histogram output
  ;@return string - CSV string for histogram output
  (defun count (x y img hist)
    (if (< y (img-height img))
        (if (< x (img-width img))
            (let* ((color (get-color x y img)) ;'(r g b h s v)
                   (stats (cons (get-brightness color) color))) ;'(brightness r g b h s v)
              (count (1+ x) y img (count-stats 0 stats hist)))
            (count 0 (1+ y) img hist))
        hist))
  
  ;string-list->string converts a list of strings to a string
  ;@param string-list - list of strings
  ;@return string
  (defun string-list->string (string-list)
    (if (consp string-list)
        (append (car string-list) (string-list->string (cdr string-list)))
        nil))
  
  ;format-output formats the frequency data for output
  ;@param output - list of lists of strings
  ;@return list - list of strings collapsed from output
  (defun format-output (output)
    (if (consp output)
        (cons (string-list->string (car output)) (format-output (cdr output)))
        nil))
  
  ;generates a frequenct table for brightness, r, g, b, h, s, and v
  ;values of a given image
  ;@param img - image
  ;retun string - formatted CSV string for histogram output
  (defun histogram (img)
    (format-output (count 0 0 img (initial-table))))
  
  (export IHistogram))