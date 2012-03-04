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
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  ;Boundary case
  (check-expect (operation nil nil) nil)
  (check-expect (operation "" nil) nil)
  
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
  ;Blur Tests
  (check-expect (operation "blur" nil) '(blur nil))
  (check-expect (operation "blur" "a") nil)
  (check-expect (operation "blur" "1") nil)
  (check-expect (operation "blur" '("a")) nil)
  (check-expect (operation "blur" '("1")) nil)
  (check-expect (operation "blurs" nil) nil)
  ;Unsharpmask Tests
  (check-expect (operation "unsharpmask" nil) '(unsharpmask nil))
  (check-expect (operation "unsharpmask" "a") nil)
  (check-expect (operation "unsharpmask" "1") nil)
  (check-expect (operation "unsharpmask" '("a")) nil)
  (check-expect (operation "unsharpmask" '("1")) nil)
  (check-expect (operation "unsharpmasks" nil) nil)
  ;Merge Tests
  (check-expect (operation "merge" '("a")) '(merge ("a")))
  (check-expect (operation "merge" nil) nil)
  (check-expect (operation "merge" "a") nil)
  (check-expect (operation "merge" '("a" "b")) nil)
  (check-expect (operation "merges" '("a")) nil)
  ;Border Tests
  (check-expect (operation "border" '("1")) '(border (1)))
  (check-expect (operation "border" nil) nil)
  (check-expect (operation "border" "1") nil)
  (check-expect (operation "border" '("a")) nil)
  (check-expect (operation "border" '("1" "2")) nil)
  (check-expect (operation "borders" '("1")) nil)
  ;Negative Tests
  (check-expect (operation "negative" nil) '(negative nil))
  (check-expect (operation "negative" "a") nil)
  (check-expect (operation "negative" "1") nil)
  (check-expect (operation "negative" '("a")) nil)
  (check-expect (operation "negative" '("1")) nil)
  (check-expect (operation "negatives" nil) nil)
  ;Histogram Tests
  (check-expect (operation "histogram" nil) '(histogram nil))
  (check-expect (operation "histogram" "a") nil)
  (check-expect (operation "histogram" "1") nil)
  (check-expect (operation "histogram" '("a")) nil)
  (check-expect (operation "histogram" '("1")) nil)
  (check-expect (operation "histograms" nil) nil)
  ;Rotate Tests
  (check-expect (operation "rotate" '("1")) '(rotate (1)))
  (check-expect (operation "rotate" nil) nil)
  (check-expect (operation "rotate" "1") nil)
  (check-expect (operation "rotate" '("a")) nil)
  (check-expect (operation "rotate" '("1" "2")) nil)
  (check-expect (operation "rotates" '("1")) nil)
  ;Resize Tests
  (check-expect (operation "resize" '("1")) '(resize (1)))
  (check-expect (operation "resize" nil) nil)
  (check-expect (operation "resize" "1") nil)
  (check-expect (operation "resize" '("a")) nil)
  (check-expect (operation "resize" '("1" "2")) nil)
  (check-expect (operation "resizes" '("1")) nil)
  ;Greyscale Tests
  (check-expect (operation "greyscale" nil) '(greyscale nil))
  (check-expect (operation "greyscale" "a") nil)
  (check-expect (operation "greyscale" "1") nil)
  (check-expect (operation "greyscale" '("a")) nil)
  (check-expect (operation "greyscale" '("1")) nil)
  (check-expect (operation "greyscales" nil) nil)
  ;Saturation Tests
  (check-expect (operation "saturation" '("1")) '(saturation (1)))
  (check-expect (operation "saturation" nil) nil)
  (check-expect (operation "saturation" "1") nil)
  (check-expect (operation "saturation" '("a")) nil)
  (check-expect (operation "saturation" '("1" "2")) nil)
  (check-expect (operation "saturations" '("1")) nil)
  ;Contrast Tests
  (check-expect (operation "contrast" nil) '(contrast nil))
  (check-expect (operation "contrast" "a") nil)
  (check-expect (operation "contrast" "1") nil)
  (check-expect (operation "contrast" '("a")) nil)
  (check-expect (operation "contrast" '("1")) nil)
  (check-expect (operation "contrasts" nil) nil)
  ;Splitcolor Tests
  (check-expect (operation "splitcolor" nil) '(splitcolor nil))
  (check-expect (operation "splitcolor" "a") nil)
  (check-expect (operation "splitcolor" "1") nil)
  (check-expect (operation "splitcolor" '("a")) nil)
  (check-expect (operation "splitcolor" '("1")) nil)
  (check-expect (operation "splitcolors" nil) nil)
  ;Mirror Tests
  (check-expect (operation "mirror" nil) '(mirror nil))
  (check-expect (operation "mirror" "a") nil)
  (check-expect (operation "mirror" "1") nil)
  (check-expect (operation "mirror" '("a")) nil)
  (check-expect (operation "mirror" '("1")) nil)
  (check-expect (operation "mirrors" nil) nil)
  ;Hue Tests
  (check-expect (operation "hue" '("1")) '(hue (1)))
  (check-expect (operation "hue" nil) nil)
  (check-expect (operation "hue" "1") nil)
  (check-expect (operation "hue" '("a")) nil)
  (check-expect (operation "hue" '("1" "2")) nil)
  (check-expect (operation "hues" '("1")) nil)
  ;Mask Tests
  (check-expect (operation "mask" '("a")) '(mask ("a")))
  (check-expect (operation "mask" nil) nil)
  (check-expect (operation "mask" "a") nil)
  (check-expect (operation "mask" '("a" "b")) nil)
  (check-expect (operation "masks" '("a")) nil)
  ;Despeckle Tests
  (check-expect (operation "despeckle" nil) '(despeckle nil))
  (check-expect (operation "despeckle" "a") nil)
  (check-expect (operation "despeckle" "1") nil)
  (check-expect (operation "despeckle" '("a")) nil)
  (check-expect (operation "despeckle" '("1")) nil)
  (check-expect (operation "despeckles" nil) nil))