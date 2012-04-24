;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
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