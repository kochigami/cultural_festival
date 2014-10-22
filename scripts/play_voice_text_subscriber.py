#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import time
from naoqi import ALProxy
import rospy
from std_msgs.msg import String

if (len(sys.argv) < 2):
    print "Usage: 'python audioplayer_playfile.py IP [PORT]'"
    sys.exit(1)

IP = sys.argv[1]
PORT = 9559

##launchファイルでこのプログラムを動かすためにコメントアウト（理由は分からない）
#if (len(sys.argv) > 2):
#    PORT = sys.argv[2]

try:
    aup = ALProxy("ALAudioPlayer", IP, PORT)
except Exception,e:
    print "Could not create proxy to ALAudioPlayer"
    print "Error was: ",e
    sys.exit(1)


def callback(data):
    #rospy.loginfo(rospy.get_name() + ": I heard %s" % data.data)
    time.sleep(1)
    aup.playFile(data.data)
    #play(data.data)
def listener():
    rospy.init_node('listener', anonymous=True)
    rospy.Subscriber("play_voice_text", String, callback)
    rospy.spin()


if __name__ == '__main__':
    listener()
