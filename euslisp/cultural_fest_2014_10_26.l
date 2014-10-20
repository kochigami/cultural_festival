#!/usr/bin/env roseus
;; jsk-ros-pkg/jsk_demos/interactive_behavior_201409のコードを見ながら書いています。
(ros::load-ros-manifest "cultural_festival")

(ros::roseus-add-msgs "face_detector_mono")
(ros::roseus-add-msgs "nao_msgs") 
(ros::roseus-add-msgs "std_msgs")

(require :nao-interface "/home/kochigami/ros/groovy/cultural_festival/euslisp/nao-interface-kochigami.l")
(ros::roseus "interaction_behavior_by_nao")

(ros::advertise "nao_learn_word" std_msgs::string 1)
(ros::advertise "nao_diary_angry" std_msgs::string 1)
;;(ros::advertise "nao_regist_stop" std_msgs::string 1)

(setq *start-position* #f(80.7701 11.1598 -46.4971 -59.764 7.46839 82.2691 -10.3736 45.965 59.5051 -6.94585 -14.3239 -4.48007 -39.6368 121.039 -67.9785 4.30665 -14.3239 4.48488 -39.9931 121.039 -67.97 -4.34702 0.788627 3.0738))

;;なでなでして ;;ながい
(setq first #f(43.7677 7.46839 -51.7706 -62.3128 -11.3404 84.2027 -10.3736 46.5802 60.8235 -6.85796 -14.4997 -4.2164 -37.3516 121.039 -67.9785 4.30665 -14.4997 3.69386 -37.3564 121.039 -67.97 -4.34702 0.788627 3.0738))

(setq second #f(16.6091 7.29261 -67.9427 -62.4007 -16.2624 84.1148 -10.3736 46.6681 60.8235 -6.85796 -14.4118 -4.2164 -37.7031 121.039 -67.9785 4.30665 -14.4118 3.69386 -37.6201 121.039 -67.97 -4.34702 0.788627 3.0738))

(setq third #f(-13.5377 0.085487 -48.7823 -62.0492 -77.6108 84.1148 -10.4615 47.4591 60.8235 -6.77007 -14.4118 -4.2164 -39.2852 121.039 -67.9785 4.30665 -14.4118 3.69386 -39.4658 121.039 -67.97 -4.34702 0.788627 3.0738))

(setq eighth #f(-30.2372 2.107 74.0903 -56.9514 -76.0287 84.6421 -10.9889 48.6017 60.2961 -6.59429 -14.7634 -5.09532 -46.3165 121.039 -67.9785 4.30665 -14.7634 4.13332 -46.585 121.039 -67.97 -4.34702 0.788627 3.0738))

(setq ninth #f(-50.8038 2.81013 74.0903 -55.8967 -76.1166 84.6421 -10.901 48.5138 60.2961 -6.59429 -14.7634 -5.00743 -46.3165 121.039 -67.9785 4.30665 -14.7634 4.04543 -46.4971 121.039 -67.97 -4.34702 0.788627 3.0738))

(setq tenth #f(-20.1296 4.12851 -47.8155 -62.8402 -73.3041 86.3121 -11.2525 48.1623 60.9993 -5.62747 -14.6755 -4.48007 -43.2403 121.039 -67.9785 4.22121 -14.6755 3.95753 -43.333 121.039 -67.97 -4.34702 0.788627 3.0738))

;;もういいよ　ありがとう ;;                                                                  
(setq stop-pose #f(2.28279 8.69887 -60.0324 -61.6097 -27.2488 1.76024 -4.39699 56.7756 63.1965 15.6423 -14.7634 -4.65585 -41.8341 121.039 -67.9785 4.3091 -14.7634 4.04543 -41.8389 121.039 -67.97 -4.34702 1.14019 4.30429))

(setq stop-pose2 #f(5.2711 8.69887 -60.2082 -61.6097 -27.2488 4.66066 -4.3091 57.6546 63.1965 15.6423 -14.8513 -4.48007 -40.9551 121.039 -67.9785 4.3091 -14.8513 3.95753 -40.9599 121.039 -67.97 -4.34702 0.173378 11.863))

;;もっとなでなでして ;;
(setq motto #f(22.1463 -3.43018 -66.0091 -61.2581 4.74374 91.8493 9.31412 57.4788 64.1634 -48.0792 -14.8513 -4.74374 -42.0098 121.039 -67.9785 4.30665 -14.8513 3.95753 -42.1904 121.039 -67.97 -4.34702 -14.0651 4.30429))

(setq motto2 #f(38.9336 -2.81494 -62.4934 -60.7308 18.1912 91.4977 9.40201 57.4788 64.1634 -48.0792 -14.8513 -4.74374 -42.6251 121.039 -67.9785 4.30665 -14.8513 3.95753 -42.9815 121.039 -67.97 -4.34702 17.3123 4.30429))

(setq motto3 #f(18.7185 -3.43018 -69.5248 -60.9944 16.7849 91.4977 9.40201 57.4788 64.0755 -48.0792 -14.8513 -4.74374 -42.6251 121.039 -67.9785 4.30665 -14.8513 3.95753 -42.9815 121.039 -67.97 -4.34702 0.173378 4.30429))

;;なでてよー  ;;                                                                             
(setq nadeteyo #f(49.5685 10.5446 -74.2709 -61.5218 -73.4799 51.8585 -10.1978 79.9791 62.4055 93.1628 -14.9392 -4.65585 -40.6915 121.039 -67.9785 4.30665 -14.9392 3.95753 -40.8721 121.039 -67.97 -4.34702 -1.40867 -14.2409))

;;ありがとう                                                                               
(setq arigatou #f(74.4419 4.91954 -47.8155 -61.4339 15.0271 76.5561 -0.529749 55.8088 60.7356 -7.20952 -2.45857 -6.06212 -69.9594 121.039 -67.9785 4.30665 -2.45857 5.27591 -70.2279 121.039 -67.97 -4.34702 0.964409 3.86484))

(setq arigatou2 #f(85.4284 5.2711 -47.7276 -61.346 15.0271 92.7282 -0.266077 55.8088 60.7356 -7.20952 0.090295 -5.97423 -45.965 121.039 -67.9785 4.30665 0.090295 5.3638 -45.8819 121.039 -67.97 -4.34702 0.876518 3.86484))

;;もういいってば！         ;;たおれる                                                         
(setq mouiitteba #f(-16.7897 -2.1997 -30.1493 -13.8845 -2.81494 69.2611 -10.6373 48.2502 60.5598 -7.12163 -22.41 -7.99575 -61.5218 121.039 -67.9785 2.81494 -22.41 6.77007 -62.3176 121.039 -67.97 -3.24959 0.876518 3.86484))

(setq mouiitteba2 #f(54.2268 0.085487 -31.9071 -13.8845 -3.51807 78.5776 -10.5494 48.2502 60.6477 -7.12163 -13.6208 -6.4137 -56.0725 121.039 -67.9785 4.30665 -13.6208 7.29742 -56.7805 121.039 -67.97 -4.34702 0.876518 3.86484))

;;ナオ君のこと知りたいな                                                                   
(setq siritaina #f(17.3123 -4.74855 -40.2568 -62.4007 -63.2844 50.3644 7.20472 45.4376 61.9661 29.9687 -14.8513 -5.71056 -49.6564 121.039 -67.9785 4.30665 -14.8513 4.57277 -49.837 121.039 -67.97 -4.34702 1.66754 8.4352))

(setq siritaina2 #f(46.6681 0.876518 -47.9913 -61.0823 -47.1124 51.2433 6.2379 49.8322 62.1419 29.705 -15.0271 -5.71056 -49.4806 121.039 -67.9785 4.29809 -15.0271 4.57277 -49.7491 121.039 -67.97 -4.34702 1.66754 -0.266077))

;;ナオと遊んだこと忘れないでね                                                             
(setq wasurenaide #f(37.5274 -15.4713 -38.2353 -62.2249 -44.0362 86.2242 -10.3736 48.2502 60.0324 -6.68218 -14.4997 -4.65585 -39.9883 121.039 -67.9785 4.30665 -14.4997 3.95753 -40.5205 121.039 -67.97 -4.34702 0.964409 3.86484))

(setq wasurenaide2 #f(37.8789 -16.1745 -41.3994 -62.5765 -96.2438 86.2242 -10.4615 48.1623 59.9446 -6.68218 -14.4997 -4.65585 -40.8672 121.039 -67.9785 4.29809 -14.4997 4.04543 -41.3994 121.039 -67.97 -4.34702 0.964409 11.9509))

(setq wasurenaide3 #f(56.5999 -17.2292 -22.6785 -62.7523 -93.4313 86.2242 -10.4615 48.1623 59.9446 -6.59429 -14.4997 -4.74374 -41.1309 121.039 -67.9785 4.30665 -14.4997 4.04543 -41.5752 121.039 -67.97 -4.34702 1.57965 16.8728))

;;じゃあね                                                                                 
(setq jyaane #f(18.367 8.52309 -70.8431 -63.5433 57.6546 88.2457 -11.4283 48.1623 59.9446 -6.59429 -14.3239 -4.12851 -36.8242 121.039 -67.9785 4.30665 -14.3239 3.1665 -37.0927 121.039 -67.97 -4.34702 1.40386 5.62267))

(setq jyaane2 #f(19.8611 9.40201 -96.947 -62.5765 59.5003 88.2457 -11.4283 48.1623 59.9446 -6.68218 -14.4118 -4.12851 -37.0 121.039 -67.9785 4.29809 -14.4118 3.1665 -37.4443 121.039 -67.97 -4.34702 1.49175 5.62267))

(setq jyaane3 #f(20.1248 8.4352 -68.7337 -64.5101 59.8519 88.2457 -11.4283 48.1623 60.0324 -6.68218 -14.4118 -4.12851 -36.9121 121.039 -67.9785 4.29809 -14.4118 3.1665 -37.0927 121.039 -67.97 -4.34702 1.49175 5.62267))

(setq jyaane4 #f(22.6737 10.3688 -108.109 -64.0707 58.6214 88.2457 -11.4283 48.1623 59.9446 -6.59429 -14.4118 -4.12851 -36.8242 121.039 -67.9785 4.30665 -14.4118 3.1665 -37.2685 121.039 -67.97 -4.34702 1.49175 5.62267))

(setq jyaane5 #f(79.3638 10.9841 -48.7823 -60.9944 8.25942 84.2027 -12.2194 55.0178 60.1203 -6.59429 -14.1482 -6.2379 -54.4905 121.039 -67.9785 4.22121 -14.1482 5.27591 -54.8469 121.039 -67.97 -4.34702 1.40386 5.62267))

;;はらへった                                                                               
(setq harahetta #f(71.102 0.085487 -32.1708 -34.1875 11.072 97.6501 -0.705531 69.7836 60.0324 -6.85796 -15.906 -2.72224 -30.0566 121.039 -67.9785 4.29809 -15.906 2.11181 -30.1493 121.039 -67.97 -4.34702 1.31597 5.62267))

(setq harahetta2 #f(59.2366 -16.1745 -31.7313 -78.6607 -16.6139 104.594 -1.58445 77.7818 60.0324 -6.41851 -14.3239 -1.93121 -24.3436 121.039 -67.9785 4.30665 -14.3239 0.793436 -24.1726 121.039 -67.97 -4.34702 1.14019 21.9705))

(setq harahetta3 #f(71.7172 -3.78175 -25.2273 -32.3418 -13.7135 106.527 -1.58445 77.8697 59.9446 -6.5064 -12.9177 -1.93121 -23.4647 121.039 -67.9785 4.29809 -12.9177 0.793436 -23.3816 121.039 -67.97 -4.34702 1.14019 21.9705))

(setq harahetta4 #f(66.0922 -3.51807 -32.6981 -32.7812 -13.7135 88.9488 4.39218 65.9164 58.8899 -6.41851 -13.2692 -4.39218 -42.1856 121.039 -67.9785 4.29809 -13.2692 3.25439 -42.4541 121.039 -67.97 -4.34702 1.22808 21.9705))

;;ねむねむ                                                                                 
(setq nemunemu #f(102.479 30.8476 -47.6397 -59.2366 -38.7627 117.514 -29.8856 47.1955 63.7239 -6.06693 -7.73207 -3.68905 -32.5175 121.039 -67.9785 4.29809 -7.73207 3.1665 -32.4345 121.039 -67.97 -4.34702 1.14019 5.44688))

(setq nemunemu2 #f(70.1352 5.35899 -24.9637 -59.3245 -38.7627 85.6968 0.876518 47.0197 63.7239 -6.15482 -8.78677 -5.09532 -48.9533 121.039 -67.9785 4.29809 -8.78677 4.13332 -49.046 121.039 -67.97 -4.34702 1.22808 5.44688))

;;むにゃむにゃ                                                                             
(setq munyamunya #f(78.4849 11.5993 -53.88 -59.5003 4.65585 22.8543 -12.2194 43.8556 88.4991 74.7935 -15.8181 -6.06212 -56.1604 121.039 -67.9785 3.69386 -15.8181 5.27591 -56.5168 121.039 -67.97 -4.12851 -23.8211 2.45857))

(setq munyamunya2 #f(76.1997 11.5993 -55.1105 -59.4124 4.56796 26.8094 -12.9225 64.598 88.4991 72.0688 -16.697 -6.58948 -59.0608 121.039 -67.9785 3.60597 -16.697 5.27591 -59.4172 121.039 -67.97 -3.68905 -22.239 -7.29742))

(setq munyamunya3 #f(82.7916 11.5114 -58.7141 -59.0608 4.48007 34.456 -13.8014 17.3123 88.4991 18.8064 -16.1697 -5.88634 -46.3165 121.039 -67.9785 4.30665 -16.1697 4.66066 -46.3213 121.039 -67.97 -4.34702 -22.239 -7.29742))

(setq munyamunya4 #f(86.8346 11.5114 -58.802 -59.0608 -1.145 83.3238 -12.7467 37.3516 66.888 -34.7196 -16.1697 -4.83163 -42.6251 121.039 -67.9785 4.30665 -16.1697 3.95753 -42.8936 121.039 -67.97 -4.34702 -1.84813 -7.29742))

;;なおだよ                                                                                 
(setq naodayo #f(0.085487 4.74374 -95.6286 -60.2034 75.4087 87.6305 -13.0983 48.7775 60.5598 -13.4498 -14.3239 -4.91954 -39.9004 121.039 -67.9785 4.30665 -14.3239 4.22121 -40.2568 121.039 -67.97 -4.34702 1.57965 -1.76024))

(setq naodayo2 #f(1.40386 2.54646 -95.6286 -60.2034 75.145 87.6305 -13.1862 48.7775 60.5598 -13.4498 -14.2361 -4.83163 -41.2188 121.039 -67.9785 4.30665 -14.2361 4.13332 -41.3994 121.039 -67.97 -4.34702 16.697 -1.76024))

(setq naodayo3 #f(94.5691 1.84332 -95.6286 -59.5882 75.145 87.6305 -13.1862 48.7775 60.5598 -13.4498 -14.3239 -4.83163 -41.2188 121.039 -67.9785 4.29809 -14.3239 4.22121 -41.5752 121.039 -67.97 -4.34702 16.697 -1.76024))

(setq naodayo4 #f(94.5691 1.84332 -95.6286 -59.5882 75.145 -17.2244 -13.8893 85.692 62.7571 -13.0983 -14.2361 -4.83163 -41.8341 121.039 -67.9785 4.29809 -14.2361 4.22121 -42.1025 121.039 -67.97 -4.34702 -12.483 -1.76024))

(setq naodayo5 #f(94.5691 1.84332 -95.6286 -59.5882 75.145 97.6501 -12.8346 78.8365 60.8235 -12.1315 -14.4118 -4.83163 -41.922 121.039 -67.9785 4.30665 -14.4118 4.22121 -42.3662 121.039 -67.97 -4.34702 -12.483 -1.76024))

;;okマークを見せて
(setq ok #f(10.6325 14.4997 -75.9409 -60.1155 26.8925 84.9058 -13.7135 48.1623 59.3293 -7.82477 -14.4997 -4.74374 -39.7247 121.039 -67.9785 4.30665 -14.4997 4.22121 -39.9931 121.039 -67.97 -4.34702 -0.002404 0.612832))

;;おしまいマークを見せて                                                             
(setq osimai #f(83.0553 13.0056 -48.3428 -59.6761 8.25942 -18.5427 -14.944 67.1469 61.1751 -21.9753 -14.4997 -4.74374 -39.461 121.039 -67.9785 4.29809 -14.4997 4.13332 -39.5537 121.039 -67.97 -4.34702 0.261268 0.612832))



;;initialization
;;for nao initialization
(ros::ros-info "nao initializing")
(setq *nao* (nao))
(setq *ni* (instance nao-interface :init))
(objects (list *nao*))
;; for idle-check
(setq *current-behavior* :idle)
(setq *behavior-start-time* (ros::time-now))
(setq *idle-check-timeout* 0)
(setq *conversation_finished* 0)
(setq *nao_asking_accomplished* 0)
(setq *bumper_touched* 0)
(setq *head_touch_count_pre* 0)
(setq *nao_touch_pattern* 12)
(setq *speak_num1* 0)
(setq *speak_num2* 0)
(setq *speak_num3* 0)
(setq *speak_num4* 0)
(setq *speak_num5* 0)
(setq *speak_num6* 0)
;; for conversation
(setq *character-list* nil)
(setq *call_num* 0)
(setq *pub_num* 0)
(setq *pre-japanese-char* "っ")
;;(setq *register-check* 10)
(setq *launchpad-input* 0)
;; for tactile-detect-cb
(setq *head_touch_count* 0) 

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
  (let ((now (ros::time-now))
	(nao-angry-msg nil))
    ;;idleじゃないとき ある時間(*idle-check-timeout*)を過ぎたらidleになる
    ;;added 
    (if (= *bumper_touched* 1)
	(progn
	  ;;(send *ni* :play-soundfile "/home/nao/wav_test/ok.wav")
	  (setq *nao_touch_pattern* 12)
	  (setq *speak_num1* 0)
	  (setq *speak_num2* 0)
	  (setq *speak_num3* 0)
	  (setq *speak_num4* 0)
	  (setq *speak_num5* 0)
	  (setq *speak_num6* 0)
	  (setq *head_touch_count* 0)
	  (setq *head_touch_count_pre* 0)
	  (set-behavior :asking)
	  (setq *bumper_touched* 0)
	  )
      )
    ;;added end
    (if (eq *current-behavior* :eyecontact)
	(if (> (send (ros::time- now *behavior-start-time*) :to-sec) *idle-check-timeout*)
	    (progn
	      (if (= (random 2) 0) 
		  (progn
		    ;;added 
		    ;;(set-behavior :talking)
		    (set-behavior :asking)
		    ;;added end
		    )
		(progn
		  (setq *current-behavior* :idle)
		  )
		)
	      )
	  
      ;;idleのとき ある確率で:look-and-speakモードに移行する(キョロキョロしてお話)
	  )
      (progn
	;;added
	(if (eq *current-behavior* :asking)
	    (progn
	      ;;ナオのことを助けてあげたら:talkingに移行
	      ;;なでなでして
	      (if (= *speak_num1* 0)
		  (progn
		    (send *ni* :play-soundfile "/home/nao/wav_test/neenee_nadenadesite.wav")
		    (setq *speak_num1* (+ *speak_num1* 1))
		    ;;added
		    ;;なでなでして                                                            
		    (send *ni* :angle-vector-sequence (list first second third *start-position*) (list 2500 3500 4500 5700))
		    ;;(send *ni* :wait-interpolation)
		    ;;added end
		    )
		)
	      (when (> (send (ros::time- now *behavior-start-time*) :to-sec) 10)
		(if (= *nao_touch_pattern* 12)
		    (if (> *head_touch_count* 5)
			(progn 
			  ;;もういいよ　ありがとう
			  (if (= *speak_num2* 0)
			      (progn
				(send *ni* :play-soundfile "/home/nao/wav_test/mouiiyo_arigatou.wav")
				(setq *speak_num2* (+ *speak_num2* 1))
				;;added
				(send *ni* :angle-vector-sequence (list stop-pose stop-pose2 *start-position*) (list 2500 3500 4500))
				;;(send *ni* :wait-interpolation)
				;;added end
				)
			    )
			  (setq *head_touch_count_pre* *head_touch_count*)
			  (setq *nao_touch_pattern* 0) 
			  )
		      (progn
			;;もっとなでなでして
			(if (= *speak_num3* 0)
			    (if (= *head_touch_count* 0)
				(progn
				  ;;なでてよー
				  (send *ni* :play-soundfile "/home/nao/wav_test/mou_nadeteyo.wav")
				  (setq *speak_num3* (+ *speak_num3* 1))
				  ;;added
				  (send *ni* :go-pos 0.05 0 0)
				  (send *ni* :go-pos -0.05 0 0)
				  (send *ni* :go-pos 0.05 0 0)
				  (send *ni* :go-pos -0.05 0 0)
				  (send *ni* :angle-vector-sequence (list nadeteyo *start-position*) (list 3000 4000))
				  ;;(send *ni* :wait-interpolation)
				  ;;added end
				  (setq *head_touch_count_pre* *head_touch_count*)
				  (setq *nao_touch_pattern* 3)
				  )
			      (progn
				(send *ni* :play-soundfile "/home/nao/wav_test/motto_nadenadesite.wav")
				(setq *speak_num3* (+ *speak_num3* 1))
				;;added 
				(send *ni* :angle-vector-sequence (list motto motto2 motto3 *start-position*) (list 1500 2000 2500 3000))
				;;(send *ni* :wait-interpolation)
				;;added end
				(setq *head_touch_count_pre* *head_touch_count*)
				(setq *nao_touch_pattern* 1)
				)
			      )
			  )
			)
		      )
		  )
		)
	      (when (> (send (ros::time- now *behavior-start-time*) :to-sec) 15)
		(if (or (and (> (- *head_touch_count* *head_touch_count_pre*) 0) (= *nao_touch_pattern* 1))
			(and (< (- *head_touch_count* *head_touch_count_pre*) 5) (= *nao_touch_pattern* 0))
			(and (> (- *head_touch_count*  *head_touch_count_pre*) 0) (= *nao_touch_pattern* 3)))
		    (progn
		      ;;ありがとう
		      (if (= *speak_num4* 0)
			  (progn
			    (send *ni* :play-soundfile "/home/nao/wav_test/arigatou_tasukatta.wav")
			    (setq *speak_num4* (+ *speak_num4* 1))
			    ;;added
			    (send *ni* :angle-vector-sequence (list arigatou arigatou2 *start-position*) (list 2000 3000 4000))
			    (send *ni* :wait-interpolation)
			    ;;added end
			    )
			)
		      (set-behavior :talking)
		      )
		  (progn
		    (if (and (= (- *head_touch_count* *head_touch_count_pre*) 0) (or (= *nao_touch_pattern* 1) (= *nao_touch_pattern* 3)))
			(progn
			  ;;もういいってば！
			  (if (= *speak_num5* 0)
			      (progn
				(send *ni* :play-soundfile "/home/nao/wav_test/mouiitteba.wav")
				(send *ni* :play-soundfile "/home/nao/wav_test/nao_ijikeccyatta.wav")
				(setq *speak_num5* (+ *speak_num5* 1))
				;;added
				(send *ni* :angle-vector-sequence (list mouiitteba2 *start-position*) (list 2000  3000))
				(send *ni* :wait-interpolation)
				;;added end
				)
			    )	      
			  (setq nao-angry-msg (instance std_msgs::string :init))                                     
			  (send nao-angry-msg :data "なでてくれなかった")
			  (ros::publish "nao_diary_angry" nao-angry-msg)
			  (set-behavior :idle)
			  )
		      )
		    (if (and (> (- *head_touch_count*  *head_touch_count_pre*) 5) (= *nao_touch_pattern* 0))
			(progn
			  (if (= *speak_num6* 0)
			      (progn
				(send *ni* :play-soundfile "/home/nao/wav_test/mouiitteba.wav")
				(send *ni* :play-soundfile "/home/nao/wav_test/nao_ijikeccyatta.wav")
				(setq *speak_num6* (+ *speak_num6* 1))
				)
			    )	      
			  (setq nao-angry-msg (instance std_msgs::string :init))                                     
			  (send nao-angry-msg :data "なおおこ")
			  (ros::publish "nao_diary_angry" nao-angry-msg)
			  (set-behavior :idle)
			  )
		      )
		    )		
		  )
		)
	      )
	  )
	
	
	  
	  
      
	;;added end
	(if (eq *current-behavior* :idle)
	    (progn
	      ;;(print "idle now")
	      (if (= (random 50) 0)
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
		  (send *ni* :play-soundfile "/home/nao/wav_test/nao_to_asondakoto_wasurenaidene.wav")
		  ;;added 
		  ;;(send *ni* :angle-vector-sequence (list wasurenaide wasurenaide2 wasurenaide3 *start-position*) (list 1000 1500 2000 4500))
		  ;;added end
		  (unix:sleep 2)
		  (send *ni* :play-soundfile "/home/nao/wav_test/jyaane.wav")
		  ;;added 
		  (send *ni* :angle-vector-sequence (list jyaane jyaane2 jyaane3 jyaane4 jyaane5 *start-position*) (list 2000 2200 2400 2600 2800 4000))
		  ;;added end
		  (unix:sleep 7)
		  )
	      )
	    )
	  )
	)
      )
  )
)

;;ナオdisabledの座った姿勢
;;#f(80.7701 11.1598 -46.4971 -59.764 7.46839 82.2691 -10.3736 45.965 59.5051 -6.94585 -14.3239 -4.48007 -39.6368 121.039 -67.9785 4.30665 -14.3239 4.48488 -39.9931 121.039 -67.97 -4.34702 0.788627 3.0738)


;;behaviorをセットする関数
(defun set-behavior (behavior &rest args)
  (let ((rand_num 0))
    (setq *current-behavior* behavior)
    (setq *behavior-start-time* (ros::time-now))
    (print *current-behavior*)
    
    (if (eq *current-behavior* :talking)
	(progn
	  ;;ナオにカードを持たせて、身振りで説明してもらおう
	  (send *ni* :play-soundfile "/home/nao/wav_test/konnichiwa.wav")
	  (send *ni* :play-soundfile "/home/nao/wav_test/nao_korekara_situmon_surune.wav")
	  ;;added
	  (send *ni* :angle-vector-sequence (list siritaina siritaina2 *start-position*) (list 3000 4000 5000))
	  ;;added end 
	  (send *ni* :play-soundfile "/home/nao/wav_test/nao_kimi_no_koto_siritaino.wav")
	  (send *ni* :play-soundfile "/home/nao/wav_test/naokaraonegai.wav")
	  (unix:sleep 1)
	  (send *ni* :play-soundfile "/home/nao/wav_test/onegai.wav")
	  ;;okマークを見せて                                                                 
	  (send *ni* :angle-vector-sequence (list ok *start-position*) (list 1000 5000))

	  (unix:sleep 1)
	  (send *ni* :play-soundfile "/home/nao/wav_test/onegai2.wav")
	  (send *ni* :angle-vector-sequence (list osimai *start-position*) (list 1000 3000))
	  (unix:sleep 2)
	  (send *ni* :play-soundfile "/home/nao/wav_test/jyaaikuyo.wav")
	  (setq rand_num (random 3))
	  (if (= rand_num 0)
	      (send *ni* :play-soundfile "/home/nao/wav_test/onamaeha.wav")
	    )
	  (if (= rand_num 1)
	      (send *ni* :play-soundfile "/home/nao/wav_test/namaehananteiuno.wav")
	    )
	  (if (= rand_num  2)
	      (send *ni* :play-soundfile "/home/nao/wav_test/nanteiunamae.wav")
	    )
	  )
      )
    )
  )

(defun looking_and_speaking()
   ;;左右向く
   (let ((sound_decision (random 4))
	 (neck_move_decision (random 2)))
     (if (= (random 2) 0)
	 (progn
	   (send *nao* :angle-vector (send *ni* :state :potentio-vector))
	   (when (= neck_move_decision 0)
	     (send *nao* :head :neck-y :joint-angle 20)
	     (send *ni* :angle-vector (send *nao* :angle-vector))
	     (send *ni* :wait-interpolation)
	     )
	   (when (= neck_move_decision 1)
	     (send *nao* :head :neck-y :joint-angle -20)
	     (send *ni* :angle-vector (send *nao* :angle-vector))
	     (send *ni* :wait-interpolation)
	     )
	   ;;ランダムにしゃべる "むにゃむにゃ" "ねむねむ" "はらへった" "なおだよ"	   
	   (if (= sound_decision 0)
	       (progn
		 (send *ni* :play-soundfile "/home/nao/wav_test/munyamunya.wav")
		 (send *ni* :angle-vector-sequence (list munyamunya munyamunya2 munyamunya3 munyamunya4 *start-position*) (list 1000 2000 3000 4000 5000))
		 )
	     )
	   (if (= sound_decision 1)
	       (progn
		 (send *ni* :play-soundfile "/home/nao/wav_test/nemunemu.wav")
		 (send *ni* :angle-vector-sequence (list nemunemu nemunemu2 *start-position*) (list 1000 3200 4200))
		 )
	     )
	   (if (= sound_decision 2)
	       (progn
		 (send *ni* :play-soundfile "/home/nao/wav_test/harahetta.wav")
		 (send *ni* :angle-vector-sequence (list harahetta harahetta2 harahetta3 harahetta4 *start-position*) (list 1000 1200 2200 2400 2800))
		 )
	     )
	   (if (= sound_decision 3)
	       (progn
		 (send *ni* :play-soundfile "/home/nao/wav_test/naodayo.wav")
		 (send *ni* :angle-vector-sequence (list naodayo naodayo2 naodayo3 naodayo4 naodayo5 *start-position*) (list 1000 2000 3000 4000 5000 6000))
		 )
	     )
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
  (let ((publish-msg nil))
    ;;ひらがなを一回だけ受け取る                                              
    ;;ひらがなをリストに追加する                                              
    (if (string= japanese-char "おわり")
	(progn
	  (setq *pub_num* (+ *pub_num* 1))
	  ;;"おわり"を1つ受け取ったら1度だけrostopic pubする  
	  (if (= *pub_num* 1)
	      (progn
		(setq publish-msg (instance std_msgs::string :init))
		;;とりあえず、最初に認識した答えを登録する                   
		;;変える必要があるかも                                       
		(send publish-msg :data (elt *character-list* 0))
		(ros::publish "nao_learn_word" publish-msg)
		(setq *character-list* nil)
		(send *ni* :play-soundfile "/home/nao/wav_test/ok.wav")
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
                (string= japanese-char "ていし") (string= japanese-char "おしまい")
                )
            (progn	      
	      ;;launchpadからの入力であればリストの最初に代入 (入力の修正用として作用)
	      (if (= *launchpad-input* 1)
		  (progn
		    (setf (elt *character-list* 0)  japanese-char)	  
		    (setq *launchpad-input* 0)
		    )
		)
	      ;;文字を一つずつ代入
              (setq *character-list* (append *character-list* (list japanese-char)))
	      ;;文字が前のと異なったら１回だけしゃべる
              (if (not (string= *pre-japanese-char* japanese-char))
                  (progn
                    (setq *call_num* 0)
                    )
                )
	      
	      ;;added if name is nao, nao publishes topic
	      (if (and (string= *pre-japanese-char* "な") (string= japanese-char "お"))
		  (progn
		    
		    )
		  )
	      ;;added
              (if (= *call_num* 0)
                  (progn
		    ;;ファイルを全部Naoに入れてここにも記入
                    (if (string= japanese-char "あ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/a.wav")
		      )
                    (if (string= japanese-char "い")
                        (send *ni* :play-soundfile "/home/nao/wav_test/i.wav")
		      )
                    (if (string= japanese-char "う")
                        (send *ni* :play-soundfile "/home/nao/wav_test/u.wav"))
		    (if (string= japanese-char "え")
                        (send *ni* :play-soundfile "/home/nao/wav_test/e.wav")
		      )
                    (if (string= japanese-char "お")
                        (send *ni* :play-soundfile "/home/nao/wav_test/o.wav")
		      )
                    (if (string= japanese-char "か")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ka.wav"))
		    (if (string= japanese-char "き")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ki.wav")
		      )
                    (if (string= japanese-char "く")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ku.wav")
		      )
                    (if (string= japanese-char "け")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ke.wav"))
		    (if (string= japanese-char "こ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ko.wav")
		      )
                    (if (string= japanese-char "さ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/sa.wav")
		      )
                    (if (string= japanese-char "し")
                        (send *ni* :play-soundfile "/home/nao/wav_test/si.wav"))
		    (if (string= japanese-char "す")
                        (send *ni* :play-soundfile "/home/nao/wav_test/su.wav")
		      )
                    (if (string= japanese-char "せ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/se.wav")
		      )
                    (if (string= japanese-char "そ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/so.wav"))
		    (if (string= japanese-char "た")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ta.wav")
		      )
                    (if (string= japanese-char "ち")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ti.wav")
		      )
                    (if (string= japanese-char "つ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/tu.wav"))
		    (if (string= japanese-char "て")
                        (send *ni* :play-soundfile "/home/nao/wav_test/te.wav")
		      )
                    (if (string= japanese-char "と")
                        (send *ni* :play-soundfile "/home/nao/wav_test/to.wav")
		      )
                    (if (string= japanese-char "な")
                        (send *ni* :play-soundfile "/home/nao/wav_test/na.wav"))
		    (if (string= japanese-char "に")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ni.wav")
		      )
                    (if (string= japanese-char "ぬ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/nu.wav")
		      )
                    (if (string= japanese-char "ね")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ne.wav"))
		    (if (string= japanese-char "の")
                        (send *ni* :play-soundfile "/home/nao/wav_test/no.wav")
		      )
                    (if (string= japanese-char "は")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ha.wav")
		      )
                    (if (string= japanese-char "ひ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/hi.wav"))
		    (if (string= japanese-char "ふ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/hu.wav")
		      )
                    (if (string= japanese-char "へ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/he.wav")
		      )
                    (if (string= japanese-char "ほ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ho.wav"))
		    (if (string= japanese-char "ま")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ma.wav")
		      )
                    (if (string= japanese-char "み")
                        (send *ni* :play-soundfile "/home/nao/wav_test/mi.wav")
		      )
                    (if (string= japanese-char "む")
                        (send *ni* :play-soundfile "/home/nao/wav_test/mu.wav"))
		    (if (string= japanese-char "め")
                        (send *ni* :play-soundfile "/home/nao/wav_test/me.wav")
		      )
                    (if (string= japanese-char "も")
                        (send *ni* :play-soundfile "/home/nao/wav_test/mo.wav")
		      )
                    (if (string= japanese-char "や")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ya.wav"))
		    (if (string= japanese-char "ゆ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/yu.wav")
		      )
                    (if (string= japanese-char "よ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/yo.wav")
		      )
                    (if (string= japanese-char "ら")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ra.wav"))
		    (if (string= japanese-char "り")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ri.wav")
		      )
                    (if (string= japanese-char "る")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ru.wav")
		      )
                    (if (string= japanese-char "れ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/re.wav"))
		    (if (string= japanese-char "ろ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/ro.wav")
		      )
                    (if (string= japanese-char "わ")
                        (send *ni* :play-soundfile "/home/nao/wav_test/wa.wav")
		      )
                    (if (string= japanese-char "を")
                        (send *ni* :play-soundfile "/home/nao/wav_test/wo.wav"))
                    (if (string= japanese-char "ん")
                        (send *ni* :play-soundfile "/home/nao/wav_test/n.wav"))
		    (if (string= japanese-char "おしまい")
                        (send *ni* :play-soundfile "/home/nao/wav_test/oboeruyo_attetaraokmarkuwomisete.wav"))
                    (setq *call_num* (+ *call_num* 1))
                    (setq *pre-japanese-char* japanese-char)
                    )
                )
              (setq *pub_num* 0)
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

(defun tactile-detect-cb (msg)
  (if (eq *current-behavior* :asking)
      (setq *head_touch_count* (+ *head_touch_count* 1))
    )
  )

(defun character-detect-cb (msg)
  (let ((japanese-char 0))
    (if (eq *current-behavior* :talking)
	;;読み取ったひらがなを返す
	(progn
	  (setq japanese-char (send msg :data))
	  (conversation japanese-char)
	  )
      )
    )
  )

(defun launchpad-cb (msg)
  (let ((japanese-char 0))
    (if (eq *current-behavior* :talking)
	;;読み取ったひらがなを返す
	(progn
	  (setq japanese-char (send msg :data))   
	  (setq *launchpad-input* 1)
	  (conversation japanese-char)
	  )
      )
    )
  )

;;added 
(defun bumper-touch-cb (msg)
  (if (or (eq *current-behavior* :idle)
	  (eq *current-behavior* :eyecontact))
      (if (= (send msg :state) 1)
	  (setq *bumper_touched* 1)
	)
    )
  )
;;added end

;;subscribe topics
(ros::subscribe "/face_detector_mono/faces" face_detector_mono::RectArray #'face-detect-cb)
(ros::subscribe "/tactile_touch" nao_msgs::TactileTouch #'tactile-detect-cb)
(ros::subscribe "/nao_character_learn" std_msgs::String  #'character-detect-cb)
(ros::subscribe "/conversation_finished" std_msgs::String #'conversation-finished-cb)
(ros::subscribe "/hiragana_send_to_nao" std_msgs::String #'launchpad-cb)
(ros::subscribe "/bumper" nao_msgs::Bumper #'bumper-touch-cb)

;;main loopを回す
(ros::ros-info "Let's start")
;;(ros::rate 5)
(while (ros::ok)
  (nao-servo-on)
  (idle-check)
  (ros::spin-once)
  (ros::sleep)
)

