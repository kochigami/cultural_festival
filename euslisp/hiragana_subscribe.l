#!/usr/bin/env roseus

(ros::load-ros-manifest "cultural_festival")
(ros::roseus "character_subscriber")
(ros::roseus-add-msgs "std_msgs")

(require :nao-interface "/home/kochigami/ros/groovy/cultural_festival/euslisp/nao-interface-kochigami.l")

(setq *nao* (nao))
(setq *ni* (instance nao-interface :init))
(setq *name_learn* 0)
(setq *name_data* nil)
(setq *favorite_data* nil)


(defclass making_newspaper_about_you_class
  :super propertied-object
  :slots (*name_data*, *favorite_data*))

(defmethod making_newspaper_about_you_class
  (:init ()
	 (ros::subscribe "nao_learn_word" std_msgs::string #'send self :character-cb)
	 )
    
  ;; character-cb -> name-cb -> picture-cb

  (:character-cb (msg)
		 ;;別に"り"じゃなくて、"登録おわり"的な写真を用意する	 
		 (if (string= (send msg :data) "おしまい")
		     (if (= *name_learn* 1)
			 (progn
			   (print '友達ができたよ。名前は)
			   (print *name_data*)
			   (print 'っていうんだよ。)
			   (print '好きなものは)
			   (print *favorite_data*)
			   (print 'だよ。よろしくね。)
			   (setq msg (instance std_msgs::string :init))
			   (setq msg2 (instance std_msgs::string :init))
			   (setq msg3 (instance std_msgs::string :init))
			   
			   (send msg :data "写真をとる")
			   (send msg2 :data *name_data*)
			   (send msg3 :data *favorite_data*)
			   (unix:sleep 1)
			   (if (= (random 2) 0)
			       (send *ni* :play-soundfile "/home/nao/wav_test/sounanda.wav")
			     (send *ni* :play-soundfile "/home/nao/wav_test/watashimo.wav")
			     )
			   (unix:sleep 1)
			   (send *ni* :play-soundfile "/home/nao/wav_test/syasinnwo_toruyo_hi_cheese.wav")
			   (send *ni* :play-soundfile "/home/nao/wav_test/kasya.wav")
			   (unix:sleep 6)
			   (ros::publish "/nao_friend_name" msg2)
			   (ros::publish "/nao_friend_favorite" msg3)
			   (ros::publish "/nao_taking_picture_permission" msg)
			   (ros::ros-info "take a photo")
			   (setq *name_data* nil)
			   (setq *favorite_data* nil)
			   (setq *name_learn* 0)
			   )
		       (progn
			 (setq *name_learn* (+ *name_learn* 1))
			 ;;ちょっと待つ
			 (unix:sleep 1)
			 (if (= (random 2) 0)
			     (send *ni* :play-soundfile "/home/nao/wav_test/yorosikune.wav")
			   (send *ni* :play-soundfile "/home/nao/wav_test/sutekinanamae.wav")
			   )
			 (unix:sleep 2)
			 (send *ni* :play-soundfile "/home/nao/wav_test/sukinamonoha_naani.wav")
			 )
		       )
		   (progn
		     (if (= *name_learn* 0)
			 ;;added
			 (setq *name_data* (concatenate string *name_data* (send msg :data)))  
		       )
		     (if (= *name_learn* 1)
			 ;;added
			 (setq *favorite_data* (concatenate string *favorite_data* (send msg :data)))
		       )
		     )
		   )
		 )
  )

(setq m (instance making_newspaper_about_you_class :init))

(ros::advertise "/nao_taking_picture_permission" std_msgs::string 1)
(ros::advertise "/nao_friend_name" std_msgs::string 1)
(ros::advertise "/nao_friend_favorite" std_msgs::string 1)

(ros::ros-info "start subscribing")
(while (ros::ok)
  (ros::spin-once)
  )