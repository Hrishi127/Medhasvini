import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/StudentCourse/CourseDetails/coursedetails.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentCoursesController extends GetxController{

  late SharedPreferences sharedPreferences;
  RxList<dynamic> courses = [].obs;
  RxList<Uint8List> images = <Uint8List>[].obs;
  RxString isAdmin = "false".obs;
  RxBool loading = true.obs;
  var controllerName = TextEditingController();
  var controllerDescription = TextEditingController();
  String token = "";
  String imageBytes = "";
  var homeController = Get.find<HomeController>();


  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  void loadCourses() async{
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token")??"";
    isAdmin.value = sharedPreferences.getString("isAdmin")??"false";
    debugPrint(isAdmin.value);
    var res = await http.get(
      Uri.parse(Strings.allCoursesAPI),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );

    debugPrint(res.body);

    if(res.statusCode==200){
      loading.value = false;
      courses.value = jsonDecode(res.body);

      images.clear();

      for(int i=0; i<courses.length; i++){
        Uint8List bytesImage;
        String imgString = courses[i]["imglink"];
        bytesImage = const Base64Decoder().convert(imgString);
        images.add(bytesImage);
      }
    }

  }

  void onTap(int index){
    String courseName = courses[index]["courseName"];
    Get.to(()=> const CourseDetails(), arguments: [index, courseName, courses[index]["id"]]);
    homeController.isSearching.value = false;
    homeController.controllerSearch.text = "";
    homeController.searchText.value = "";
  }

  void addCourse(){
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: const Text("New Course"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            textInputAction: TextInputAction.next,
            controller: controllerName,
            decoration: InputDecoration(
              labelText: "Course Name",
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
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
                labelText: "Course Description",
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
          Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: const BorderSide(color: Colors.grey)
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: Get.width,
                child: Row(
                  children: [
                    const Expanded(child: Text("Course Image", style: TextStyle(fontSize: 16))),
                    ElevatedButton(onPressed: (){
                      ImagePicker.platform.getImageFromSource(source: ImageSource.gallery).then((value){
                        final bytes = File(value!.path).readAsBytesSync();
                        imageBytes =  "data:image/png;base64,${base64Encode(bytes)}";
                      });
                    }, child: const Text("Choose"))
                  ],
                )
              ),
            ),
          )
        ],
      ),
      actions: [
        TextButton(onPressed: (){
          Get.back();
          controllerName.text = "";
          controllerDescription.text = "";
          imageBytes = "";
        }, child: const Text("BACK")),
        TextButton(onPressed: () async {
          Get.back();
          var res = await http.post(
            Uri.parse(Strings.allCoursesAPI),
            body: {
              "courseName" : controllerName.text,
              "courseDescription" : controllerDescription.text,
              'imglink' : imageBytes
            },
            headers: {
              "Authorization" : "Bearer $token"
            }
          );
          controllerName.text = "";
          controllerDescription.text = "";
          imageBytes = "";
          debugPrint(res.body);
          if(res.statusCode==200){
            Widgets.snackBar("Course added successfully");
            refresh();
          } else {
            Widgets.snackBar("Failed to upload the course");
          }
        }, child: const Text("ADD")),
      ],
    ));
  }

  void editCourse(int index) async{
    controllerName.text = courses[index]["courseName"];
    controllerDescription.text = courses[index]["courseDescription"];
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
                labelText: "Course Name",
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
            textInputAction: TextInputAction.done,
            onSubmitted: (val){
              Get.back();
              editCourse(index);
              },
            decoration: InputDecoration(
                labelText: "Course Description",
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
          imageBytes = "";
        }, child: const Text("BACK")),
        TextButton(onPressed: () async {
          Get.back();
          var res = await http.patch(
              Uri.parse("${Strings.allCoursesDeleteAPI}/${courses[index]["id"]}"),
              body: {
                "courseName" : controllerName.text,
                "courseDescription" : controllerDescription.text,
              },
              headers: {
                "Authorization" : "Bearer $token"
              }
          );
          controllerName.text = "";
          controllerDescription.text = "";
          imageBytes = "";
          debugPrint(res.body);
          if(res.statusCode==200){
            Widgets.snackBar("Course edited successfully");
            refresh();
          } else {
            Widgets.snackBar("Failed to edit the course");
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
        content: Text("Do you want to delete the ${courses[index]["courseName"]} course?"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: const Text("BACK")),
          TextButton(onPressed: () async{
            Get.back();
            var res = await http.delete(
              Uri.parse("${Strings.allCoursesDeleteAPI}/${courses[index]["id"]}"),
              headers: {
                "Authorization" : "Bearer $token"
              }
            );
            debugPrint(res.body);
            if(res.statusCode==200){
              Widgets.snackBar("Course deleted successfully");
              refresh();
            } else {
              Widgets.snackBar("Failed to delete the course");
            }
          }, child: const Text("DELETE"))
        ],
      )
    );
  }

  void refresh(){
    loading.value = true;
    courses.clear();
    images.clear();
    loadCourses();
  }

}