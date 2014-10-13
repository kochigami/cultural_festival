#!/usr/bin/env roseus
;; jsk-ros-pkg/jsk_demos/interactive_behavior_201409のコードを見ながら書いています。
;;まだ途中...
(ros::load-ros-manifest "object_learn_using_sift")

(ros::roseus-add-msgs "face_detector_mono")
(ros::roseus-add-msgs "nao_msgs") ;;tactile
(ros::roseus-add-msgs "std_msgs")

(require :nao-interface "/home/kochigami/ros/groovy/object_learn_using_sift/euslisp/nao-interface-kochigami.l")
(ros::roseus "interaction_behavior_by_nao")

(ros::advertise "nao_learn_word" std_msgs::string 1)
(ros::advertise "nao_regist_stop" std_msgs::string 1)

;;initialization
(ros::ros-info "nao initializing")
(setq *nao* (nao))
(setq *ni* (instance nao-interface :init))
(objects (list *nao*))
(setq *current-behavior* :idle)
(setq *behavior-start-time* (ros::time-now))
(setq *tfl* (instance ros::transform-listener :init))
(setq *idle-check-timeout* 0)
(setq *register-check* 10)
(setq *character-list* nil)
(setq *conversation_finished* 0)
(setq *pre-japanese-char* "っ")

;;/tactile系を調べる

;; ---behaviors---
;; :idle -> sometimes look and speak
;; :eyecontact -> :talking

(defun nao-servo-on() 
  (send *ni* :servo-on)
  )

(defun nao-servo-off()
  (send *ni* :servo-off)
  )
;;behaviorをidleに戻す関数
(defun idle-check()
  (let ((now (ros::time-now)))
    ;;(print *current-behavior*)
    ;;idleじゃないとき ある時間(*idle-check-timeout*)を過ぎたらidleになる
    (if (eq *current-behavior* :eyecontact)
	(if (> (send (ros::time- now *behavior-start-time*) :to-sec) *idle-check-timeout*)
	    (progn
	      (if (= (random 2) 0) 
		  (progn
		    (set-behavior :talking)
		    )
		(progn
		  (setq *current-behavior* :idle)
		  (print *current-behavior*)
		  )
	      )
	  )
	  
      ;;idleのとき ある確率で:look-and-speakモードに移行する(キョロキョロしてお話)
      )
      (progn
	(if (eq *current-behavior* :idle)
	    (progn
	      ;;(print "idle now")
	      (if (= (random 2) 0)
		  (progn
		    (looking_and_speaking)
		    )
		)
	      )
	  ;; :talkingの終了
	  (progn
	    (if (eq *conversation_finished* 1)
		(progn
		  (setq *current-behavior* :idle)
		  (setq *conversation_finished* 0)
		  )
	      )
	    )
	  )
	)
      )
  )

;;behaviorをセットする関数
(defun set-behavior (behavior &rest args)
  (setq *current-behavior* behavior)
  (setq *behavior-start-time* (ros::time-now))
  (print *current-behavior*)
  (if (eq *current-behavior* :talking)
      (progn
	;;ファイルの話す速さに差があるので直す
	(send *ni* :play-soundfile "/home/nao/wav_test/jikosyoukai.wav")
	(send *ni* :play-soundfile "/home/nao/wav_test/watashi_ha_nao_namae_ha_nante_iuno.wav")
	(send *ni* :play-soundfile "/home/nao/wav_test/nao_ni_moji_wo_hitotsuzutu_misetene.wav")
	(send *ni* :play-soundfile "/home/nao/wav_test/nao_wakattara_sonomojiwoyomukara.wav")
	)
    )
  )

(defun looking_and_speaking()
   ;;左右向く
   (let ((sound_decision (random 4))
	 (neck_move_decision (random 2)))
     (if (= (random 10) 0)
	 (send *nao* :angle-vector (send *ni* :state :potentio-vector))
       (when (= neck_move_decision 0)
	 (send *nao* :head :neck-y :joint-angle 20)
	 (send *ni* :angle-vector (send *nao* :angle-vector))
	 )
       (when (= neck_move_decision 1)
	 (send *nao* :head :neck-y :joint-angle -20)
	 (send *ni* :angle-vector (send *nao* :angle-vector))
	 )
       ;;ランダムにしゃべる "はらへったー" "むにゃむにゃ" "ひまだなあ"
       (progn
	 (if (= sound_decision 0)
	     (send *ni* :play-soundfile "/home/nao/wav_test/munyamunya.wav"))
	 (if (= sound_decision 1)
	     (send *ni* :play-soundfile "/home/nao/wav_test/nemunemu.wav"))
	 (if (= sound_decision 2)
	     (send *ni* :play-soundfile "/home/nao/wav_test/harahetta.wav"))
	 (if (= sound_decision 3)
	     (send *ni* :play-soundfile "/home/nao/wav_test/himadanaa.wav"))
	 )
       )
     )
   )

;;"ていし"を受け取ったら学習を完了する
(defun head_touch()
  (let ((regist_stop_publish_msg nil))
    ;; 1:登録 1 -> 1 / 3:やり直し 3 -> 0
    ;; 1:buttonFront 2:buttonMiddle 3:buttonRear
    ;;(setq *register-check* button-pos)
    ;;(if (= *register-check* 3) 
    ;;	(setq *register-check* 0)
    ;;  )
    (setq regist_stop_publish_msg (instance std_msgs::string :init))
    ;;とりあえず、最初に認識した答えを登録する                    
    ;;変える必要があるかも                                        
    (send regist_stop_publish_publish_msg :data "ていし")
    (print (send regist_stop_publish_msg :data))
    (ros::publish "nao_regist_stop" regist_stop_publish_msg)
    )
  )

(defun conversation (japanese-char)
  (let ((publish-msg nil)
        (word-string nil))
    ;;ひらがなを一回だけ受け取る                                               
    ;;ひらがなをリストに追加する                                               
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
		    ;;ファイルを全部Naoに入れてここにも記入
                    (if (string= japanese-char "の")
                        (send *ni* :play-soundfile "/home/nao/wav_test/no.wav")
		      )
                    (if (string= japanese-char "り")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ri.wav")
		      )
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
		    
(defun face-detect-cb (msg)
  (let ((point 0) (pointX 0) (pointY 0)
	(current-pitch (send *nao* :head :neck-p :joint-angle))
	(current-yaw   (send *nao* :head :neck-y :joint-angle))
	(next-pitch 0) (next-yaw 0) (y-k 0.08) (p-k 0.05) (radius 100))
    (if (or (eq *current-behavior* :idle)
	    (eq *current-behavior* :eyecontact))
	(when (send msg :rects) 
	  (setq point (car (send msg :rects)))
	  (setq pointX (send point :x))
	  (setq pointY (send point :y))
	  (set-behavior :eyecontact)
	  (send *nao* :angle-vector (send *ni* :state :potentio-vector))
	  (setq current-pitch (send *nao* :head :neck-p :joint-angle))
	  (setq current-yaw   (send *nao* :head :neck-y :joint-angle))
	  
	  (if (> (+ (expt (- pointX 320) 2) (expt (- pointY 240) 2)) (expt radius 2))
	      (progn
		(if (> pointX 320)
		    (send *nao* :head :neck-y :joint-angle (- current-yaw (* y-k (- pointX 320))))
		  (send *nao* :head :neck-y :joint-angle (+ current-yaw (* y-k (- 320 pointX)))))
		(if (> pointY 240)
		    (send *nao* :head :neck-p :joint-angle (+ current-pitch (* p-k (- pointY 240))))
		  (send *nao* :head :neck-p :joint-angle (- current-pitch (* p-k (- 240 pointY)))))		
		(setq next-pitch (send *nao* :head :neck-p :joint-angle))
		(setq next-yaw   (send *nao* :head :neck-y :joint-angle))
		(let ((diff (max (abs (- next-pitch current-pitch))
				 (abs (- next-yaw current-yaw)))))
		  (let ((tm (/ diff 40.0)))
		    (send *ni* :angle-vector (send *nao* :angle-vector) (* 1000.0 tm))
		    (setq *idle-check-timeout* (* 2 tm))
		    )
		  )
		)
	    )
	  )
      )
    )
  )

(defun conversation-finished-cb (msg)
  (setq *conversation_finished* 1)
  )

;; (defun tactile-detect-cb (msg)
;;   (let ((head-set-value 10))
;;     (if (or (eq *current-behavior* :idle)
;; 	    (eq *current-behavior* :look-and-speak)
;; 	    (eq *current-behavior* :eyecontact)
;; 	    (eq *current-behavior* :talking))
;; 	(head_touch)
;;       )
;;     )
;;   )

(defun character-detect-cb (msg)
  (let ((japanese-char 0))
    (if (eq *current-behavior* :talking)
	;;読み取ったひらがなを返す
	(progn
	  (setq japanese-char (send msg :data))
	  ;;ひらがな発話   
	  (print japanese-char)
	  (conversation japanese-char)
	    
	  )
      )
    )
  )
;;subscribe topics
(ros::subscribe "/face_detector_mono/faces" face_detector_mono::RectArray #'face-detect-cb)
;;(ros::subscribe "/tactile_touch" nao_msgs::TactileTouch #'tactile-detect-cb)
(ros::subscribe "/nao_character_learn" std_msgs::String  #'character-detect-cb)
(ros::subscribe "/conversation_finished" std_msgs::String #'conversation-finished-cb)
;;多分使わない
;;(ros::subscribe "/" nao_msgs::Bumper #'bumper-touch-cb)

;;main loopを回す
(ros::ros-info "Let's start")
;;(ros::rate 5)
(while (ros::ok)
  (nao-servo-on)
  (send *nao* :angle-vector #f(108.808 13.6208 -90.0914 -38.1426 1.22808 109.252 -12.8346 90.1745 39.5537 -1.05711 -3.16169 -0.261268 -52.469 121.039 -67.9785 -0.524941 -3.16169 0.266077 -52.298 121.039 -67.97 -0.964409 0.349159 -2.02391))
  (send *ni* :angle-vector (send *nao* :angle-vector))

  (idle-check)
  (ros::spin-once)
  (ros::sleep)
)

