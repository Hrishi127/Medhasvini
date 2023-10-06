import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:medhasvinieducation/Home/home.dart';
import 'package:medhasvinieducation/SignUp/signup.dart';
import 'package:owesome_validator/owesome_validator.dart';
import '../Custom/Strings.dart';
import '../Custom/Widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends GetxController{

  var controllerEmail = TextEditingController();
  var controllerPassword = TextEditingController();
  RxBool isVisible = false.obs;
  RxBool isRememberOn = false.obs;
  late SharedPreferences sharedPreferences;

  void loadSp() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  void onInit() {
    super.onInit();
    loadSp();
  }

  @override
  void onReady() {
    super.onReady();
    controllerEmail.text = "";
    controllerPassword.text = "";



  }

  void singUp(){
    Get.offAll(()=>const SignUp());
    Get.deleteAll();
  }

  void signIn() async {
    final bool isEmailValid = EmailValidator.validate(controllerEmail.text);
    final bool isPasswordValid = OwesomeValidator.password(controllerPassword.text, OwesomeValidator.passwordMinLen8withCamelAndSpecialChar);

    if(!isEmailValid){
      Widgets.snackBar("Invalid Email");
    } else if (controllerPassword.text.length<8){
      Widgets.snackBar("Password must have a minimum length of 8");
    } else if (!isPasswordValid){
      Widgets.snackBar("Password must contain at least one special character, one uppercase letter, one lowercase letter and one number");
    } else {
      var res = await post(Uri.parse(Strings.singInAPI), body: {
        "email" : controllerEmail.text.toLowerCase(),
        "password" : controllerPassword.text,
        "rememberMe" : ""
      });
      debugPrint(res.body);
      var json = jsonDecode(res.body);
      if(json["msg"]!=null){
        Widgets.snackBar(json["msg"]);
        sharedPreferences.setString("token", json["token"]["access"].toString());
        sharedPreferences.setString("isAdmin", json["is_admin"].toString());
        Get.offAll(()=>const Home());
        Get.deleteAll();
      }else{
        Widgets.snackBar(json["errors"]["non_field_errors"][0]);
      }
    }
  }

}