;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module TParse-Queries
  (import IError)
  (import IParse-Queries)
  (import IStructures)
  
  (include-book "testing" :dir :teachpacks)
  (include-book "doublecheck" :dir :teachpacks)
  
  ; Parses a string into a predicate expression
  (defun str->expression (str)
    (tokens->expression (tokenize str)))
  
  ; Parses in a list of fields
  ; TODO: make this more elegant and include error checking
  ;@param tkns - list of tokens with commas, i.e. ("team" "," "date" "," "points")
  ;@return list of tokens without commas, i.e. '("team" "date" "points")
  (defun parse-fields (tkns)
    (cond ((endp tkns)
           nil)
          ((equal (first tkns) ",")
           (parse-fields (rest tkns)))
          (t
           (cons (first tkns)
                 (parse-fields (rest tkns))))))
  
  ;Converts a string to a query
  (defun str->query (str)
    (let ((tkns (tokenize str)))
      (if (error-p tkns)
          tkns
          (parse-query-tkns tkns))))
  
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