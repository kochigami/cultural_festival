#!/usr/bin/env python
#-*- coding: utf-8 -*-
import rospy
from std_msgs.msg import String
import subprocess

def callback(data):
    #呼ばれるたびにcountを増やしていきたい
    #cmd="firefox ../diary/diary.html"
    cmd=data.data
    print cmd
    subprocess.call(cmd, shell=True)

def listener():
    rospy.init_node('diary_display', anonymous=True)
    rospy.Subscriber("/nao_diary_write_finish", String , callback)
    rospy.spin()

if __name__=='__main__':
    listener()
