import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';

class WithdrawnHistoryController extends GetxController{

  RxList<dynamic> items = [].obs;
  HomeController homeController = Get.find<HomeController>();
  RxBool isLoading = true.obs;
  RxString currentStatus = "".obs;

  Future<void> getHistory() async {
    var response = await http.get(
      Uri.parse(Strings.withdrawalHistory),
      headers: {
        "Authorization" : "Bearer ${homeController.token}"
      }
    );
    items.value = jsonDecode(response.body) as List;
    isLoading.value = false;
    debugPrint(items.toString());
  }

  @override
  void onInit() {
    super.onInit();
    getHistory();
  }

  void status(int index) async {
    await http.post(
      Uri.parse(Strings.withdrawalHistory),
      headers: {"Authorization" : "Bearer ${homeController.token}"},
      body: {"Payment_Id" : items[index]["payment_id"]}).then((value){
      var json = jsonDecode(value.body);
      currentStatus.value = json["status"];
      debugPrint(json.toString());
    });
  }

}