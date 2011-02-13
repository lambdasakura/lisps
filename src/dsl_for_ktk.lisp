(defmacro enemy (name &key (attr 'landing-enemy) animation)
  `(progn
     (defclass ,name (,@attr
		      enemy
		      collidable)
       ())
     (defmethod initialize-instance :after ((,name ,name)  &rest arg)
       (declare (ignore arg))
       ,@(mapcar 
	  #'(lambda (x)
	      `(add-animation ,name x))
	  animation)
       (change-animation  ,name "Stand"))))

;;
;; DSLのテストコード
;;
(enemy test
       :attr
       (flying-enemy
       test-enemy)
       :animation
       (("Stand" "Resource/picture/Character/Fairy/Stand/")
	("Walk" "Resource/picture/Character/Fairy/Walk/")))