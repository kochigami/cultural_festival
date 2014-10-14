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
(mapcar #'(lambda (x) (pub-led (button2led-id x) :orange))
        (list 8 16 24 32 40)) ;; hoge

(setq *lct* (instance launchpad-control-template :init))
(ros::rate 30)
(while (ros::ok)
  (ros::spin-once)
  (ros::sleep)
  )
