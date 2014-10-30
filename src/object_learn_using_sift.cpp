#include "ros/ros.h"
#include <unistd.h>
#include <iostream>
#include <iomanip>
#include <string.h>
#include <fstream>
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
#include <rospack/rospack.h>

//http://whoopsidaisies.hatenablog.com/entry/2013/12/07/135810#SampleCode
//http:wiki.ros.org/cv_bridge/Tutorials/UsingCvBridgeToConvertBetweenROSImagesAndOpenCVImages
using namespace std;
using namespace ros;
using namespace cv;


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
  ros::Publisher diary_pub;
  ros::Publisher conversation_finished_pub;
  ros::Subscriber picture_permission_sub;
  ros::Subscriber friend_name_sub;
  ros::Subscriber friend_favorite_sub;
  //added 
  ros::Subscriber nao_diary_angry_mode_sub;
  ros::Subscriber nao_secret_mode_name_sub;
  ros::Subscriber nao_secret_mode_favorite_sub;
  //added end
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
  string friendname;
  string friendfavorite;
  std::string default_template_file_name;
  int key;
  int pic_count;
  int count2;
  int nao_diary_angry_mode;
  int nao_secret_name;
  int nao_secret_favorite;
  void filereading(){
    char fname[256];
    string hiragana;
    ROS_INFO("before read");
    for(int i=1; i<49; i++){   
      //sprintf(fname, "/home/kochigami/ros/groovy/cultural_festival/src/image%04d.png",i);
      //sprintf(fname, "/home/kochigami/ros/groovy/karuta/img%04d.png",i);
      sprintf(fname, (default_template_file_name+std::string("/karuta/img%04d.png")).c_str(),i);
      std::ofstream test("/home/kochigami/ros/groovy/cultural_festival/diary/test.txt");
      test<<fname<<std::endl;
      //ROS_INFO("template file name: %s", fname);
      
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
      if(i==46) hiragana="ん";if(i==47) hiragana="おわり";if(i==48) hiragana="おしまい"; 

      template_imgs.push_back(template_data(dst_img, detector, extractor, hiragana.c_str()));
    }
    ROS_INFO("Let's start"); 
  }
  
  LearningObject()
    :it_(nh_),detector (cv::FeatureDetector::create("SIFT")), extractor (cv::DescriptorExtractor::create("SIFT")), matcher (cv::DescriptorMatcher::create("BruteForce"))
  {
    
    rospack::Rospack rp;
    std::vector<std::string> search_path;
    rp.getSearchPathFromEnv(search_path);
    rp.crawl(search_path, 1);
    std::string path;
    if (rp.find("cultural_festival",path)==true) default_template_file_name = path;

    // // for test
    // // write html
    
    // // ファイル出力ストリームの初期化
    //  std::ofstream ofs("/home/kochigami/ros/groovy/cultural_festival/diary/test.html");
    
    // // // ファイルに1行ずつ書き込み
    // // int count_3 = 1;
    //  ofs << "<html>" << std::endl;
    //  //ofs << "<head>" << std::endl;
    //  //ofs << "<style type=\"text/css\">" << std::endl;
    //  //ofs << "<!--" << std::endl;
    //  //ofs << "body   {" << std::endl;
    //  //ofs << " background-image:url(\"/home/kochigami/ros/groovy/cultural_festival/diary/kuma-namida.jpg\");"<< std::endl;
    //  //ofs <<  "background-repeat:repeat;"<< std::endl;
    //  //ofs << "}" << std::endl;
    //  //ofs << "-->"<< std::endl;
    //  //ofs << "</style>" << std::endl;
    //  //ofs << "</head>" << std::endl;

    //  ofs << "<body bgcolor=\"wheat\">" << std::endl;
    //  ofs << "<h1 align=\"center\">"<<"<font color =\"crimson\" size=\"7\">"<<"<b>"<< "かなしみのなおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
    //  ofs << "<hr>" << endl;
    //  int test_num=1;
    //  if(test_num==1){
    //    ofs << "<h3 align=\"center\">" <<"<font color =\"orangered\" size=\"6\">"<<"<b>"<< "ぶんかさいにいったよ" <<"</b>"<< "</h3>";
    //  }
    //  ofs << "<h3 align=\"center\">" <<"<font color =\"orangered\" size=\"6\">"<<"<b>"<< "ぶんかさいにいったよ" <<"</b>"<< "</h3>";
    //  ofs << "<p align=\"center\">" << "<font color =\"orangered\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<<"</p>"<< std::endl;
    //  ofs << "<div align=\"center\">"<<std::endl;
    //  // ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/src/image" << std::setfill('0') <<std::setw(4) << count_3<<".png\" width=\"240\" height=\"160\" alt=\"test\" />" << std::endl;
    //  ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/diary/nao2.JPG\""<< " "<<"height=\"320\" alt=\"test\" />" << std::endl;
    //  ofs << "</div>" <<std::endl;
    //  ofs << "<p align=\"center\">" << "なお、なでなでしてほしかったんだけど"<<"<br>"<< "</p>"<< std::endl;
    //  ofs <<"<p align=\"center\">"<<"<font color =\"darkorange\" size=\"5\">"<< "なでてくれなかった"<< "<\p>"<< std::endl;
    //  //ofs << "<font color =\"magenta\">"<< friendname<< std::endl;
    //  ofs <<"<p align=\"center\">"<<"<font color =\"fuchsia\" size=\"5\">"<< "ちょっといじけちゃったけど、"<<"</p>" << std::endl;
    //  ofs << "<p align=\"center\">" <<"<font color =\"coral\" size=\"5\">"<< "またあの子が遊びに来てくれるといいな"<<"</p>"<< std::endl;

    //  //ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "名前は"<< std::endl;
    //  // //ここにswitch文を入れて一文字ずつ書きこむ
    //  // ofs << "<font color =\"magenta\">"<< "かなち"<< std::endl;
    //  // ofs <<"<font color =\"navy\">"<< "だよ。"<< "</p>"<< std::endl;
    //  ofs << "</body>" << std::endl;
    //  ofs << "</html>" << std::endl;
    
    key=0;
    count2=0;
    friendname="うおりゃあ";
    friendfavorite="うありゃあ";
    //added
    nao_secret_name=0;
    nao_secret_favorite=0;
    nao_diary_angry_mode=0;
    //added end
    filereading();
    image_sub_ = it_.subscribe("/image_raw", 1, 
			       &LearningObject::FeatureMatching, this);
    character_pub = nh_.advertise<std_msgs::String>("/nao_character_learn", 10);
    diary_pub = nh_.advertise<std_msgs::String>("/nao_diary_write_finish", 100);
    conversation_finished_pub = nh_.advertise<std_msgs::String>("/conversation_finished", 10);
    picture_permission_sub = nh_.subscribe("/nao_taking_picture_permission", 1000, &LearningObject::PictureCb, this);
    friend_name_sub = nh_.subscribe("/nao_friend_name", 10, &LearningObject::FriendNameCb, this);
    friend_favorite_sub = nh_.subscribe("/nao_friend_favorite", 10, &LearningObject::FriendFavoriteCb, this);
    //added 
    nao_diary_angry_mode_sub = nh_.subscribe("/nao_diary_angry", 10, &LearningObject::NaoDiaryAngryModeCb, this);
    nao_secret_mode_name_sub = nh_.subscribe("/nao_secret_mode_name", 10, &LearningObject::NaoSecretModeName ,this);
    nao_secret_mode_favorite_sub = nh_.subscribe("/nao_secret_mode_favorite", 10, &LearningObject::NaoSecretModeFavorite ,this);
    //added end
    cv::initModule_nonfree(); // SIFTの初期化
  }

  void NaoSecretModeName(const std_msgs::String::ConstPtr& msg){
    nao_secret_name=1;
  }
  
  void NaoSecretModeFavorite(const std_msgs::String::ConstPtr& msg){
    nao_secret_favorite=1;
  }
  
  void PictureCb(const std_msgs::String::ConstPtr& msg){
    key=1;
    pic_count=0;
    usleep(3000000);
    ROS_INFO("Let's take a picture!");
  }

  void FriendNameCb(const std_msgs::String::ConstPtr& msg){
    friendname = msg->data.c_str();
  }

  void FriendFavoriteCb(const std_msgs::String::ConstPtr& msg){
    friendfavorite = msg->data.c_str();
  }
  //added
  void NaoDiaryAngryModeCb(const std_msgs::String::ConstPtr& msg){
    ROS_INFO("%s",msg->data.c_str());
    if(strcmp(msg->data.c_str(),"なおおこ") == 0){
    nao_diary_angry_mode=1;
    }else {
      nao_diary_angry_mode=2;
    }
  }
  //added end
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
      cv::waitKey(20);
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
    //int count2=0;
    std_msgs::String hiragana_msg;
    
    // for  (std::vector<template_data>::iterator pt= template_imgs.begin(); pt !=template_imgs.end(); pt++){
    
    // added
    char diary_name2[256];
    char diary_topic_name2[256];
    std_msgs::String diary_msg2;
    std::stringstream ss2;
    
    if(nao_diary_angry_mode==1){
      sprintf(diary_name2, (default_template_file_name+std::string("/diary/diary_angry_nadesugi.html")).c_str());
      std::ofstream ofs(diary_name2);
      ofs << "<html>" << std::endl;
      ofs << "<head>" << std::endl;
      ofs << "<style type=\"text/css\">" << std::endl;
      ofs << "<!--" << std::endl;
      ofs << "body   {" << std::endl;
      ofs << " background-image:url(\"" << default_template_file_name<< "/diary/2288.gif\");"<< std::endl;
      ofs <<  "background-repeat:repeat;"<< std::endl;
      ofs << "}" << std::endl;
      ofs << "-->"<< std::endl;
      ofs << "</style>" << std::endl;
      ofs << "</head>" << std::endl;
      
      ofs << "<body bgcolor=\"purple\">" << std::endl;
      ofs << "<h1 align=\"center\">"<<"<font color =\"red\" size=\"7\">"<<"<b>"<< "いかりのなおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
      ofs << "<hr>" << endl;
      ofs << "<h3 align=\"center\">" <<"<font color =\"magenta\" size=\"5\">"<< "ぶんかさいにいったよ" << "</h3>";
      ofs << "<p align=\"center\">" << "<font color =\"deeppink\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<< "</p>"<< std::endl;
      ofs << "<div align=\"center\">"<<std::endl;
      ofs << "<img src=\""<<default_template_file_name <<"/diary/naooko.jpg\""<< " "<<"height=\"320\" alt=\"test\" />" << std::endl;
      ofs << "</div>" <<std::endl;
      ofs << "<p align=\"center\" size=\"6\">" << "なお、なでなでしてもらったんだけど"<<"<br>"<< "</p>"<< std::endl;
      ofs <<"<p align=\"center\">"<<"<font color =\"deeppink\" size=\"5\">"<< "くすぐったくなっちゃった"<< std::endl;
      ofs <<"<p align=\"center\">"<<"<font color =\"deeppink\" size=\"5\">"<< "ちょっといじけちゃったけど、"<< "</p>"<< std::endl;
      ofs << "<p align=\"center\">" <<"<font color =\"deeppink\" size=\"5\">"<< "またあの子に会えるといいな"<< std::endl;

      ofs << "</body>" << std::endl;
      ofs << "</html>" << std::endl;
 
      sprintf(diary_topic_name2, "diary_angry_nadesugi.html");
      ss2 << "firefox"<<" "<< default_template_file_name<<"/diary/"<<diary_topic_name2;
      diary_msg2.data=ss2.str();
      diary_pub.publish(diary_msg2);
      ROS_INFO("diary published");
      nao_diary_angry_mode=0;
    }

    if(nao_diary_angry_mode==2){
      sprintf(diary_name2, (default_template_file_name+std::string("/diary/diary_angry_nadenashi.html")).c_str());
      std::ofstream ofs(diary_name2);
            
      // // ファイルに1行ずつ書き込み
      // int count_3 = 1;
      ofs << "<html>" << std::endl;
      ofs << "<head>" << std::endl;
      ofs << "<style type=\"text/css\">" << std::endl;
      ofs << "<!--" << std::endl;
      ofs << "body   {" << std::endl;
      ofs << " background-image:url(\"" << default_template_file_name<<"/diary/kuma-namida.jpg\");"<< std::endl;
      ofs <<  "background-repeat:repeat;"<< std::endl;
      ofs << "}" << std::endl;
      ofs << "-->"<< std::endl;
      ofs << "</style>" << std::endl;
      ofs << "</head>" << std::endl;

      ofs << "<body bgcolor=\"purple\">" << std::endl;
      ofs << "<h1 align=\"center\">"<<"<font color =\"blue\" size=\"7\">"<<"<b>"<< "かなしみのなおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
      ofs << "<hr>" << endl;
      ofs << "<h3 align=\"center\">" <<"<font color =\"midnightblue\" size=\"6\">"<<"<b>"<< "ぶんかさいにいったよ" <<"</b>"<< "</h3>";
      ofs << "<p align=\"center\">" << "<font color =\"indigo\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<<"</p>"<< std::endl;
      ofs << "<div align=\"center\">"<<std::endl;
      // ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/src/image" << std::setfill('0') <<std::setw(4) << count_3<<".png\" width=\"240\" height=\"160\" alt=\"test\" />" << std::endl;
      ofs << "<img src=\""<<default_template_file_name <<"/diary/naonamida.jpg\""<< " "<<"height=\"320\" alt=\"test\" />" << std::endl;
      ofs << "</div>" <<std::endl;
      ofs << "<p align=\"center\">" << "なお、なでなでしてほしかったんだけど"<<"<br>"<< "</p>"<< std::endl;
      ofs <<"<p align=\"center\">"<<"<font color =\"indigo\" size=\"5\">"<< "なでてくれなかった"<< "</p>"<< std::endl;
      //ofs << "<font color =\"magenta\">"<< friendname<< std::endl;
      ofs <<"<p align=\"center\">"<<"<font color =\"indigo\" size=\"5\">"<< "ちょっといじけちゃったけど、"<<"</p>" << std::endl;
      ofs << "<p align=\"center\">" <<"<font color =\"indigo\" size=\"5\">"<< "またあの子が遊びに来てくれるといいな"<<"</p>"<< std::endl;

      //ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "名前は"<< std::endl;
      // //ここにswitch文を入れて一文字ずつ書きこむ
      // ofs << "<font color =\"magenta\">"<< "かなち"<< std::endl;
      // ofs <<"<font color =\"navy\">"<< "だよ。"<< "</p>"<< std::endl;
      ofs << "</body>" << std::endl;
      ofs << "</html>" << std::endl;
     
      sprintf(diary_topic_name2, "diary_angry_nadenashi.html");
      ss2 << "firefox"<<" "<<default_template_file_name<<"/diary/"<<diary_topic_name2;
      diary_msg2.data=ss2.str();
      diary_pub.publish(diary_msg2);
      ROS_INFO("diary published");
      nao_diary_angry_mode=0;
    }
    //added end

    if (key==1){
      if(pic_count==0){
	char picture_name[256];
	char diary_name[256];
	char diary_topic_name[256];
	char my_friend[256];
	char my_favorite[256];

	sprintf(picture_name, (default_template_file_name+std::string("/picture/test_image%04d.png")).c_str(),count2);
	count2++;
	cv::imwrite(picture_name,temp_img);
	pic_count++;
	ROS_INFO("picture get!!");
	key=0;
	
	if(friendname != "うおりゃあ" && friendfavorite != "うおりゃあ"){

	  // for test
	  // write html
	  
	  // ファイル出力ストリームの初期化
	  
	  sprintf(diary_name, (default_template_file_name+std::string("/diary/diary%04d.html")).c_str(),count2);
	  //std::ofstream ofs("/home/kochigami/ros/groovy/object_learn_using_sift/diary/test.html");
	  std::ofstream ofs(diary_name);
	  // ファイルに1行ずつ書き込み
	  
	  int diary_pattern = rand()%2;
	  if(diary_pattern==0){
	    ofs << "<html>" << std::endl;
	    if(nao_secret_name==1 or nao_secret_favorite==1){
	      ofs << "<head>" << std::endl;
	      ofs << "<style type=\"text/css\">" << std::endl;
	      ofs << "<!--" << std::endl;
	      ofs << "body   {" << std::endl;
	      ofs << " background-image:url(\""<<default_template_file_name<<"/diary/hana.jpg\");"<< std::endl;
	      ofs <<  "background-repeat:repeat;"<< std::endl;
	      ofs << "}" << std::endl;
	      ofs << "-->"<< std::endl;
	      ofs << "</style>" << std::endl;
	      ofs << "</head>" << std::endl;
	    }
	    ofs << "<body bgcolor=\"lightpink\">" << std::endl;
	    ofs << "<h1 align=\"center\">"<<"<font color =\"mediumvioletred\" size=\"7\">"<<"<b>"<< "なおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
	    ofs << "<hr>" << endl;
	    ofs << "<h3 align=\"center\">" <<"<font color =\"royalblue\" size=\"6\">"<< "ぶんかさいでおともだちができたよ" << "</h3>";
	    ofs << "<p align=\"center\">" << "<font color =\"navy\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<< "</p>"<< std::endl;
	    ofs << "<div align=\"center\">"<<std::endl;
	    //ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/src/image" << std::setfill('0') <<std::setw(4) << count_3<<".png\" width=\"240\" height=\"160\" alt=\"test\" />" << std::endl;
	    ofs << "<img src="<<"\"" << picture_name <<"\""<<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	    ofs << "<img src=\""<<default_template_file_name<<"/diary/nao.JPG\"" <<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	    ofs << "</div>" <<std::endl;
	    ofs << "<p align=\"center\">" << "おともだちができたよ。"<<"<br>"<< "</p>"<< std::endl;
	    ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "なまえは"<< std::endl;
	    ofs << "<font color =\"magenta\">"<< friendname<< std::endl;
	    ofs <<"<font color =\"navy\">"<< "っていうんだよ。"<< "</p>"<< std::endl;
	    if (nao_secret_name==1){
	      ofs << "<p align=\"center\">" <<"<font color =\"deeppink\">"<< "なおと同じ名前だよ！"<< std::endl;
	      nao_secret_name=0;
	    }
	    ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "すきなものは"<< std::endl;
	    ofs << "<font color =\"magenta\">"<< friendfavorite<< std::endl;
	    ofs <<"<font color =\"navy\">"<< "なんだって。"<< "</p>"<< std::endl;
	    if (nao_secret_favorite==1){
	      ofs << "<p align=\"center\">" <<"<font color =\"deeppink\">"<< "なおが好きなんだって 照れるなあ"<< std::endl;
	      nao_secret_favorite=0;
	    }
	    ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "きょうはいっしょにあそべてうれしかった。またあえるといいな。"<<"</p>"<< std::endl;
	    ofs << "</body>" << std::endl;
	    ofs << "</html>" << std::endl;
	  }
	  if(diary_pattern==1){
	    ofs << "<html>" << std::endl;
	    if(nao_secret_name==1 or nao_secret_favorite==1){
	      ofs << "<head>" << std::endl;
	      ofs << "<style type=\"text/css\">" << std::endl;
	      ofs << "<!--" << std::endl;
	      ofs << "body   {" << std::endl;
	      ofs << " background-image:url(\""<<default_template_file_name<<"/diary/bluebird.jpg\");"<< std::endl;
	      ofs <<  "background-repeat:repeat;"<< std::endl;
	      ofs << "}" << std::endl;
	      ofs << "-->"<< std::endl;
	      ofs << "</style>" << std::endl;
	      ofs << "</head>" << std::endl;
	    }
	    ofs << "<body bgcolor=\"paleturquoise\">" << std::endl;
	    ofs << "<h1 align=\"center\">"<<"<font color =\"midnightblue\" size=\"7\">"<<"<b>"<< "なおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
	    ofs << "<hr>" << endl;
	    ofs << "<h3 align=\"center\">" <<"<font color =\"hotpink\" size=\"6\">"<< "ぶんかさいでおともだちができたよ" << "</h3>";
	    ofs << "<p align=\"center\">" << "<font color =\"mediumvioletred\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<< "</p>"<< std::endl;
	    ofs << "<div align=\"center\">"<<std::endl;
	    //ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/src/image" << std::setfill('0') <<std::setw(4) << count_3<<".png\" width=\"240\" height=\"160\" alt=\"test\" />" << std::endl;
	    ofs << "<img src="<<"\"" << picture_name <<"\""<<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	    ofs << "<img src=\""<< default_template_file_name<<"/diary/nao2.JPG\"" <<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	    ofs << "</div>" <<std::endl;
	    ofs << "<p align=\"center\">" << "おともだちができたよ。"<<"<br>"<< "</p>"<< std::endl;
	    ofs << "<p align=\"center\">" <<"<font color =\"mediumvioletred\">"<< "なまえは"<< std::endl;
	    ofs << "<font color =\"darkblue\">"<< friendname<< std::endl;
	    ofs <<"<font color =\"mediumvioletred\">"<< "だよ。"<< "</p>"<< std::endl;
	    if (nao_secret_name==1){
	      ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "なおと同じ名前だよ！"<< std::endl;
	      nao_secret_name=0;
	    }
	    ofs << "<p align=\"center\">" <<"<font color =\"mediumvioletred\">"<< "すきなものは"<< std::endl;
	    ofs << "<font color =\"darkblue\">"<< friendfavorite<< std::endl;
	    ofs <<"<font color =\"mediumvioletred\">"<< "なんだって。"<< "</p>"<< std::endl;
	    if (nao_secret_favorite==1){
	      ofs << "<p align=\"center\">" <<"<font color =\"navy\">"<< "なおが好きなんだって 照れるなあ"<< std::endl;
	      nao_secret_favorite=0;
	    }
	    ofs << "<p align=\"center\">" <<"<font color =\"mediumvioletred\">"<< "きょうはいっしょにあそべてうれしかった。またあえるといいな。"<<"</p>"<< std::endl;
	    ofs << "</body>" << std::endl;
	    ofs << "</html>" << std::endl;
	  }
	  
	  // if(diary_pattern==2){
	  //   ofs << "<html>" << std::endl;
	  //   if(nao_secret_name==1 or nao_secret_favorite==1){
	  //     ofs << "<head>" << std::endl;
	  //     ofs << "<style type=\"text/css\">" << std::endl;
	  //     ofs << "<!--" << std::endl;
	  //     ofs << "body   {" << std::endl;
	  //     ofs << " background-image:url(\"/home/kochigami/ros/groovy/cultural_festival/diary/bluebird.jpg\");"<< std::endl;
	  //     ofs <<  "background-repeat:repeat;"<< std::endl;
	  //     ofs << "}" << std::endl;
	  //     ofs << "-->"<< std::endl;
	  //     ofs << "</style>" << std::endl;
	  //     ofs << "</head>" << std::endl;
	  //   }
	  //   ofs << "<body bgcolor=\"wheat\">" << std::endl;
	  //   ofs << "<h1 align=\"center\">"<<"<font color =\"crimson\" size=\"7\">"<<"<b>"<< "なおにっき ２０１４年１０月２６日" <<"</b>"<< "</h1>";
	  //   ofs << "<hr>" << endl;
	  //   ofs << "<h3 align=\"center\">" <<"<font color =\"orangered\" size=\"6\">"<< "ぶんかさいでおともだちができたよ" << "</h3>";
	  //   ofs << "<p align=\"center\">" << "<font color =\"orangered\" size=\"5\">"<< "きょうはマンションのおまつりにいってきたよ。"<<"<br>"<< "</p>"<< std::endl;
	  //   ofs << "<div align=\"center\">"<<std::endl;
	  //   //ofs << "<img src=\"/home/kochigami/ros/groovy/object_learn_using_sift/src/image" << std::setfill('0') <<std::setw(4) << count_3<<".png\" width=\"240\" height=\"160\" alt=\"test\" />" << std::endl;
	  //   ofs << "<img src="<<"\"" << picture_name <<"\""<<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	  //   ofs << "<img src=\"/home/kochigami/ros/groovy/cultural_festival/diary/nao.JPG\"" <<" " <<"height=\"320\" alt=\"test\" />" << std::endl;
	  //   ofs << "</div>" <<std::endl;
	  //   ofs << "<p align=\"center\">" << "おともだちができたよ。"<<"<br>"<< "</p>"<< std::endl;
	  //   ofs << "<p align=\"center\">" <<"<font color =\"orangered\">"<< "なまえは"<< std::endl;
	  //   ofs << "<font color =\"magenta\">"<< friendname<< std::endl;
	  //   ofs <<"<font color =\"orangered\">"<< "っていうんだよ。"<< "</p>"<< std::endl;
	  //   if (nao_secret_name==1){
	  //     ofs << "<p align=\"deeppink\">" <<"<font color =\"deeppink\">"<< "なおと同じ名前だよ！"<< std::endl;
	  //     nao_secret_name=0;
	  //   }
	  //   ofs << "<p align=\"center\">" <<"<font color =\"orangered\">"<< "すきなものは"<< std::endl;
	  //   ofs << "<font color =\"magenta\">"<< friendfavorite<< std::endl;
	  //   ofs <<"<font color =\"navy\">"<< "なんだって。"<< "</p>"<< std::endl;
	  //   if (nao_secret_favorite==1){
	  //     ofs << "<p align=\"center\">" <<"<font color =\"deeppink\">"<< "なおが好きなんだって 照れるなあ"<< std::endl;
	  //     nao_secret_favorite=0;
	  //   }
	  //   ofs << "<p align=\"center\">" <<"<font color =\"orangered\">"<< "きょうはいっしょにあそべてうれしかった。またあえるといいな。"<<"</p>"<< std::endl;
	  //   ofs << "</body>" << std::endl;
	  //   ofs << "</html>" << std::endl;
	  // }

	  
	  std_msgs::String diary_msg, conversation_msg;
	  sprintf(diary_topic_name, "diary%04d.html",count2);
	  std::stringstream ss,st;
	  ss << "firefox"<<" "<< default_template_file_name <<"/diary/"<<diary_topic_name;
	  diary_msg.data=ss.str();
	  diary_pub.publish(diary_msg);
	  ROS_INFO("diary published");
	  st <<"おわり";
	  conversation_msg.data=st.str();
	  conversation_finished_pub.publish(conversation_msg);
	}
      }
      key=0;
    }
    #pragma omp parallel for
    for(int i=0; i< template_imgs.size(); i++){
      //std::vector<template_data>::iterator pt = &template_imgs.at(i);
      template_data *pt = &template_imgs.at(i);
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
      
      int count = i;//count++;
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

      //////////////必要ならコメントアウト外して/////////////////////
      //sprintf(window_name, "match_result%d",count);
      //cv::imshow(window_name, out);
      /////////////ここまで//////////////////////////////////////////


	//cv::waitKey(20); //書くのを忘れていた　忘れるとimshowの結果が出てこない
	// }
      // else{
      // ROS_INFO("output_img is empty");
      // return;
      //  }
            
      hiragana_msg.data = pt->name;
      
    }
    //文字を返すstd_msg::Stringタイプのrostopicをpublishする
    character_pub.publish(hiragana_msg);
    cv::waitKey(20);
  }
};



int main(int argc, char** argv){
  ros::init(argc, argv, "cultural_festival");
  LearningObject LO;
  ros::spin();
  return 0;
  }
