(defsystem "lambda_sakura"
  :version "0.1"
  :description "lambda_sakura's library."
  :author "lambda_sakura  <lambda.sakura@gmail.com>"
  :licence "MIT"
  :components 
  ((:module src
	    :components
	    ((:file "packages")
	     (:file "macros")
	     (:file "get-env")
	     (:file "exec-command" :depends-on ("get-env"))
	     (:file "dbind")))))

