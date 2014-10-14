#!/usr/bin/env roseus
;;program for nao servo-off after working nao's demo
;; roseus nao-servo-off.l
(load "package://naoeus/euslisp/nao-interface.l")
(setq *ni* (instance nao-interface :init))
(ros::ros-info "ok")
(while (ros::ok)
  (ros::spin-once)
  (send *ni* :servo-off)
  )