;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(interface IExecute
  
  ; Evaluates a row based off of a predicate
  (sig evaluate-filter (row predicate))
  
  ; Filters a list of rows into only those rows which match the filter
  (sig filter-rows (rows filter))
  
  ; Extracts the data corresponding to a given field
  (sig extract-field-data (field row))
  
  ; Reduces a row into values corresponding to a list of fields
  ; '((field1 . value1) (field2 . value2) (field3 . value3))
  ; -->
  ; '(value1 value3)
  (sig filter-fields-row (fields row))
  
  ; Filters multiple rows by a list of fields to display
  (sig filter-fields-rows (fields rows))
  
  ; Evaluates a query on a list of rows
  (sig rows-query->query-result (rows query))
  
  (sig row->csv-str (row))
  
  (sig rows->csv-strs (rows))
  
  (sig query-result->str (query-result))
  
  (sig rows-query-strs->query-result-str (data-str query-str))
  
  (sig queries->query-results-str (rows queries))
  
  (sig queries-data-str->query-results-str (data-str queries-str)))

