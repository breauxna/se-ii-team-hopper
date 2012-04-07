;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Youming Lin
;@date Apr 7, 2012
;@version 1.0

(require "specifications.lisp")

;MImage is the underlying data structure for bitmap image manipulation
(module MImage
  (include-book "avl-rational-keys" :dir :teachpacks)
  
  ;img-width returns the width of the image
  ;@param img - image structure
  ;@return width - width of image
  (defun img-width (img)
    (car img))
  
  ;img-height returns the height of the image
  ;@param img - image structure
  ;@return width - height of image
  (defun img-height (img)
    (cadr img))
  
  ;img-tree returns the pixel tree of the image
  ;@param img - image structure
  ;@return width - pixel tree of image
  (defun img-tree (img)
    (caddr img))
  
  ;empty-image creates an empty image with the specified width and height
  ;@param width - width of new image
  ;@param height - height of the new image
  ;@return img - new empty image of specified width and height
  (defun empty-image (width height)
    (list width height (empty-tree)))
  
  ;get-color retrieves the color at location (x, y)
  ;@param x - x coordinate
  ;@param y - y coordinate
  ;@param img - image
  ;@return color - color at location (x, y) in given image
  (defun get-color (x y img)
    (cdr (avl-retrieve (cdr (avl-retrieve (img-tree img) x)) y)))
  
  ;add-pixel sets the pixel at location (x, y) to the given color
  ;@param x - x coordinate
  ;@param y - y coordinate
  ;@param img - image
  ;@return img - new image with updated color at location (x, y)
  (defun add-pixel (x y color img)
    (list (img-width img)
          (img-height img)
          (avl-insert (img-tree img)
                      x
                      (avl-insert (cdr (avl-retrieve (img-tree img) x))
                                  y
                                  color))))
  
  ;change-size changes the width and height of the given image
  ;@param width - new width
  ;@param height - new height
  ;@param img - image
  ;@return img - new image set to given width and height
  (defun change-size (width height img)
    (list width height (img-tree img)))
  
  ;is-image-empty? checks to see if an image has an empty pixel tree
  ;@param img - image for checking emptiness
  ;@return boolean - whether or not the pixel tree is empty
  (defun is-image-empty? (img)
    (empty-tree? (img-tree img)))
  
  (export IImage))