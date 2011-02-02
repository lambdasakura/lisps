;;;
;;; sharp-at.lisp
;;;
;;; Copyright (C) 2011, lambda_sakura  <lambda.sakura@gmail.com>
;;;
;;; Permission is hereby granted, free of charge, to any person
;;; obtaining a copy of this software and associated documentation
;;; files (the "Software"), to deal in the Software without
;;; restriction, including without limitation the rights to use, copy,
;;; modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be
;;; included in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;; NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.
(in-package #:lambda_sakura)
(defun |#>-reader| (stream sub-char numarg)
  (declare (ignore sub-car numarg))
  (let (chars)
    (do ((curr (read-char stream)
            (read-char stream)))
     ((char= #\newline curr))
      (push curr chars))
    (let* ((pattern (nreverse chars))
        (pointer pattern)
        (output))
    (do ((curr (read-char stream)
            (read-char-stream)))
     ((null pointer))
      (push curr output)
      (setf pointer
         (if (char= (car pointer) curr)
             (cdr pointer)
             pattern))
      (if (null pointer)
       (return)))
    (coerce
     (nreverse
      (nthcdr (length pattern) output))
     'string))))

(set-dispatch-macro-character
 #\# #\> #'|#>-reader|)

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
	(setq output
	      (concatenate 'string output curr (make-string 1 :initial-element #\newline))))
      (string-right-trim '(#\Newline) output))))
(set-dispatch-macro-character
 #\# #\< #'|#<-reader|)

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

