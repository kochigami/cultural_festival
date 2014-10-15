cultural_festival
=================

new repository for cultural festival
using Nao 

I want to accomplish the following functions.

1.Nao reacts people's movement; for example; watching and touching.

2.Nao learns about people, then she writes a diary about people. 

<how to work>
roslaunch jsk_2014_04_pr2_73b2 nao_driver.launch camera:=true nao_ip:=***NAO's IP***

roslaunch cultural_festival cultural_festival.launch nao_ip:=***NAO's IP***

roscd object_learn_using_sift/euslisp

roseus nao-servo-off.l

<programs description>

nao_object_learn_using_sift.launch 
-> children can talk to NAO by showing a japanese character

cultural_fest_2014_10_26.l
-> displaying nao's movement (main program)

hiragana_subscribe.l
-> publishing people's name, favorite at once

play_voice_text_subscriber.py
-> playing sound file function 
   using this with nao-interface-kochigami.l

nao-interface-kochigami.l
-> nao-interface.l + added playing sound file function 

diary_publish.py
-> subscribing a diary path (html file) 
   diary is about picture data, people's name and favorite
   displaying it on firefox 