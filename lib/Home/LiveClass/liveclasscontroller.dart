import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/LiveClass/LiveClassPreview/liveclasspreview.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:pod_player/pod_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveClassController extends GetxController{

   var homeController = Get.find<HomeController>();
   RxBool loading = true.obs;
   late SharedPreferences sharedPreferences;
   RxList videos = [].obs;
   var controllerName = TextEditingController();
   var controllerDescription = TextEditingController();
   var controllerLink = TextEditingController();
   var dbref = FirebaseDatabase.instance.ref().child("Live Class");
   List<String> keys = [];

   @override
   void onInit() {
      super.onInit();
      dbref.onChildAdded.listen((event) {
         loading.value = false;
         keys.add(event.snapshot.key??"");
         Map map = event.snapshot.value as Map;
         videos.add(map);
      });

      dbref.onChildRemoved.listen((event) {
         loading.value = false;
         String key = event.snapshot.key??"";
         videos.removeAt(keys.indexOf(key));
         keys.removeAt(keys.indexOf(key));
      });
  }

   void addVideo(){
      Get.dialog(AlertDialog(
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(10)
         ),
         title: const Text("New Course"),
         content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               TextField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  controller: controllerName,
                  decoration: InputDecoration(
                      labelText: "Video Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.indigo)
                      )
                  ),
               ),
               const SizedBox(height: 8),
               TextField(
                  textInputAction: TextInputAction.next,
                  controller: controllerDescription,
                  decoration: InputDecoration(
                      labelText: "Video Description",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.indigo)
                      )
                  ),
               ),
               const SizedBox(height: 8),
               TextField(
                  textInputAction: TextInputAction.done,
                  onSubmitted: (val){
                     Get.back();
                     addVideo();
                  },
                  autofocus: true,
                  controller: controllerLink,
                  decoration: InputDecoration(
                      labelText: "Video Link",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(color: Colors.indigo)
                      )
                  ),
               ),
            ],
         ),
         actions: [
            TextButton(onPressed: (){
               Get.back();
               controllerName.text = "";
               controllerDescription.text = "";
               controllerLink.text = "";
            }, child: const Text("BACK")),
            TextButton(onPressed: () async {
               Get.back();
               var body = {
                  "videoName" : controllerName.text,
                  "videoDescription" : controllerDescription.text,
                  "videolink" : YoutubePlayer.convertUrlToId(controllerLink.text)??""
               };

               dbref.push().set(body);
               // loadVideos();
               // var res = await http.post(
               //     Uri.parse("${Strings.videosAPI}/$id"),
               //     body: {
               //        "videoName" : controllerName.text,
               //        "videoDescription" : controllerDescription.text,
               //        "videolink" : YoutubePlayer.convertUrlToId(controllerLink.text)??""
               //     },
               //     headers: {
               //        "Authorization" : "Bearer ${homeController.token}"
               //     }
               // );
               controllerName.text = "";
               controllerDescription.text = "";
               controllerLink.text = "";
               // debugPrint(res.body);
               // if(res.statusCode==200){
               //    Widgets.snackBar("Video added successfully");
               //    refreshVideos();
               // } else {
               //    Widgets.snackBar("Failed to upload the video");
               // }
            }, child: const Text("ADD")),
         ],
      ));
   }

   void editVideo(int index){}

   void delete(int index){
      dbref.child(keys[index]).remove();
      keys.removeAt(index);
      // refreshVideos();
   }

   // void refreshVideos(){
   //    loading.value = true;
   //    videos.clear();
   //    loadVideos();
   // }

   void open(int index){
      Get.to(()=> const LiveClassPreview(), arguments: [videos[index]["videoName"], videos[index]["videolink"]]);
   }

}