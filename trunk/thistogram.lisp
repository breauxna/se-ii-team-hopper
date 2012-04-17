;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 15, 2012
;@version 1.0

(require "specifications.lisp")

(module THistogram
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  (include-book "list-utilities" :dir :teachpacks)
  
  (import IColor)
  (import IImage)
  (import IHistogram)
  
  (defrandom random-color ()
    (set-rgb (list (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255)
                   (/ (mod (random-integer) 256) 255))))
  
  (defrandom generate-random-image (x y img)
    (if (and (natp x) (natp y) (< y (img-height img)))
        (if (< x (img-width img))
            (generate-random-image (1+ x)
                                   y
                                   (add-pixel x y (random-color) img))
            (generate-random-image 0 (1+ y) img))
        img))
  
  (defrandom random-image (width height)
    (generate-random-image 0 0 (empty-image width height)))
  
  (defun nth-number (string n)
    (str->int
     (chrs->str
      (nth n
           (remove nil
                   (packets-set '(#\, #\newline #\return #\tab)
                                (str->chrs string)))))))
  
  (defun column-sum (string-list n)
    (if (consp string-list)
        {+ (nth-number (car string-list) n)
           (column-sum (cdr string-list) n)}
        0))
  
  ;histogram tests
  (check-expect (histogram nil) '("No image data."))
  (check-expect (histogram (empty-image 10 10)) '("No image data."))
  
  (defproperty correct-sum :repeat 100
    (width  :value (random-between 1 10)
            height :value (random-between 1 10)
            img    :value (random-image width height))
    (let* ((size (* width height))
           (string-list (cdr (histogram img))))
      (and (equal size (column-sum string-list 1))
           (equal size (column-sum string-list 2))
           (equal size (column-sum string-list 3))
           (equal size (column-sum string-list 4))
           (equal size (column-sum string-list 5))
           (equal size (column-sum string-list 6)))))
  )