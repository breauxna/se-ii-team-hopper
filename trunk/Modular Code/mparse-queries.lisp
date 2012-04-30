;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MParse-Queries
  
  (include-book "list-utilities" :dir :teachpacks)
  (include-book "io-utilities" :dir :teachpacks)
  
  (import IString-Utilities)
  (import IList-Utilities)
  (import IStructures)
  (import IError)
  
  (import IImprovements)
  
  (defconst *keywords* (strs->chrss (list "(" ")"
                                          "<=" "<" 
                                          ">=" ">" 
                                          "=" 
                                          "&&" 
                                          "||" 
                                          "!"
                                          ",")))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;modified to skip commas as well
  (defun tokenize-chrs (cs)
    (cond ((endp cs) nil)
          ((or (whitespacep (first cs)) (equal (car cs) #\,))
           (tokenize-chrs (rest cs))) ; ignore white space and commas
          ((alphanump (first cs))
           (mv-let (word remainder)   ; grab the rest of the value
                   (cut-alphanum cs)
                   (error-cons word (tokenize-chrs remainder))))
          ((quotationp (first cs))    ; grab the rest of the string
           (mv-let (word remainder)
                   (cut-to-quotation (rest cs))
                   (error-cons (error-cons #\" word) (tokenize-chrs remainder))))
          
          (t
           (mv-let (keyword remainder) ; grab the keyword
                   (cut-keyword cs *keywords*)
                   (if keyword
                       (error-cons keyword (tokenize-chrs remainder))
                       (make-error (string+ (list "Unexpected character: " (first cs)))))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Tokenizes a string
  ;@param str - string, i.e. "SELECT team,date,points\r\nWHERE date = 20120101"
  ;@return list of strings with delimiters removed, i.e. '("SELECT" "team" "," "date" "," "points" "WHERE" "date" "=" "20120101")
  (defun tokenize (str)
    (let ((tokens (tokenize-chrs (str->chrs str))))
      (if (error-p tokens)
          tokens
          (chrss->strs tokens))))
  
  (defun infix-splitting-index-helper (target tokens paren-depth index)
    (cond ((endp tokens)
           nil)
          ((equal (first tokens) "(")
           (infix-splitting-index-helper target (rest tokens) (1+ paren-depth) (1+ index)))
          ((equal (first tokens) ")")
           (infix-splitting-index-helper target (rest tokens) (1- paren-depth) (1+ index)))
          ((and (equal 0 paren-depth)
                (equal (first tokens) target))
           index)
          (t
           (infix-splitting-index-helper target (rest tokens) paren-depth (1+ index)))))
  
  ; Finds the uppermost occurance of a target token in a list of tokens.
  ; Uppermost means the lowest precedence (fewest parentheses surrounding the token)
  ; If there exists more than one instance at parentheses level 0, we take the first one.
  ;@param target - target token, i.e. "WHERE"
  (defun infix-splitting-index (target tokens)
    (infix-splitting-index-helper target tokens 0 0))
  
  ; Gets the associated operator for a string.
  (defun str->operator (str)
    (cdr (assoc-equal str
                      '(("||" . or)
                        ("&&" . and)
                        ("!" . not)
                        ("<" . <)
                        ("<=" . <=)
                        (">" . >)
                        (">=" . >=)
                        ("=" . =)))))
  
  ; Returns true if token is a field.
  (defun is-field (token)
    (alpha-char-p (char token 0)))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;updated to use improved functions, i.e. is-numeric and is-string
  (defun tokens->expression (tokens)
    (let ((split-index 
           (or (infix-splitting-index "||" tokens)   ; Here, or returns the first value that is not nil
               (infix-splitting-index "&&" tokens)   ; This list is sorted by precedence, so the first non-nil
               (infix-splitting-index "=" tokens)    ; value will be the highest-precedent operator
               (infix-splitting-index "<" tokens)    ; If no operators are found on the highest level, split index
               (infix-splitting-index "<=" tokens)   ; will be nil.
               (infix-splitting-index ">" tokens)
               (infix-splitting-index ">=" tokens))))
      (cond (split-index ;not nil
             (list (str->operator (nth split-index tokens))                 ; Operator
                   (tokens->expression (first-n split-index tokens))        ; Operand 1
                   (tokens->expression (nthcdr (1+ split-index) tokens))))  ; Operand 2
            
            ((and (equal (first tokens) "(")                                ; If enclosed in parentheses, 
                  (equal (first (last tokens)) ")"))                        ; hack away a level of parentheses
             (tokens->expression (sandwich-material tokens)))
            
            ((equal (first tokens) "!")                                     ; Not
             (list 'not (tokens->expression (rest tokens))))
            
            ((and (equal 1 (length tokens))                                 ; Field
                  (is-field (first tokens)))
             (list :field (first tokens)))
            
            ((and (equal 1 (length tokens))                                 ; Literal string (remove quotation marks)
                  (is-string (first tokens)))
             (list :literal (chrs->str (sandwich-material (str->chrs (first tokens))))))
            
            ((and (equal 1 (length tokens))                                  ; Literal
                  (is-numeric (first tokens)))
             (list :literal (str->rat (first tokens)))))))
  
  ;Youming Lin
  ;modified version
  ;simplified algorithm
  (defun parse-query-tkns (tkns)
    (let* ((where-index (infix-splitting-index "WHERE" tkns))
           (before-where (and where-index (first-n where-index tkns)))
           (fields (rest before-where))
           (filter (and where-index (nthcdr (1+ where-index) tkns))))
      (cond ((not where-index)
             (make-error "Couldn't find WHERE"))
            ((not fields)
             (make-error "Couldn't find fields"))
            ((not (equal (first before-where) "SELECT"))
             (make-error "Couldn't find SELECT"))
            (t
             (query fields
                    (tokens->expression filter))))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  ; Converts a list of list of tokens into multiple queries
  ;@param tknss - list of list of tokens, i.e. '(("SELECT" "team" "," "date" "," "points" "WHERE" "date" "=" "20120101"))
  ;@return list of query objects, i.e. '((query ("team" "date" "points") (= (:field "date") (:literal 20120101))))
  (defun tknss->queries (tknss)
    (if (endp tknss)
        nil
        (cons (parse-query-tkns (first tknss))
              (tknss->queries (rest tknss)))))
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Youming Lin
  ;modified version
  ;modifieid output to match the correct output
  (defun str->queries (str)
    (tknss->queries (chunk-by "SELECT" (tokenize str))))
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (export IParse-Queries))
