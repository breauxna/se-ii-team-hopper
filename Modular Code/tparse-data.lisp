;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IParse-Data.lisp")
(require "MParse-Data.lisp")
(require "IString-Utilities.lisp")
(require "MString-Utilities.lisp")
(require "IList-Utilities.lisp")
(require "MList-Utilities.lisp")
(require "IError.lisp")
(require "MError.lisp")

(module TParse-Data
  
  (import IParse-Data)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect (str->tkns "cats,dogs")
                '("cats" "dogs"))
  
  (check-expect  (strs->tknss '("cats,dogs" "mice,hogs"))
                 '(("cats" "dogs")
                   ("mice" "hogs")))
  
  (check-expect (tkns->row (str->tkns "team,date,points")
                           (str->tkns "BOS,20120101,85"))
                '(("team" . "BOS")
                  ("date" . 20120101)
                  ("points" . 85)))
  
  (check-expect (tknss->rows (str->tkns "team,date,points")
                             (list (str->tkns "BOS,20120101,85")
                                   (str->tkns "BOS,20120102,93")))
                '((("team" . "BOS")
                   ("date" . 20120101)
                   ("points" . 85))
                  (("team" . "BOS")
                   ("date" . 20120102)
                   ("points" . 93))))
  
  (check-expect (str->rows "team,date,points,assists,mascot
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie
CHI,20120102,76,14,bullwinkle")
                '((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20) ("mascot" . "celtie"))
                  (("team" . "BOS") ("date" . 20120102) ("points" . 93) ("assists" . 23) ("mascot" . "celtie"))
                  (("team" . "CHI") ("date" . 20120102) ("points" . 76) ("assists" . 14) ("mascot" . "bullwinkle"))))
  
  )

(link RTParse-Data (MError
                    MList-Utilities 
                    MString-Utilities 
                    MParse-Data 
                    TParse-Data))
(invoke RTParse-Data)