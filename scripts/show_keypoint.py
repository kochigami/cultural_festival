#!/usr/bin/env python
import cv2
import sys
if (len(sys.argv) < 2):
    print "Usage 'python show_keypoint.py filename'" 
    sys.exit(1)
img = cv2.imread(sys.argv[1])
sift_detector = cv2.FeatureDetector_create("SIFT")
keypoints = sift_detector.detect(img)

out_img = cv2.drawKeypoints(img, keypoints)
cv2.imshow("result", out_img)
cv2.waitKey(0)
cv2.destroyAllWindows()
