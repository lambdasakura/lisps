;;(asdf:oos 'asdf:load-op 'jp)
(asdf:oos 'asdf:load-op 'sqlite)

(use-package :sqlite)
(use-package :iter)

(defvar *db* (connect ":memory:")) ;;Connect to the sqlite database. :memory: is the temporary in-memory database

(execute-non-query *db* "create table users (id integer primary key, user_name text not null, age integer null)") ;;Create the table

(execute-non-query *db* "insert into users (user_name, age) values (?, ?)" "joe" 18)
(execute-non-query *db* "insert into users (user_name, age) values (?, ?)" "dvk" 22)
(execute-non-query *db* "insert into users (user_name, age) values (?, ?)" "qwe" 30)
(execute-non-query *db* "insert into users (user_name, age) values (?, ?)" nil nil) ;; ERROR: constraint failed

(execute-single *db* "select id from users where user_name = ?" "dvk")
;; => 2
(execute-one-row-m-v *db* "select id, user_name, age from users where user_name = ?" "joe")
;; => (values 1 "joe" 18)

(execute-to-list *db* "select id, user_name, age from users")
;; => ((1 "joe" 18) (2 "dvk" 22) (3 "qwe" 30))

;; Use iterate
(iter (for (id user-name age) in-sqlite-query "select id, user_name, age from users where age < ?" on-database *db* with-parameters (25))
      (collect (list id user-name age)))
;; => ((1 "joe" 18) (2 "dvk" 22))

;; Use prepared statements directly
(loop
   with statement = (prepare-statement *db* "select id, user_name, age from users where age < ?")
   initially (bind-parameter statement 1 25)
   while (step-statement statement)
   collect (list (statement-column-value statement 0) (statement-column-value statement 1) (statement-column-value statement 2))
   finally (finalize-statement statement))
;; => ((1 "joe" 18) (2 "dvk" 22))

(disconnect *db*) ;;Disconnect