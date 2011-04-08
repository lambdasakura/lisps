(defun my-getenv (name &optional default)
    #+CMU
    (let ((x (assoc name ext:*environment-list*
                    :test #'string=)))
      (if x (cdr x) default))
    #-CMU
    (or
     #+Allegro (sys:getenv name)
     #+CLISP (ext:getenv name)
     #+ECL (si:getenv name)
     #+SBCL (sb-unix::posix-getenv name)
     #+LISPWORKS (lispworks:environment-variable name)
     default))
(my-getenv "PATH")

(defun exec-command ()
  (with-output-to-string (out)
    (sb-ext:run-program "/bin/make" '("." "-l") :output out)))

(defun exec-command ()
  (with-output-to-string (out)
    (sb-ext:run-program "/usr/bin/gcc" '("./test.c" "-o" "hoge") :output out)))

(defun exec-command (command)
  (with-output-to-string (out)
    (sb-ext:run-program command nil :search (my-getenv "PATH") :output out)))

(exec-command "ls")

(defun |#`-reader| (stream sub-char numarg)
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
	(if (string= pattern (string-left-trim '(#\Newline #\Tab #\Space) curr))
	    (return))
	(setq output (concatenate 'string output (exec-command curr) (make-string 1 :initial-element #\newline))))
      (string-right-trim '(#\Newline) output )
      )))

(set-dispatch-macro-character
 #\# #\` #'|#`-reader|)



(defun |#@-reader| (stream sub-char numarg)
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
	(if (string= pattern (string-left-trim '(#\Newline #\Tab #\Space) curr))
	    (return))
	(setq output (concatenate 'string output curr )))
      (string-right-trim '(#\Newline) output )
      )))

(set-dispatch-macro-character
 #\# #\@ #'|#@-reader|)

(setq hoge #@END
this is 
test
string
           END
)

(setq hoge #`END
ls
date
 END
)
