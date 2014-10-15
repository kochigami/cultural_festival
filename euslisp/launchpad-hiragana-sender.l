#!/usr/bin/env roseus

;; midiコントローラ"launchpad mini"でロボットを操作するテンプレートです。
;; "hoge"のあたりを直すと使えると思います。

(ros::roseus "launchpad_control_template")

;;(require :hoge-robot-interface "package://hoge_robot/euslisp/hoge-robot-interface.l")
(require :launchpad-twinkle "package://launchpad_twinkle/euslisp/launchpad-twinkle.l")

(ros::load-ros-manifest "sensor_msgs")

;; buttons
;; -------------------
;;  *  * ...  *  *
;; -- -- --- -- --
;;  8  9 ... 14 15 | 0
;; 16 17 ... 22 23 | 1
;;  .  . .    .  . | .
;;  .  .   .  .  . | .
;; 56 57 ... 62 63 | 6
;; 64 65 ... 70 71 | 7
;; -------------------

(ros::advertise "hiragana_send_to_nao" std_msgs::string 1)

(defclass launchpad-control-template
  :super object
  :slots ())

(defmethod launchpad-control-template
  (:init
   ()
   (ros::subscribe "/joy" sensor_msgs::Joy #'send self :joy-cb)
   )

  ;; この中に実行したい関数やメソッドを書いていく
  ;; ボタンの位置は上図を参照のこと
  (:joy-cb
   (msg)
   (case (send self :get-idx-from-value (send msg :buttons) 1)
     ( 8 (hiragana_sender "あ"))
     (16 (hiragana_sender "い"))
     (24 (hiragana_sender "う"))
     (32 (hiragana_sender "え"))
     (40 (hiragana_sender "お"))
     ( 9 (hiragana_sender "か"))
     (17 (hiragana_sender "き"))
     (25 (hiragana_sender "く"))
     (33 (hiragana_sender "け"))
     (41 (hiragana_sender "こ"))
     (10 (hiragana_sender "さ"))
     (18 (hiragana_sender "し"))
     (26 (hiragana_sender "す"))
     (34 (hiragana_sender "せ"))
     (42 (hiragana_sender "そ"))
     (11 (hiragana_sender "た"))
     (19 (hiragana_sender "ち"))
     (27 (hiragana_sender "つ"))
     (35 (hiragana_sender "て"))
     (43 (hiragana_sender "と"))
     (12 (hiragana_sender "な"))
     (20 (hiragana_sender "に"))
     (28 (hiragana_sender "ぬ"))
     (36 (hiragana_sender "ね"))
     (44 (hiragana_sender "の"))
     (13 (hiragana_sender "は"))
     (21 (hiragana_sender "ひ"))
     (29 (hiragana_sender "ふ"))
     (37 (hiragana_sender "へ"))
     (45 (hiragana_sender "ほ"))
     (14 (hiragana_sender "ま"))
     (22 (hiragana_sender "み"))
     (30 (hiragana_sender "む"))
     (38 (hiragana_sender "め"))
     (46 (hiragana_sender "も"))
     (15 (hiragana_sender "や"))
     (23 (hiragana_sender "ゆ"))
     (31 (hiragana_sender "よ"))
     (39 (hiragana_sender "ら"))
     (47 (hiragana_sender "り"))
     (55 (hiragana_sender "る"))
     (63 (hiragana_sender "れ"))
     (71 (hiragana_sender "ろ"))
     (0  (hiragana_sender "わ"))
     (1  (hiragana_sender "を"))
     (2  (hiragana_sender "ん")) 
     )
   )
  ;; 同時押しの場合は後ろの番号を返す
  (:get-idx-from-value
   (l value)
   (let ((answer-idx nil))
     (dotimes (idx (length l))
       (if (equal (elt l idx) value) (setq answer-idx idx)))
     answer-idx)
   )
  )

(defun hiragana_sender (japanese-char)
  (setq publish-msg (instance std_msgs::string :init))
  (send publish-msg :data japanese-char)
  (ros::publish "hiragana_send_to_nao" publish-msg)
  )

;;(hoge-robot-init)

;; midi_config_player待ち。
(unix::sleep 1)

;; 割り当てたボタンを光らせると分かりやすい
;;(mapcar #'(lambda (x) (pub-led (button2led-id x) :orange))
;;        (list 8 16 24 32 40 9 17 25 33 41 10 18 26 34 42 11 19 27 35 43 12 20 28 36 44 13 21 29 37 45 14 22 30 38 46 15 23 31 39 47 55 63 71 0 1 2)) ;; hoge

(setq *lct* (instance launchpad-control-template :init))
(ros::rate 30)
(while (ros::ok)
  (ros::spin-once)
  (ros::sleep)
  )
