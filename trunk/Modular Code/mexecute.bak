;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@date April 22, 2012

(require "specifications.lisp")

(module MExecute
  (import IList-Utilities)
  (import IParse-Data)
  (import IParse-Queries)
  (import IString-Utilities)
  (import IStructures)
  
  ; Evaluates a row based off of a predicate
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
  (defun filter-fields-row (fields row)
    (if (endp fields)
        nil
        (cons (extract-field-data (first fields) row)
              (filter-fields-row (rest fields) row))))
  
  ; Filters multiple rows by a list of fields to display
  (defun filter-fields-rows (fields rows)
    (if (endp rows)
        nil
        (cons (filter-fields-row fields (first rows))
              (filter-fields-rows fields (rest rows)))))
  
  ; Evaluates a query on a list of rows
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
  
  ; Converts multiple rows to multiple strings of comma-separated values
  (defun rows->csv-strs (rows)
    (if (endp rows)
        ""
        (concatenate 'string
                     (row->csv-str (first rows))
                     (if (second rows)
                         (make-string #\NewLine)
                         "")
                     (rows->csv-strs (rest rows)))))
  
  (defun query-result->str (query-result)
    (concatenate 'string
                 (row->csv-str (query-result-fields query-result))
                 "\n"
                 (rows->csv-strs (query-result-rows query-result))))
  
  (defun queries->query-results-str (rows queries)
    (if (endp queries)
        ""
        (concatenate 'string
                     (query-result->str (rows-query->query-result rows (first queries)))
                     "\n\r \n\r"
                     (queries->query-results-str rows (rest queries)))))
  
  ; Takes a queries string and a data string and generates
  ; a single query-results string containing the result of each query
  (defun queries-data-str->query-results-str (data-str queries-str)
    (queries->query-results-str (str->rows data-str)
                                (str->queries queries-str)))
  (export IExecute))
