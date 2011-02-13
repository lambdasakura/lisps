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
;; もとのコード
;;
(defclass fairy (flying-enemy
		 enemy
		 collidable)
  ())
(defmethod initialize-instance :after ((fairy-ins fairy) &rest arg)
  "fairyのコンストラクタ
fairyのアニメの初期化はここで実施する。"
  (declare (ignore arg))
  (add-animation fairy-ins "Stand" "Resource/picture/Character/Fairy/Stand/")
  (add-animation fairy-ins "Walk" "Resource/picture/Character/Fairy/Walk/")
  (change-animation  fairy-ins "Stand"))

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