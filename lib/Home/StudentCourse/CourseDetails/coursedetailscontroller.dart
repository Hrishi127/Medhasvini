import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseDetailsController extends GetxController{

  int courseIndex = Get.arguments[0]+1;
  String courseName = Get.arguments[1];
  String id = Get.arguments[2].toString();
  RxList<dynamic> videos = [].obs;
  RxList<String> videoIDs = <String>[].obs;
  var controllerName = TextEditingController();
  var controllerDescription = TextEditingController();
  var controllerLink = TextEditingController();
  RxBool loading = true.obs;
  var homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    loadVideos();
  }

  void loadVideos() async {
    var res = await http.get(
      Uri.parse("${Strings.videosAPI}/$courseIndex"),
      headers: {
        "Authorization" : "Bearer ${homeController.token}"
      }
    );
    debugPrint(res.body);

    if(res.statusCode == 200) {
      loading.value = false;
      videos.value = jsonDecode(res.body) as List;
      for (int i = 0; i < videos.length; i++) {
        String videoLink = videos[i]["videolink"];
        String temp = YoutubePlayer.convertUrlToId(videoLink)??"";
        videoIDs.add(temp);
      }
    }
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
          var res = await http.post(
              Uri.parse("${Strings.videosAPI}/$id"),
              body: {
                "videoName" : controllerName.text,
                "videoDescription" : controllerDescription.text,
                "videolink" : YoutubePlayer.convertUrlToId(controllerLink.text)??""
              },
              headers: {
                "Authorization" : "Bearer ${homeController.token}"
              }
          );
          controllerName.text = "";
          controllerDescription.text = "";
          controllerLink.text = "";
          debugPrint(res.body);
          if(res.statusCode==200){
            Widgets.snackBar("Video added successfully");
            refreshVideos();
          } else {
            Widgets.snackBar("Failed to upload the video");
          }
        }, child: const Text("ADD")),
      ],
    ));
  }

  void editVideo(int index) async{
    controllerName.text = videos[index]["videoName"];
    controllerDescription.text = videos[index]["videoDescription"];
    controllerLink.text = videos[index]["videolink"];
    await Future.delayed(const Duration(milliseconds: 100));
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      title: const Text("Edit Course"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            controller: controllerName,
            textInputAction: TextInputAction.next,
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
            controller: controllerDescription,
            textInputAction: TextInputAction.next,
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
            controller: controllerLink,
            textInputAction: TextInputAction.done,
            onSubmitted: (val){
              Get.back();
              editVideo(index);
              },
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

          var body = json.encode({
            "videoName" : controllerName.text,
            "videoDescription" : controllerDescription.text,
            "videolink" : YoutubePlayer.convertUrlToId(controllerLink.text)??""
          });

          var res = await http.put(
              Uri.parse("${Strings.videosAPI}/${videos[index]["id"]}"),
              body: body,
              headers: {
                "content-type" : "application/json",
                "accept" : "application/json",
                "Authorization" : "Bearer ${homeController.token}"
              }
          );
          controllerName.text = "";
          controllerDescription.text = "";
          controllerLink.text = "";

          debugPrint(res.body);
          if(res.statusCode==200){
            Widgets.snackBar("Video edited successfully");
            refreshVideos();
          } else {
            Widgets.snackBar("Failed to edit the video");
          }

        }, child: const Text("ADD")),
      ],
    ));
  }

  void delete(int index) async {
    await Future.delayed(const Duration(milliseconds: 100));
    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          title: const Text("Delete"),
          content: Text("Do you want to delete the ${videos[index]["videoName"]} video?"),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child: const Text("BACK")),
            TextButton(onPressed: () async{
              Get.back();
              var res = await http.delete(
                  Uri.parse("${Strings.videosAPI}/${videos[index]["id"]}"),
                  headers: {
                    "Authorization" : "Bearer ${homeController.token}"
                  }
              );
              debugPrint(res.body);
              if(res.statusCode==200){
                Widgets.snackBar("Video deleted successfully");
                refreshVideos();
              } else {
                Widgets.snackBar("Failed to delete the video");
              }
            }, child: const Text("DELETE"))
          ],
        )
    );
  }

  void refreshVideos(){
    loading.value = true;
    videos.clear();
    videoIDs.clear();
    loadVideos();
  }

}