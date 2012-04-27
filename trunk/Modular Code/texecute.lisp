;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IExecute.lisp")
(require "MExecute.lisp")
(require "IStructures.lisp")
(require "MStructures.lisp")
(require "IString-Utilities.lisp")
(require "MString-Utilities.lisp")
(require "IParse-Data.lisp")
(require "MParse-Data.lisp")
(require "IParse-Queries.lisp")
(require "MParse-Queries.lisp")
(require "IList-Utilities.lisp")
(require "MList-Utilities.lisp")
(require "IError.lisp")
(require "MError.lisp")

(module TExecute
  
  (import IExecute)
  (import IParse-Data)
  (import IParse-Queries)
  (import IStructures)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (defconst *sample-row*
    '(("team" . "BOS")
      ("date" . 20120101)
      ("points" . 85) 
      ("assists" . 14)))
  
  (defconst *testrows* 
    (str->rows "team,date,points,assists,mascot
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie
CHI,20120102,76,14,bullwinkle"))
  
  (defconst *testqueryresult* 
    (query-result '("team" "date" "points" "assists" "mascot")
                  '(("BOS" 20120101 85 20 "celtie") ("BOS" 20120102 93 23 "celtie"))))
  
  (defconst *testquery* (str->query "SELECT team,date WHERE team = \"BOS\""))
  
  (check-expect (evaluate-filter *sample-row* (str->expression "team = \"BOS\""))
                t)
  (check-expect (evaluate-filter *sample-row* (str->expression "team = \"CHI\""))
                nil)
  (check-expect (evaluate-filter *sample-row* (str->expression "date = 20120101"))
                t)
  (check-expect (evaluate-filter *sample-row* (str->expression "points > 83"))
                t)
  (check-expect (evaluate-filter *sample-row* (str->expression "points > 83 && assists = 14"))
                t)
  (check-expect (evaluate-filter *sample-row* (str->expression "!(points > 83)"))
                nil)
  (check-expect (evaluate-filter *sample-row* (str->expression "!(points < 83)"))
                t)
  (check-expect (evaluate-filter (first *testrows*) (query-filter *testquery*))
                t)
  
  (check-expect (row->csv-str '("dog" "cat" "bird"))
                "dog,cat,bird")  
  
  (check-expect (rows->csv-strs '(("dog" "cat") ("frog" "rat")))
                "dog,cat
frog,rat")
  
  (check-expect (filter-fields-row '("field1" "field3")
                                   '(("field1" . "blah1") ("field2" . "blah2") ("field3" . "blah3")))
                '("blah1" "blah3"))
  (check-expect (filter-fields-row '("field3" "field1")
                                   '(("field1" . "blah1") ("field2" . "blah2") ("field3" . "blah3")))
                '("blah3" "blah1"))
  
  (check-expect (filter-fields-rows '("field1" "field3")
                                    '((("field1" . "blah1") ("field2" . "blah2") ("field3" . "blah3"))
                                      (("field1" . "foo1") ("field2" . "foo2") ("field3" . "foo3"))))
                '(("blah1" "blah3")
                  ("foo1" "foo3")))
  (check-expect (filter-fields-rows '("field3" "field1")
                                    '((("field1" . "blah1") ("field2" . "blah2") ("field3" . "blah3"))
                                      (("field1" . "foo1") ("field2" . "foo2") ("field3" . "foo3"))))
                '(("blah3" "blah1")
                  ("foo3" "foo1")))
  
  (check-expect (filter-rows *testrows*
                             (query-filter *testquery*))
                '((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20) ("mascot" . "celtie"))
                  (("team" . "BOS") ("date" . 20120102) ("points" . 93) ("assists" . 23) ("mascot" . "celtie"))))
  
  (check-expect (rows-query-strs->query-result-str
                 "team,date,points,assists,mascot
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie
CHI,20120102,76,14,bullwinkle"
                 "SELECT team,date,points,assists,mascot WHERE mascot = \"celtie\"")
                "team,date,points,assists,mascot
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie")
  
  )

(link RTExecute (MError
                 MStructures
                 MList-Utilities
                 MString-Utilities
                 MParse-Queries
                 MParse-Data
                 MExecute
                 TExecute))
(invoke RTExecute)