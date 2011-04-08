(defsystem "gmail"
  :version "0.1"
  :description "send from gmail."
  :author "lambda_sakura  <lambda.sakura@gmail.com>"
  :licence "MIT"
  :components
  ((:file "packages")
   (:file "gmail" :depends-on ( "packages" )))
  :serial t
  :depends-on
  (:trivial-shell
   :cl-smtp))
