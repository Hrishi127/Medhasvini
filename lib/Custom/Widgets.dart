import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Widgets{

  static void snackBar(String message){
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const  Duration(seconds: 3),
    ));
  }

}