;; The first four lines of this file were added by Dracula.
;; They tell DrScheme that this is a Dracula Modular ACL2 program.
;; Leave these lines unchanged so that DrScheme can properly load this file.
#reader(planet "reader.rkt" ("cce" "dracula.plt") "modular" "lang")
(require "specifications.lisp")

(module MInput
  
  (import IImage)
  
  (defun rat->byte-rec (rat exponent)
    (if (< exponent 1)
        nil
        (cons (if (>= rat exponent) 1 0)
           (rat->byte-rec (if (>= rat exponent) (- rat exponent) rat) (/ exponent 2)))))
  
  (defun rat->byte (rat)
    (rat->byte-rec rat 128))

  (defun read-n-bytes/bits (n bytes-already-in channel state)
    (if (or (not (integerp n)) (<= n 0))
        (mv bytes-already-in channel state)
        (mv-let (byte state) (read-byte$ channel state)
                (if (null byte)
                    (mv bytes-already-in channel state)
                    (read-n-bytes/bits (- n 1)
                                  (append (rat->byte byte) bytes-already-in) channel state)))))
  
  (defconst *max-file-size* 4000000000) ;;limits input file to 4GB
  (defun binary-file->bit-list (fname state)
    (mv-let (byte-list error state)
            (mv-let (channel state) (open-input-channel fname :byte state)
                    (if (null channel)
                        (mv nil
                            (string-append "Error while opening file for input: "
                                           fname)
                            state)
                        (mv-let (byte-list chnl state)
                                (read-n-bytes/bits *max-file-size* '() channel state)
                                (let ((state (close-input-channel chnl state)))
                                  (mv byte-list nil state)))))
            (mv (reverse byte-list) error state)))
  
  (defun read-file (fname state)
    (bits->img (car (binary-file->bit-list fname state))))
  
  (export IInput))