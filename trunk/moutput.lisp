;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Kyle Morse 
;@date Apr 7, 2012
;@version 1.0

(require "specifications.lisp")

(module MOutput
  (include-book "binary-io-utilities" :dir :teachpacks)
  
  (import IColor)
  (import IImage)
  
  ;This is the number of junk bytes in a file.
  ;Junk bytes are what separates columns in byte format.
  (defun junk-width (width)
    (if (equal (mod width 4) 0)
        0
        (- 4 (mod (* width 3) 4))))
  
  ;Changes a number to a word
  (defun num->word (num word)
    (if (and (natp num) (< num 256))
        (append word (list num))
        (num->word (floor num 256) (append word (list (mod num 256))))))
  
  ;The size of the pixel array plus the header. The header is always 54 bytes.
  ;The pixel array is made up of each pixel with 3 bytes and junk zeroes between
  ;each column in compliance with the standard. There are also 2 zeroes appended 
  ;to the end
  (defun size-num (width height)
    (+ 54 (+ (+ (* 3 (* width height)) (* (junk-width width) width)) 2)))
  
  ;Adds zeroes to the word until it is the length of the given value
  (defun pad-right (word x)
    (if (> x(len word))
        (pad-right (append word (list 0)) x)
        word))
  
  ;Gets a 4 byte long word of the number of pixels           
  (defun get-size-word (width height)
    (pad-right (num->word (size-num width height) nil) 4))
  
  ;Gets a 4 byte long word of the width
  (defun get-width-word (width)
    (pad-right (num->word width nil) 4))
  
  ;Gets a 4 byte long word of the height
  (defun get-height-word (height)
    (pad-right (num->word height nil) 4))
  
  ;Gets a 4 byte long word of the size
  (defun get-size-image-word (width height)
    (pad-right (num->word (+ (* 3 width height) (+ (* (junk-width width) height) 2)) nil) 4))
  
  ;Formats the header at the end
  (defun get-header (width height)
    (append (list 66 77) ;Tells that it is a bitmap
            (get-size-word width height) 
            (list 0 0 0 0 54 0 0 0 40 0 0 0)
            (get-width-word width)
            (get-height-word height)
            (list 1 0 24 0 0 0 0 0)
            (get-size-image-word width height)
            (list 18 11 0 0 18 11 0 0 0 0 0 0 0 0 0 0)))
  
  ;Formats the pixel array. You feed to it the image, the header, and two zeroes
  (defun get-pixel-array (img bytes x y)
    (if (not (is-image-empty? img))
        (if (< y (img-height img))
            (if (< x (img-width img))
                (let ((color (get-color x y img)))
                  (get-pixel-array img
                                   (append bytes 
                                           (list (floor (* 255 (get-b color)) 1)
                                                 (floor (* 255 (get-g color)) 1)
                                                 (floor (* 255 (get-r color)) 1)))
                                   (1+ x)
                                   y))
                (get-pixel-array img (pad-right bytes (+ (junk-width (img-width img)) (len bytes))) 0 (1+ y)))
            (append bytes (list 0 0)))
        (append bytes (list 0 0))))
  
  (defun w-bmp (bytes path state)
    (mv-let (error-close state)
            (byte-list->binary-file path
                                    bytes
                                    state)
            (if error-close
                (mv error-close state)
                (mv nil state))))
  
  (defun write-bmp-file (img path)
    (w-bmp (get-pixel-array img (get-header (img-width img) (img-height img)) 0 0) path state))
  
  (export IOutput))
