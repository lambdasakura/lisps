(defun |#<-reader| (stream sub-char numarg)
  (declare (ignore sub-car numarg))
  (let (chars)
    (do ((curr (read-char stream)
	       (read-char stream)))
	((char= #\newline curr))
      (push curr chars))
    (let* ((pattern (coerce (nreverse chars) 'string))
	   (pointer pattern)
	   (output))
      (do ((curr (read-line stream)
		 (read-line stream)))
	  ((null curr))
	(if (string= pattern curr)
	    (return))
	(setq output (concatenate 'string output curr (make-string 1 :initial-element #\newline))))
      (string-right-trim '(#\Newline) output )
      )))

(set-dispatch-macro-character
 #\# #\< #'|#<-reader|)

(setq hoge #<END
this is 
test
string
END
)

(let ((let '`(let ((let ',let))
	       ,let)))
  `(let ((let `,let)) ,let))