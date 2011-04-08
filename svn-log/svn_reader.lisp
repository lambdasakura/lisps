(ql:quickload "cl-ppcre")
(defparameter splitter
  "------------------------------------------------------------------------" )

(defclass svn-log ()
  ((revision :initarg :revision :initform nil :accessor revision)
   (date :initarg :date :initform nil :accessor date)
   (author :initarg :author :initform nil :accessor author)
   (files :initarg :files :initform nil :accessor files)))

(defun get-all-file-text (filename)
  "this function read string from file. and return that string."
  (with-output-to-string (s)
    (handler-case
	(with-open-file (in filename :direction :input )
	  (loop for line = (read-line in nil)
	     while line
	     do (write-line line s)))
      (t () (error (format nil "Can't read file:~A" filename))))))
(defun get-each-log (filename)
  "read svn's log from text formatted file.Argment is filename."
  (loop for log in (cl-ppcre:split splitter (read-svn-log filename))
       collect (string-trim '(#\Space #\Newline) log)))
(defun create-svn-log-instance (head files)
  (destructuring-bind (revision author date files) (append (cl-ppcre:split "\\\|" head) (list files))
    (describe (make-instance 'svn-log
		   :author (string-trim '(#\Space) author)
		   :date date
		   :revision (string-trim '(#\Space) revision)
		   :files (loop for file in files
			       collect (string-trim '(#\Space) file))
			       ))))

(defun parse-each-log (svn-logs)
  (loop for log in svn-logs
       do 
       (let ((log-text (cl-ppcre:split "\\n" log)))
	 (when (< 2 (length log-text ))
	   (destructuring-bind (head temp &rest files) log-text
	     (declare (ignore temp))
	     (create-svn-log-instance head files))))))
