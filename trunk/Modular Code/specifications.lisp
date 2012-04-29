;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
;@author Nathan Breaux, Youming Lin, Kyle Morse
;@date Apr 28, 2012
;@version 1.0

;Specifications files
;Contains all of the interfaces for all of the modules

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                      Main module                    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IRun
  
  (sig read-transform-write (data-in query-in f-out state))
  (sig run (data-in query-in f-out)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    Parsing modules                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IParse-Data
  
  ; Converts a string delimited by commas to a list of tokens
  (sig str->tkns (str))
  
  ; Converts a list of strings to a list of list of tokens
  (sig strs->tknss (strs))
  
  ; Given a list of header tokens, converts a list of data tokens to a data row
  ; header-tkns: '("field1" "field2" ... "fieldn")
  ; str-tkns:    '("value1" "value2" ... "valuen")
  ; -->
  ; '(("field1" . value1) ("field2" . value2) ... ("fieldn" . valuen))
  (sig tkns->row (header-tkns str-tkns))
  
  ; Given a list of header tokens, converts a list of lists of tokens to a list of data rows
  ; (See example)
  (sig tknss->rows (header-tkns str-tknss))
  
  ; Converts the data string (with header and data)
  ; to data rows (("field1" . value1) ... ("fieldn" . value2))
  (sig str->rows (str)))

(interface IParse-Queries
  
  (sig tokenize-chrs (cs))
  (sig tokenize (str))
  
  ; finds the uppermost occurance of a target token in a list of tokens
  (sig infix-splitting-index-helper (target tokens paren-depth index))
  
  (sig str->operator (str))
  
  ; Returns true if token is a field.
  (sig is-field (token))
  
  ; Returns true if token is a string.
  ;(sig is-string (token))
  
  ; Returns true if token is a literal (a number)
  ;(sig is-literal (token))
  
  ; Parses a list of tokens into an expression
  (sig tokens->expression (tokens))
  
  ; Parses a string into a predicate
  ;(sig str->expression (str))
  ;(sig parse-fields (tkns))
  
  
  (sig parse-query-tkns (tkns))
  
  ;(sig str->query (str))
  
  (sig tknss->queries (tknss))
  
  (sig str->queries (str)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Data structures module              ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IStructures
  (sig query (fields filter))
  (sig query-fields (query))
  (sig query-filter (query))
  
  (sig query-result (fields rows))
  (sig query-result-fields (query-result))
  (sig query-result-rows (query-result)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                   Execution module                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
  
  ;(sig rows-query-strs->query-result-str (data-str query-str))
  
  (sig queries->query-results-str (rows queries))
  
  (sig queries-data-str->query-results-str (data-str queries-str)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                    Utility modules                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IList-Utilities
  
  (sig booleanify (x))
  
  (sig first-n (n xs))
  
  ; Discards the first and last element of a list.
  (sig sandwich-material (xs))
  
  (sig chunk-by-helper (delimiter xs so-far))
  
  (sig chunk-by (delimiter xs))
  
  ;(sig remove-nils (xs))
  )

(interface IString-Utilities
  
  (sig strs->chrss (strs))
  (sig chrss->strs (chrss))
  (sig whitespacep (c))
  (sig quotationp (c))
  (sig alphanump (c))
  (sig make-string (x))
  (sig has-prefix (xs prefix))
  (sig cut-alphanum (cs))
  (sig cut-keyword (cs keywords))
  (sig cut-to-quotation (cs))
  (sig string+ (xs))
  (sig break-by-line (str))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                 Error checking module               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IError
  
  (sig make-error (msg))
  
  (sig error-p (x))
  
  (sig error-cons (x y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;                  Improvements module                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(interface IImprovements
  (sig is-string (token))
  (sig is-numeric (str)))


