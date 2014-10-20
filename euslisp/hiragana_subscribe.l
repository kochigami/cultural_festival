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

(setq *start-position* #f(80.7701 11.1598 -46.4971 -59.764 7.46839 82.2691 -10.3736 45.965 59.5051 -6.94585 -14.3239 -4.48007 -39.6368 121.039 -67.9785 4.30665 -14.3239 4.48488 -39.9931 121.039 -67.97 -4.34702 0.788627 3.0738))


;;名前を聞いて                                                                                
(setq name_interview #f(82.0885 11.6872 -50.8917 -61.0823 6.32579 84.2027 -10.6373 50.0959 60.1203 -5.45169 -15.115 -4.74374 -40.4278 121.039 -67.9785 4.30665 -15.115 4.13332 -40.6963 121.039 -67.97 -4.34702 1.49175 2.45857))

(setq name_interview2 #f(82.0885 11.6872 -50.8917 -61.0823 6.32579 84.2027 -10.6373 50.0959 60.1203 -5.45169 -15.115 -4.74374 -40.4278 121.039 -67.9785 4.30665 -15.115 4.13332 -40.6963 121.039 -67.97 -4.34702 1.49175 2.45857))

;;好きなものを聞いて                                                                       
(setq favorite_interview #f(82.0885 11.6872 -50.8917 -61.0823 6.32579 84.2027 -10.6373 50.0959 60.1203 -5.45169 -15.115 -4.74374 -40.4278 121.039 -67.9785 4.30665 -15.115 4.13332 -40.6963 121.039 -67.97 -4.34702 1.49175 2.45857))

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
			   (send *ni* :angle-vector-sequence (list favorite_interview  *start-position*) (list 2000 3000))
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
			 (send *ni* :angle-vector-sequence (list name_interview name_interview2 *start-position*) (list 2500 3500 4500))
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