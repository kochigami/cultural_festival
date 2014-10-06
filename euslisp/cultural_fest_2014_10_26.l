#!/usr/bin/env roseus
;; jsk-ros-pkg/jsk_demos/interactive_behavior_201409のコードを見ながら書いています。
;;まだ途中...
(ros::load-ros-manifest "object_learn_using_sift")

(ros::roseus-add-msgs "face_detector_mono")
(ros::roseus-add-msgs "nao_msgs") ;;tactile

(require :nao-interface "/home/kochigami/ros/groovy/object_learn_using_sift/euslisp/nao-interface-kochigami.l")
(ros::roseus "interaction_behavior_by_nao")

(ros::advertise "nao-learn-word" std_msgs::string 1)

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

;; ---behaviors---
;; :idle -> :look-around
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
    ;;idleじゃないとき ある時間(*idle-check-timeout*)を過ぎたらidleになる
    (if (not (eq *current-behavior* :idle))
	(if (> (send (ros::time- now *behavior-start-time*) :to-sec) *idle-check-timeout*)
	    (setq *current-behavior* :idle)
	  )
      
    ;;idleのとき ある確率で:look-and-speakモードに移行する(キョロキョロしてお話)
      (if (= (random 25) 0) 
	  (set-behavior :look-and-speak)
	)
      )
    )
  )
;;behaviorをセットする関数
(defun set-behavior (behavior &rest args)
  (setq *current-behavior* behavior)
  (setq *behavior-start-time* (ros::time-now))
  (case behavior
    (:look-and-speak
     (looking_and_speaking)
     )
    (:eyecontact
     (apply #'looking_at_someone args) ;;argsはnaoが顔を向ける座標
     )
    (:talking         ;; :touch   →   :talking
     (apply #'conversation args) ;;args はひらがな
     )
    )
  )

(defun looking_and_speaking()
  ;;左右向く
  (let ((sound_decision (random 3))
	(neck_move_decision (random 2)))
    (when (= neck_move_decision 0)
	;;(send *nao* :)...
	;;(send *nao* :)...
	;;(send *ni* :angle-vector (send *nao* :angle-vector))
	)
    (when (= neck_move_decision 1)
	;;(send *nao* :)...
	;;(send *nao* :)...
	;;(send *ni* :angle-vector (send *nao* :angle-vector))
	)
    
  ;;ランダムにしゃべる "はらへったー" "むにゃむにゃ" "ひまだなあ"
    (setq sound_decision (random 3))
    (if (= sound_decision 0)
	(send *ni* :play-soundfile "/*nao directory*/munyamunya.wav"))
    (if (= sound_decision 1)
	(send *ni* :play-soundfile "/*nao directory*/harahetta.wav"))
    (if (= sound_decision 2)
	(send *ni* :play-soundfile "/*nao directory*/himadanaa.wav"))
    )
  )
  
(defun looking-at-someone(world-pos)
  (send *nao* :angle-vector (send *ni* :state :potentio-vector))
  (let ((current-pitch (send *nao* :head :neck-p :joint-angle))
	(current-yaw   (send *nao* :head :neck-y :joint-angle)))
    (send *nao* :head :look-at world-pos)
    (let ((next-pitch (send *nao* :head :neck-p :joint-angle))
	  (next-yaw   (send *nao* :head :neck-y :joint-angle)))
      (let ((diff (max (abs (- next-pitch current-pitch))
		       (abs (- next-yaw current-yaw)))))
	(let ((tm (/ diff 40.0)))
	  (send *ni* :angle-vector (send *nao* :angle-vector) (* 1000.0 tm))
	  (setq *idle-check-timeout* (* 2 tm))
	  ;;random 50%くらいで :eyecontact ->  :talkingに移動
	  (if (= (random 2) 0)
	      (set-behavior :talking)
	    )
	  )
	)
      )
    )
  )

(defun head_touch(button-pos)
  ;; 1:登録 1 -> 1 / 3:やり直し 3 -> 0
  ;; 1:buttonFront 2:buttonMiddle 3:buttonRear
  (setq *register-check* button-pos)
  (if (= *register-check* 3) 
      (setq *register-check* 0)
    )
  )

(defun conversation (japanese-char)
  (let ((publish-msg nil)
	(word-string nil))
    ;;ひらがなを一回だけ受け取る
    (if (= *register-check* 1)
	;;ひらがなをリストに追加する
	(setq *character-list* (append *character-list* (list japanese-char)))
      )
    (if (string= japanese-char 'おわり)
	;;"おわり"を受け取ったらrostopic pubする →  後で日記にする
	(progn
	  ;;リストの文字を全結合してstringにしたい
	  ;;(setq word-string **)
	  (setq *character-list* nil)
	  (setq publish-msg (instance std_msgs::string :init))
	  (send publish-msg :data word-string)
	  (ros::ros-info "sending message: [~A]" (send publish-msg :data))
	  (ros::publish "nao-learn-word" publish-msg)
	  )
      )      
    )
  )

(defun face-detect-cb (msg)
  (if (or (eq *current-behavior* :idle)
	  (eq *current-behavior* :look-and-speak)
	  (eq *current-behavior* :eyecontact))
      ;; msgからtfを取り出す ;;中身よく分からない
      (let ((cds (send *tfl* :lookup-transform "/base_footprint"
		       (send msg :header :frame_id)
		       (send msg :header :stamp))))
	(if cds 
	    (let ((world-pos (send cds :transform-vector (ros::tf-point->pos (send msg :pos)))))
	
      ;; 顔とnaoの距離が遠くなければ (set-behavior :eyecontact world-pos)して顔を動かす 
	      (let ((nao-human-distance (distance 
					 (float-vector (elt world-pos 0)
						       (elt world-pos 1)
						       0)
					 (float-vector 0 0 0))))
		(if (< nao-human-distance 1000.0)
		    (set-behavior :eyecontact world-pos)
		  )
		)
	      )
	  )
	)
    )
  )

(defun tactile-detect-cb (msg)
  (let ((head-set-value 10))
    (if (or (eq *current-behavior* :idle)
	    (eq *current-behavior* :look-and-speak)
	    (eq *current-behavior* :eyecontact)
	    (eq *current-behavior* :talking))
	(progn
	  (setq head-set-value (send msg :button))
	  (head_touch head-set-value)
	  )
      )
    )
  )

(defun character-detect-cb (msg)
  (let ((japanese-char 0))
    (if (eq *current-behavior* :talking)
	;;読み取ったひらがなを返す
	(progn
	  (setq japanese-char (send msg :data))
	  ;;ひらがな発話
	  (set-behavior :talking japanese-char)
	  )
      )
    )
  )
;;subscribe topics
(ros::subscribe "/face_detector_mono/faces" face_detector_mono::RectArray #'face-detect-cb)
;;(ros::subscribe "/" nao_msgs::TactileTouch #'tactile-detect-cb)
(ros::subscribe "/nao_character_learn" std_msgs::String  #'character-detect-cb)
;;(ros::subscribe "/" nao_msgs::Bumper #'bumper-touch-cb)


;;main loopを回す
(ros::ros-info "Let's start")
;;(ros::rate 5)
(while (ros::ok)
  (nao-servo-on)
  (idle-check)
  (ros::spin-once)
  (ros::sleep)
)

