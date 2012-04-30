;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MExecute
  (import IStructures)
  (import IString-Utilities)
  (import IList-Utilities)
  (import IParse-Data)
  (import IParse-Queries)
  
  ; Evaluates a row based off of a predicate
  ;@param row  - list of '("field" . value) pairs, i.e. '(("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20))
  ;@param predicate - query filter, i.e. '(= (:field "date") (:literal 20120101))
  ;@return boolean - whether or not the row values match the predicate
  (defun evaluate-filter (row predicate)
    (case (first predicate)
      ; compound level
      ('and (and (evaluate-filter row (second predicate))
                 (evaluate-filter row (third predicate))))
      ('or (or (evaluate-filter row (second predicate))
               (evaluate-filter row (third predicate))))
      ('not (not (evaluate-filter row (second predicate))))
      
      ; field level
      ('< (< (evaluate-filter row (second predicate))
             (evaluate-filter row (third predicate))))
      ('<= (<= (evaluate-filter row (second predicate))
               (evaluate-filter row (third predicate))))
      ('> (> (evaluate-filter row (second predicate))
             (evaluate-filter row (third predicate))))
      ('>= (>= (evaluate-filter row (second predicate))
               (evaluate-filter row (third predicate))))
      ('= (equal (evaluate-filter row (second predicate))
                 (evaluate-filter row (third predicate))))
      
      ; atomic level
      (:field (cdr (assoc-equal (second predicate) row))) ; a value in the row (data)
      (:literal (second predicate))))                     ; a user-entered value
  
  
  ; Filters a list of rows into only those rows which match the filter
  ;@param rows - list of list of '("field" . value) pairs, i.e.
  ;'((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20))
  ;  (("team" . "BOS") ("date" . 20120102) ("points" . 93) ("assists" . 23))
  ;  (("team" . "CHI") ("date" . 20120102) ("points" . 76) ("assists" . 14)))
  ;@param filter - query filter object, i.e. '(= (:field "date") (:literal 20120101))
  ;@return rows that match the filter , i.e. '((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20)))
  (defun filter-rows (rows filter)
    (cond ((endp rows)
           nil)
          ((evaluate-filter (first rows) filter)
           (cons (first rows)
                 (filter-rows (rest rows) filter)))
          (t
           (filter-rows (rest rows) filter))))
  
  ; TODO check for speed
  ; Extracts the data corresponding to a given field
  (defun extract-field-data (field row)
    (if (endp row)
        nil ; TODO make error?
        (if (equal (first (first row)) field)
            (cdr (first row))
            (extract-field-data field (rest row)))))
  
  ; Reduces a row into values corresponding to a list of fields
  ; '((field1 . value1) (field2 . value2) (field3 . value3))
  ; -->
  ; '(value1 value3)
  ;@param fields  - list of field tokens, i.e. '("team" "date" "points")
  ;@param row - one filtered row, i.e. '(("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20))
  ;@return the relevant values in a row, i.e. '("BOS" 20120101 85)
  (defun filter-fields-row (fields row)
    (if (endp fields)
        nil
        (cons (extract-field-data (first fields) row)
              (filter-fields-row (rest fields) row))))
  
  ; Filters multiple rows by a list of fields to display
  ;@param fields  - list of field tokens, i.e. '("team" "date" "points")
  ;@param rows - list of filtered rows, i.e. '((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20)))
  ;@return list of relevant values in the rows, i.e. (("BOS" 20120101 85))
  (defun filter-fields-rows (fields rows)
    (if (endp rows)
        nil
        (cons (filter-fields-row fields (first rows))
              (filter-fields-rows fields (rest rows)))))
  
  ; Evaluates a query on a list of rows
  ;@param rows - list of list of '("field" . value) pairs, i.e.
  ;'((("team" . "BOS") ("date" . 20120101) ("points" . 85) ("assists" . 20))
  ;  (("team" . "BOS") ("date" . 20120102) ("points" . 93) ("assists" . 23))
  ;  (("team" . "CHI") ("date" . 20120102) ("points" . 76) ("assists" . 14)))
  ;@param query - query object, i.e. '(query ("team" "date" "points") (= (:field "date") (:literal 20120101)))
  ;@return 
  (defun rows-query->query-result (rows query)
    (query-result (query-fields query)
                  (filter-fields-rows (query-fields query) 
                                      (filter-rows rows (query-filter query)))))
  
  ; Converts a row to a string of comma-separated values
  (defun row->csv-str (row)
    (if (endp row)
        ""
        (concatenate 'string
                     (make-string (first row))
                     (if (second row)
                         ","
                         "") ;don't put comma on the last one
                     (row->csv-str (rest row)))))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;updated to properly format output for opening in notepad
  (defun rows->csv-strs (rows)
    (if (endp rows)
        ""
        (concatenate 'string
                     (row->csv-str (first rows))
                     (if (second rows)
                         "\r\n"
                         "")
                     (rows->csv-strs (rest rows)))))
 
  ;Youming Lin
  ;modified version
  ;updated to properly format output for opening in notepad
  (defun query-result->str (query-result)
    (concatenate 'string
                 (row->csv-str (query-result-fields query-result))
                 "\r\n"
                 (rows->csv-strs (query-result-rows query-result))))
 
  ;Youming Lin
  ;modified version
  ;updated to properly format output for opening in notepad
  (defun queries->query-results-str (rows queries)
    (if (endp queries)
        ""
        (concatenate 'string
                     (query-result->str (rows-query->query-result rows (first queries)))
                     "\r\n \r\n"
                     (queries->query-results-str rows (rest queries)))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Takes a queries string and a data string and generates
  ; a single query-results string containing the result of each query
  ;@param data-str - string, ie. "team,date,points,assists\r\nBOS,20120101,85,20\r\nBOS,20120102,93,23\r\nCHI,20120102,76,14"
  ;@param queries-str - string, i.e. "SELECT team,date,points\r\nWHERE date = 20120101"
  ;@return string for output, i.e. "team,date,points\nBOS,20120101,85\n \n"
  (defun queries-data-str->query-results-str (data-str queries-str)
    (queries->query-results-str (str->rows data-str)
                                (str->queries queries-str)))
  
  
  
  (export IExecute))
