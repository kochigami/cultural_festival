#!/usr/bin/env roseus
;;program for nao servo-on when wanting to work nao's demo after servo off 
;; roseus nao-servo-off.l                                                    
  
(load "package://naoeus/euslisp/nao-interface.l")
(setq *ni* (instance nao-interface :init))
(ros::ros-info "ok")
(while (ros::ok)
  (ros::spin-once)
  (send *ni* :servo-on)
  )
