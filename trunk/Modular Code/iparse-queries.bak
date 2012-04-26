;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(interface IParse-Queries
  
  (sig tokenize-chrs (cs))
  (sig tokenize (str))
  
  ; finds the uppermost occurance of a target token in a list of tokens
  (sig infix-splitting-index-helper (target tokens paren-depth index))
  
  (sig str->operator (str))
  
  ; Returns true if token is a field.
  (sig is-field (token))
  
  ; Returns true if token is a string.
  (sig is-string (token))
  
  ; Returns true if token is a literal (a number)
  (sig is-literal (token))
  
  ; Parses a list of tokens into an expression
  (sig tokens->expression (tokens))
  
  ; Parses a string into a predicate
  (sig str->expression (str))
  (sig parse-fields (tkns))
  
  
  (sig parse-query-tkns (tkns))
  
  (sig str->query (str))
  
  (sig tknss->queries (tknss))
  
  (sig str->queries (str)))
