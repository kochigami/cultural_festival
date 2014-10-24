#include "ros/ros.h"
#include "std_msgs/String.h"
#include <iostream>
#include <fstream>
#include <string.h>
#include <string>

std::ofstream ofs("/home/kochigami/ros/groovy/cultural_festival/launchpad_record/launchpad_record.txt");


int count[48]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

void launchpadCallback(const std_msgs::String::ConstPtr& msg)
{
  if(strcmp(msg->data.c_str(),"あ")==0){
    count[0]++;
  }
  if(strcmp(msg->data.c_str(),"い")==0){
    count[1]++;
  }
  if(strcmp(msg->data.c_str(),"う")==0){
    count[2]++;
  }
  if(strcmp(msg->data.c_str(),"え")==0){
    count[3]++;
  }
  if(strcmp(msg->data.c_str(),"お")==0){
    count[4]++;
  }
  if(strcmp(msg->data.c_str(),"か")==0){
    count[5]++;
  }
  if(strcmp(msg->data.c_str(),"き")==0){
    count[6]++;
  }
  if(strcmp(msg->data.c_str(),"く")==0){
    count[7]++;
  }
  if(strcmp(msg->data.c_str(),"け")==0){
    count[8]++;
  }
  if(strcmp(msg->data.c_str(),"こ")==0){
    count[9]++;
  }
  if(strcmp(msg->data.c_str(),"さ")==0){
    count[10]++;
  }
  if(strcmp(msg->data.c_str(),"し")==0){
    count[11]++;
  }
  if(strcmp(msg->data.c_str(),"す")==0){
    count[12]++;
  }
  if(strcmp(msg->data.c_str(),"せ")==0){
    count[13]++;
  }
  if(strcmp(msg->data.c_str(),"そ")==0){
    count[14]++;
  }
  if(strcmp(msg->data.c_str(),"た")==0){
    count[15]++;
  }
  if(strcmp(msg->data.c_str(),"ち")==0){
    count[16]++;
  }
  if(strcmp(msg->data.c_str(),"つ")==0){
    count[17]++;
  }
  if(strcmp(msg->data.c_str(),"て")==0){
    count[18]++;
  }
  if(strcmp(msg->data.c_str(),"と")==0){
    count[19]++;
  }
  if(strcmp(msg->data.c_str(),"な")==0){
    count[20]++;
  }
  if(strcmp(msg->data.c_str(),"に")==0){
    count[21]++;
  }
  if(strcmp(msg->data.c_str(),"ぬ")==0){
    count[22]++;
  }
  if(strcmp(msg->data.c_str(),"ね")==0){
    count[23]++;
  }
  if(strcmp(msg->data.c_str(),"の")==0){
    count[24]++;
  }
  if(strcmp(msg->data.c_str(),"は")==0){
    count[25]++;
  }
  if(strcmp(msg->data.c_str(),"ひ")==0){
    count[26]++;
  }
  if(strcmp(msg->data.c_str(),"ふ")==0){
    count[27]++;
  }
  if(strcmp(msg->data.c_str(),"へ")==0){
    count[28]++;
  }
  if(strcmp(msg->data.c_str(),"ほ")==0){
    count[29]++;
  }
  if(strcmp(msg->data.c_str(),"ま")==0){
    count[30]++;
  }
  if(strcmp(msg->data.c_str(),"み")==0){
    count[31]++;
  }
  if(strcmp(msg->data.c_str(),"む")==0){
    count[32]++;
  }
  if(strcmp(msg->data.c_str(),"め")==0){
    count[33]++;
  }
  if(strcmp(msg->data.c_str(),"も")==0){
    count[34]++;
  }
  if(strcmp(msg->data.c_str(),"や")==0){
    count[35]++;
  }
  if(strcmp(msg->data.c_str(),"ゆ")==0){
    count[36]++;
  }
  if(strcmp(msg->data.c_str(),"よ")==0){
    count[37]++;
  }
  if(strcmp(msg->data.c_str(),"ら")==0){
    count[38]++;
  }
  if(strcmp(msg->data.c_str(),"り")==0){
    count[39]++;
  }
  if(strcmp(msg->data.c_str(),"る")==0){
    count[40]++;
  }
  if(strcmp(msg->data.c_str(),"れ")==0){
    count[41]++;
  }
  if(strcmp(msg->data.c_str(),"ろ")==0){
    count[42]++;
  }
  if(strcmp(msg->data.c_str(),"わ")==0){
    count[43]++;
  }
  if(strcmp(msg->data.c_str(),"を")==0){
    count[44]++;
  }
  if(strcmp(msg->data.c_str(),"ん")==0){
    count[45]++;
  }
  if(strcmp(msg->data.c_str(),"おわり")==0){
    count[46]++;
  }
  if(strcmp(msg->data.c_str(),"おしまい")==0){
    count[47]++;
  }
  ofs<<"あ:"<<count[0]<<"い:"<<count[1]<<"う:"<<count[2]<<"え:"<<count[3]<<"お:"<<count[4]<<"か:"<<count[5]<<"き:"<<count[6]<<"く:"<<count[7]<<"け:"<<count[8]<<"こ:"<<count[9]<<"さ:"<<count[10]<<"し:"<<count[11]<<"す:"<<count[12]<<"せ:"<<count[13]<<"そ:"<<count[14]<<"た:"<<count[15]<<"ち:"<<count[16]<<"つ:"<<count[17]<<"て:"<<count[18]<<"と:"<<count[19]<<"な:"<<count[20]<<"に:"<<count[21]<<"ぬ:"<<count[22]<<"ね:"<<count[23]<<"の:"<<count[24]<<"は:"<<count[25]<<"ひ:"<<count[26]<<"ふ:"<<count[27]<<"へ:"<<count[28]<<"ほ:"<<count[29]<<"ま:"<<count[30]<<"み:"<<count[31]<<"む:"<<count[32]<<"め:"<<count[33]<<"も:"<<count[34]<<"や:"<<count[35]<<"ゆ:"<<count[36]<<"よ:"<<count[37]<<"ら:"<<count[38]<<"り:"<<count[39]<<"る:"<<count[40]<<"れ:"<<count[41]<<"ろ:"<<count[42]<<"わ:"<<count[43]<<"を:"<<count[44]<<"ん:"<<count[45]<<"おわり:"<<count[46]<<"おしまい:"<<count[47]<<std::endl;
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "launchpad-listener");
  ros::NodeHandle n;
  ros::Subscriber sub = n.subscribe("launchpad_hiragana_count", 1000, launchpadCallback);
  ros::spin();

  return 0;
}
