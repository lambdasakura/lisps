(in-package :jp.ddo.light-of-moe.ddo.jp.send-gmail)
;; flexi-streams をだます。
(pushnew '(:iso-2022-jp . :utf-8) flex::+name-map+ :test #'equal)
(defvar *smtp-server* "smtp.gmail.com" "SMTPサーバーの位置")

(defun encode-subject (subject)
  (let ((subject (trivial-shell:shell-command
                  "nkf -M"
                  :input (trivial-shell:shell-command
                          "nkf -j"
                          :input subject))))
    (subseq subject 0 (1- (length subject)))))

(defun encode-message (message)
  (trivial-shell:shell-command "nkf -j"
                               :input (format nil "~a~%" message)))

(defun send-mail (from to subject message username password)
  (let ((subject (encode-subject subject))
        (message (encode-message message)))
    (cl-smtp:send-email *smtp-server*  from to subject message
                        :external-format :iso-2022-jp
                        :extra-headers
			'(("Content-Transfer-Encoding" "7bit"))
			:ssl :tls :authentication 
			`(:login ,username ,password))))
