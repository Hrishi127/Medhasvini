import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Custom/Strings.dart';

class LiveClassController extends GetxController{

   var homeController = Get.find<HomeController>();
   RxBool loading = false.obs;
   late SharedPreferences sharedPreferences;
   RxList<dynamic> videos = <String>[].obs;
   RxList<String> videoIDs = <String>[].obs;
   var controllerName = TextEditingController();
   var controllerDescription = TextEditingController();
   var controllerLink = TextEditingController();

   void loadVideos() async{

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
               // var res = await http.post(
               //     Uri.parse("${Strings.videosAPI}/$id"),
               //     body: {
               //        "videoName" : controllerName.text,
               //        "videoDescription" : controllerDescription.text,
               //        "videolink" : controllerLink.text.replaceAll("https://www.youtube.com/watch?v=", "")
               //            .replaceAll("youtube.com/watch?v=", ""),
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

   void delete(int index){}

   void refreshVideos(){
      loading.value = true;
      videos.clear();
      videoIDs.clear();
      loadVideos();
   }

}