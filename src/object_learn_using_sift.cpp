#include "ros/ros.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <opencv2/opencv.hpp>
#include <opencv2/nonfree/nonfree.hpp>
#include <image_transport/image_transport.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/Image.h>
#include <sensor_msgs/CameraInfo.h>
#include <sensor_msgs/image_encodings.h>
#include <std_msgs/String.h>

//http://whoopsidaisies.hatenablog.com/entry/2013/12/07/135810#SampleCode
//http:wiki.ros.org/cv_bridge/Tutorials/UsingCvBridgeToConvertBetweenROSImagesAndOpenCVImages

using namespace std;
using namespace ros;

typedef struct TD{
  TD(){
  }
  TD(cv::Mat temp, cv::Ptr<cv::FeatureDetector> detector,cv::Ptr<cv::DescriptorExtractor> extractor, const char *_name){
    img = temp;
    detector->detect(img, keypoint);
    extractor->compute(img, keypoint, descriptor);
    name=_name;
  }
  cv::Mat img;
  std::vector<cv::KeyPoint> keypoint;
  cv::Mat descriptor;
  std::string name;
} template_data;

class LearningObject
{
public:
  ros::NodeHandle nh_;
  ros::Publisher character_pub;
  std::vector<template_data> template_imgs;
  image_transport::ImageTransport it_;
  image_transport::Subscriber image_sub_;
  cv::Ptr<cv::FeatureDetector> detector;
  cv::Ptr<cv::DescriptorExtractor> extractor;
  cv::Ptr<cv::DescriptorMatcher> matcher;
  cv_bridge::CvImagePtr cv_ptr;
  std::vector<cv::KeyPoint> inputdata_keypoint;
  cv::Mat inputdata_descriptor;
  cv::Mat input_img;
  void filereading(){
    char fname[256];
    string hiragana;
    
    for(int i=1; i<48; i++){
      sprintf(fname, "/home/kochigami/ros/groovy/object_learn_using_sift/src/image%04d.png",i);
      //template_imgsが空になっていて困っていたら、この時点で空だった。ファイルのパスを全部通して解決
      //image_%04d.jpg
      cv::Mat dst_img=cv::imread(fname);
      if(i==1) hiragana="あ"; if(i==2) hiragana="い"; if(i==3) hiragana="う";
      if(i==4) hiragana="え"; if(i==5) hiragana="お"; if(i==6) hiragana="か";
      if(i==7) hiragana="き"; if(i==8) hiragana="く"; if(i==9) hiragana="け";
      if(i==10) hiragana="こ";if(i==11) hiragana="さ";if(i==12) hiragana="し";
      if(i==13) hiragana="す";if(i==14) hiragana="せ";if(i==15) hiragana="そ";
      if(i==16) hiragana="た";if(i==17) hiragana="ち";if(i==18) hiragana="つ";
      if(i==19) hiragana="て";if(i==20) hiragana="と";if(i==21) hiragana="な";
      if(i==22) hiragana="に";if(i==23) hiragana="ぬ";if(i==24) hiragana="ね";
      if(i==25) hiragana="の";if(i==26) hiragana="は";if(i==27) hiragana="ひ";
      if(i==28) hiragana="ふ";if(i==29) hiragana="へ";if(i==30) hiragana="ほ";
      if(i==31) hiragana="ま";if(i==32) hiragana="み";if(i==33) hiragana="む";
      if(i==34) hiragana="め";if(i==35) hiragana="も";if(i==36) hiragana="や";
      if(i==37) hiragana="ゆ";if(i==38) hiragana="よ";if(i==39) hiragana="ら";
      if(i==40) hiragana="り";if(i==41) hiragana="る";if(i==42) hiragana="れ";
      if(i==43) hiragana="ろ";if(i==44) hiragana="わ";if(i==45) hiragana="を";
      if(i==46) hiragana="ん";if(i==47) hiragana="おわり";

      //とりあえずカルタでうまくいくか調べる
      //if(i==**) hiragana="おわり"; //ジョーカーみたいなのを見せる

      template_imgs.push_back(template_data(dst_img, detector, extractor, hiragana.c_str()));
    }
    ROS_INFO("Let's start"); //printfを使っていたらプログラムを動かすまで表示されなかった
  }
  
  LearningObject()
    :it_(nh_),detector (cv::FeatureDetector::create("SIFT")), extractor (cv::DescriptorExtractor::create("SIFT")), matcher (cv::DescriptorMatcher::create("BruteForce"))
  {

    filereading();
    image_sub_ = it_.subscribe("/image_raw", 1, 
			       &LearningObject::FeatureMatching, this);
    character_pub = nh_.advertise<std_msgs::String>("/nao_character_learn", 10);                        
    cv::initModule_nonfree(); // SIFTの初期化
  }
  
  void FeatureMatching(const sensor_msgs::ImageConstPtr& msg){
    try
      {
	cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);
      }
    catch (cv_bridge::Exception& e)
      {
	ROS_ERROR("cv_bridge exception: %s", e.what());
	return;
      }
   
    input_img = cv_ptr->image.clone();
    cv::Mat temp_img = input_img.clone();
    
    if(!temp_img.empty()){
      cv::imshow("result", temp_img);
      cv::waitKey(20); //書くのを忘れていた　忘れるとimshowの結果が出てこない
    }
    else{
      ROS_INFO("temp_img is empty");
      return;
    }

    // 特徴点抽出                       
    detector->detect(input_img, inputdata_keypoint);
    // 特徴記述      
    extractor->compute(input_img, inputdata_keypoint, inputdata_descriptor);
    // マッチング         
    int count=0;
    std_msgs::String hiragana_msg;
    for (std::vector<template_data>::iterator pt = template_imgs.begin(); pt !=template_imgs.end(); pt++){
      char window_name[16];
      // sprintf(window_name, "template%d",count+1);
      // if(!pt->img.empty()){
      // 	cv::imshow(window_name, pt->img);
      // 	cv::waitKey(20); //書くのを忘れていた　忘れるとimshowの結果が出てこない
      // }
      // else{
      // 	ROS_INFO("template_img is empty");
      // 	return;
      // }
      
      count++;                                     
      std::vector<cv::DMatch> dmatch;
      matcher->match(pt->descriptor, inputdata_descriptor, dmatch);
      double max_dist=0, min_dist=50;
      
      for(int p=0; p< pt->descriptor.rows; p++)
	{
	  double dist=dmatch[p].distance;
	  if(dist < min_dist) min_dist=dist;
	  if(dist > max_dist) max_dist=dist;
	}
      
      std::vector<cv::DMatch> good_matches;
      for(int p=0; p< pt->descriptor.rows; p++){
	if(dmatch[p].distance <= 2*min_dist) good_matches.push_back(dmatch[p]);
	//1.2
      }
      
      cv::Mat out;
      cv::drawMatches(pt->img, pt->keypoint, input_img, inputdata_keypoint, good_matches, out, cv::Scalar::all(-1),cv:: Scalar::all(-1), vector<char>(), cv::DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
      //15
      if(good_matches.size()<12){
	// sprintf(window_name, "match_result%d",count);
	// cv::imshow(window_name, out);
       	continue;
      }
      sprintf(window_name, "match_result%d",count);
      // if(!out.empty()){
      cv::imshow(window_name, out);
	//cv::waitKey(20); //書くのを忘れていた　忘れるとimshowの結果が出てこない
	// }
      // else{
      // ROS_INFO("output_img is empty");
      // return;
      //  }
      
      hiragana_msg.data = pt->name;
      
    }
    //文字を返すstd_msg::Stringタイプのrostopicをpublishする
    //構造体の中を文字を引数に取るように書き換える
    character_pub.publish(hiragana_msg);
    cv::waitKey(20);
  }
};

int main(int argc, char** argv){
  ros::init(argc, argv, "object_learn_using_sift");
  LearningObject LO;
  ros::spin();
  return 0;
  }
