(defclass co-routine ()
  ((cont :accessor cont :initform nil)))
(defmacro yield ()
  `(cl-cont:let/cc cc
     (setf (cont co-routine)  cc)))
(defmethod run ((co-routine co-routine))
  (if (cont co-routine)
      (funcall (cont co-routine))
      (routine co-routine)))
(defmethod routine ((co-routine co-routine))
  (cl-cont:with-call/cc
    (loop repeat 1000
       do 
	 (p1)  (yield)
	 (p2)  (yield)
	 (p3)  (yield))))
  
;;(setf test-ins (make-instance 'co-routine))

(defvar *save*)
(defun f ()
  (cl-cont:with-call/cc
    (cl-cont:let/cc cc
      (ff cc))))


(defun p1 () (print 1))
(defun p2 () (print 2))
(defun p3 () (print 3))

(defun ff ()
  (cl-cont:with-call/cc
    ;; １０００かい繰り返す
    (loop repeat 1000
	 do 
	 (p1)
	 ;; ここで一旦停止
	 (cl-cont:let/cc cc  cc)
	 (p2)
       ;; ここで一旦停止
	 (cl-cont:let/cc cc  cc)
	 (p3)
       ;; ここで一旦停止
	 (cl-cont:let/cc cc  cc))))
