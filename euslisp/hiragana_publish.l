#!/usr/bin/env roseus
;;パソコンだけで読み取った文字を一つずつpublishするもの
;;Naoの機能の一部を取り出したもの
;;Naoの立ち上げ nao_driver.launch
;;roslaunch  object_learn_using_sift nao_object_learn_using_sift.launch
;;roseus hiragana_subscribe.l <- subscribe
;;python diary_publish.py
;;python play_voice_text_subscriber.py

(ros::load-ros-manifest "object_learn_using_sift")

(load "package://object_learn_using_sift/euslisp/nao-interface-kochigami.l")
;;(ros::roseus "interaction_behavior_test")
(ros::roseus-add-msgs "std_msgs")

(ros::advertise "nao_learn_word" std_msgs::string 1)

;;initialization
(ros::ros-info "nao initializing")
(setq *nao* (nao))
(setq *ni* (instance nao-interface :init))
(objects (list *nao*))
(setq *character-list* nil)
(setq *count_num* 0)
(setq *pre-japanese-char* nil)
(setq *call_num* 0)

(defun nao-servo-on()
  (send *ni* :servo-on)
  )

(defun nao-servo-off()
  (send *ni* :servo-off)
  )

(defun conversation (japanese-char)
  (let ((publish-msg nil)
        (word-string nil))
    ;;ひらがなを一回だけ受け取る                                               
    ;;ひらがなをリストに追加する
    ;;(print japanese-char)
    ;;(print *character-list*)
    ;;(setq *count_num* (+ *count_num* 1))
	
    (if (string= japanese-char "おわり")
	(progn
	  (setq *count_num* (+ *count_num* 1))
        ;;"おわり"を受け取ったらrostopic pubする →  後で日記にする
	  (if (= *count_num* 1)
	      (progn                                       
		(setq publish-msg (instance std_msgs::string :init))
		;;とりあえず、最初に認識した答えを登録する
		;;変える必要があるかも
		(send publish-msg :data (elt *character-list* 0))	       
		(ros::publish "nao_learn_word" publish-msg)
		(setq *character-list* nil)
		(send *ni* :play-soundfile "/home/nao/wav_test/touroku_shitayo.wav")
		(setq *call_num* 0)
		)
	    )
	  )
      (progn
	;;入ってくるのが""ではなく文字だったらということ
	;;現状では全部の文字を書かないといけない・・・
	
	(if (or (string= japanese-char "あ") (string= japanese-char "い")
                (string= japanese-char "う") (string= japanese-char "え")
                (string= japanese-char "お") (string= japanese-char "か")
                (string= japanese-char "き") (string= japanese-char "く")
                (string= japanese-char "け") (string= japanese-char "こ")
                (string= japanese-char "さ") (string= japanese-char "し")
                (string= japanese-char "す") (string= japanese-char "せ")
                (string= japanese-char "そ") (string= japanese-char "た")
                (string= japanese-char "ち") (string= japanese-char "つ")
                (string= japanese-char "て") (string= japanese-char "と")
                (string= japanese-char "な") (string= japanese-char "に")
                (string= japanese-char "ぬ") (string= japanese-char "ね")
                (string= japanese-char "の") (string= japanese-char "は")
                (string= japanese-char "ひ") (string= japanese-char "ふ")
                (string= japanese-char "へ") (string= japanese-char "ほ")
                (string= japanese-char "ま") (string= japanese-char "み")
                (string= japanese-char "む") (string= japanese-char "め")
                (string= japanese-char "も") (string= japanese-char "や")
                (string= japanese-char "ゆ") (string= japanese-char "よ")
                (string= japanese-char "ら") (string= japanese-char "り")
                (string= japanese-char "る") (string= japanese-char "れ")
                (string= japanese-char "ろ") (string= japanese-char "わ")
                (string= japanese-char "を") (string= japanese-char "ん")
		(string= japanese-char "ていし")
		)
	    (progn
	      (setq *character-list* (append *character-list* (list japanese-char)))
	      (if (not (string= *pre-japanese-char* japanese-char))
		  (progn
		    (setq *call_num* 0)
		    )
		)
	      (if (= *call_num* 0)
		  (progn
		    (if (string= japanese-char "の")
			(send *ni* :play-soundfile "/home/nao/wav_test/no.wav"))
		    (if (string= japanese-char "り")
			(send *ni* :play-soundfile "/home/nao/wav_test/ri.wav"))
		    (if (string= japanese-char "い")
			(send *ni* :play-soundfile "/home/nao/wav_test/i.wav"))  
		    (setq *call_num* (+ *call_num* 1))
		    (setq *pre-japanese-char* japanese-char)
		    )
		)
	      (setq *count_num* 0)
	      )
	  )
	)
      )
    )
  )

(defun character-detect-cb (msg)
  (let ((japanese-char 0))
    ;;読み取ったひらがなを返す                                             
    (progn
      (setq japanese-char (send msg :data))
      (conversation japanese-char)
      )
    )
  )

;;subscribe topics
(ros::subscribe "/nao_character_learn" std_msgs::String  #'character-detect-cb)
;;main loop
(ros::ros-info "Let's start")
(while (ros::ok)
;;  (nao-servo-on)
  (ros::spin-once)
  (ros::sleep)
)


