;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module TExecute
  (import IError)
  (import IExecute)
  (import IParse-Data)
  (import IParse-Queries)
  (import IStructures)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  ;Converts a string to a query
  (defun str->query (str)
    (let ((tkns (tokenize str)))
      (if (error-p tkns)
          tkns
          (parse-query-tkns tkns))))
  
  ; Parses a string into a predicate expression
  (defun str->expression (str)
    (tokens->expression (tokenize str)))
  
  (defun rows-query-strs->query-result-str (data-str query-str)
    (query-result->str (rows-query->query-result (str->rows data-str)
                                                 (str->query query-str))))
  
  (defconst *sample-row*
    '(("team" . "BOS")
      ("date" . 20120101)
      ("points" . 85) 
      ("assists" . 14)))
  
  (defconst *testrows* 
    (str->rows "team,date,points,assists,mascot
string,number,number,number,string
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie
CHI,20120102,76,14,bullwinkle"))
  
  (defconst *testqueryresult* 
    (query-result '("team" "date" "poi
nts" "assists" "mascot")
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
string,number,number,number,string
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie
CHI,20120102,76,14,bullwinkle"
                 "SELECT team,date,points,assists,mascot WHERE mascot = \"celtie\"")
                "team,date,points,assists,mascot
BOS,20120101,85,20,celtie
BOS,20120102,93,23,celtie")
  )