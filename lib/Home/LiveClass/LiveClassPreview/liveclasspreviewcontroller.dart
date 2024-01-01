import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:pod_player/pod_player.dart';

class LiveClassPreviewController extends GetxController{

  String title = Get.arguments[0];
  String videoID = Get.arguments[1];

  var dbref = FirebaseDatabase.instance.ref().child("Chats");
  RxList<Map> chats = <Map>[].obs;
  List<String> keys = [];

  var controllerMessage = TextEditingController();
  var homeController = Get.find<HomeController>();
  var scrollController = ScrollController();
  var podController = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(Get.arguments[1])
  )..initialise();

  @override
  void onClose() {
    podController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    dbref.onChildAdded.listen((event) {
      String key = event.snapshot.key??"";
      Map temp = event.snapshot.value as Map;
      if(temp["key"] == videoID) {
        chats.add(temp);
        keys.add(key);
      }
    });

    dbref.onChildRemoved.listen((event) {
      String key = event.snapshot.key??"";
      Map temp = event.snapshot.value as Map;
      if(temp["key"] == videoID) {
        chats.removeAt(keys.indexOf(key));
        keys.removeAt(keys.indexOf(key));
      }
    });

  }

  void pushMessage(){
    if(controllerMessage.text.isNotEmpty) {
      dbref.push().set({
        "name": homeController.username.value,
        "message": controllerMessage.text,
        "time": DateTime.now().toString(),
        "key": videoID
      });
      controllerMessage.text = "";
      try {
        scrollController.jumpTo(scrollController.position.maxScrollExtent+100);
      } catch(e) {
        debugPrint(e.toString());
      }
    }
  }

}