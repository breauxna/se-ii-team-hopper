;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.ss" ("cce" "dracula.plt") "modular" "lang")
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