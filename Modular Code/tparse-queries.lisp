;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "IParse-Queries.lisp")
(require "MParse-Queries.lisp")
(require "IString-Utilities.lisp")
(require "MString-Utilities.lisp")
(require "IList-Utilities.lisp")
(require "MList-Utilities.lisp")
(require "IError.lisp")
(require "MError.lisp")
(require "IStructures.lisp")
(require "MStructures.lisp")

(module TParse-Queries
  
  (import IParse-Queries)
  (import IStructures)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  (check-expect (tokenize "dogs are great")
                '("dogs" "are" "great"))
  (check-expect (tokenize "dogs are (so) great")
                '("dogs" "are" "(" "so" ")" "great"))
  (check-expect (tokenize "dogs >= great")
                '("dogs" ">=" "great"))
  (check-expect (tokenize "dogs are $#@%ing great")
                '(:error . "Unexpected character: $"))
  (check-expect (tokenize "dogs are \"not\" so great")
                '("dogs" "are" "\"not\"" "so" "great"))
  (check-expect (tokenize "dogs are great!")
                '("dogs" "are" "great" "!"))
  
  (check-expect (str->operator "!")
                'not)
  
  (check-expect (tokens->expression (tokenize "assists > 3"))
                '(> (:field "assists") 
                    (:literal 3)))
  (check-expect (tokens->expression (tokenize "(team = \"BOS\") && (date = 20120101)"))
                '(and (= (:field "team") 
                         (:literal "BOS")) 
                      (= (:field "date") 
                         (:literal 20120101))))
  (check-expect (tokens->expression (tokenize "team = \"BOS\" && date = 20120101"))
                '(and (= (:field "team") 
                         (:literal "BOS")) 
                      (= (:field "date") 
                         (:literal 20120101))))
  
  (check-expect (str->expression "!(team =\"BOS\")")
                '(not (= (:field "team") 
                         (:literal "BOS"))))
  
  (check-expect (parse-fields '("field1" "," "field2" "," "field3"))
                '("field1" "field2" "field3"))
  
  (check-expect (str->query "SELECT field1,field2 WHERE field1 > 3")
                (query '("field1" "field2") 
                       '(> (:field "field1") 
                           (:literal 3))))
  
  (check-expect (str->query "SELECT field1,field2 
WHERE field1 > 3")
                (query '("field1" "field2") 
                       '(> (:field "field1") 
                           (:literal 3))))
  
  (check-expect (str->queries "SELECT field1,field2 
WHERE field1 > 3 SELECT field1,field2 
WHERE field1 < 3")
                '((query ("field1" "field2") 
                         (> (:field "field1") 
                            (:literal 3)))
                  (query ("field1" "field2") 
                         (< (:field "field1") 
                            (:literal 3)))))
  
  
  )

(link RTParse-Queries (MStructures
                       MError
                       MList-Utilities
                       MString-Utilities
                       MParse-Queries 
                       TParse-Queries))
(invoke RTParse-Queries)