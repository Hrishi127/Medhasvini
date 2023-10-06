import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Custom/Strings.dart';

class HomeController extends GetxController{

  RxString username = "".obs;
  RxString email = "".obs;
  RxString id = "".obs;
  late SharedPreferences sharedPreferences;
  RxInt currentPage = 0.obs;
  RxBool isSearching = false.obs;
  var controllerSearch = TextEditingController();
  var searchText = "".obs;
  FocusNode searchFocus = FocusNode();
  RxBool isSearchAvailable = true.obs;
  RxString isAdmin = "false".obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void search(){
    isSearching.value = true;
    searchFocus.requestFocus();
  }

  void closeSearch(){
    isSearching.value = false;
    controllerSearch.text = "";
    searchText.value = "";
  }

  void loadProfile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token")??"";
    isAdmin.value = sharedPreferences.getString("isAdmin")??"false";
    var res = await http.get(
      Uri.parse(Strings.profileAPI),
      headers: {
       "Authorization" : "Bearer $token"
      }
    );
    debugPrint(res.body);
    var json = jsonDecode(res.body);
    username.value = json["name"];
    email.value = json["email"];
    id.value = json["id"].toString();
    debugPrint("${Strings.binaryTreeAPI}/${id.value}");
    var resPaid = await http.get(
        Uri.parse("${Strings.binaryTreeAPI}/${id.value}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    debugPrint(resPaid.body);
    var jsonPaid = jsonDecode(resPaid.body);

    try{
    if(jsonPaid["msg"]!=null) {
      sharedPreferences.setString("paidUser", "");
      debugPrint("Free user");
      currentPage.value = 2;
    }
    }catch(e){}

    try {
      if (jsonPaid[0]["label"] != null) {
        sharedPreferences.setString("paidUser", "true");
        debugPrint("Paid user");
        currentPage.value = 0;
      }
    }catch(e){}
  }

  void changePage(int index){

    if((sharedPreferences.getString("paidUser"))=="true"){
      currentPage.value = index;
      Future.delayed(const Duration(milliseconds: 250));
      Get.back();
    }else{
      Widgets.snackBar("Buy the course to get access");
    }

    if(index==0){
      isSearchAvailable.value = true;
    }else{
      isSearchAvailable.value = false;
    }
  }

  void signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    sharedPreferences.setString("token", "");
    sharedPreferences.setString("paidUser", "");
    Get.offAll(()=>const SignIn());
    Get.deleteAll();
  }

}