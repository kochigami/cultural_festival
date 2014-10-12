cultural_festival
=================

new repository for cultural festival
using Nao 

This repository contents are not complete, but I want to accomplish the following functions.

1.Nao reacts people's movement; for example; watching and touching.

2.Nao learns about people, then she writes a diary about people. 

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