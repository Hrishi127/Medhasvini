import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:http/http.dart' as http;

class ForgotController extends GetxController{

  var controllerEmail = TextEditingController();

  void singIn(){
      Get.offAll(()=>const SignIn());
      Get.deleteAll();
  }

  void resetPassword() async {
    if (EmailValidator.validate(controllerEmail.text)) {
      var res = await http.post(
          Uri.parse(Strings.forgotPasswordAPI),
          body: {
            "email": controllerEmail.text
          }
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        Widgets.snackBar(data["msg"]);
        singIn();
      } else {
        var data = jsonDecode(res.body);
        Widgets.snackBar(data["errors"]["non_field_errors"][0]);
      }
    }
    else {
      Widgets.snackBar("Invalid Email");
    }
  }
}