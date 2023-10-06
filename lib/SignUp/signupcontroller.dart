import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:owesome_validator/owesome_validator.dart';

import '../Custom/Strings.dart';

class SignUpController extends GetxController{

  var controllerName = TextEditingController();
  var controllerEmail = TextEditingController();
  var controllerPhone = TextEditingController();
  var controllerPassword = TextEditingController();
  var controllerConfirmPassword = TextEditingController();
  RxBool isVisible = false.obs;
  RxBool isVisibleConfirm = false.obs;
  RxBool isAgreed = false.obs;

  void signIn(){
    Get.offAll(()=>const SignIn());
    Get.deleteAll();
  }

  void signUp() async {
    final bool isEmailValid = EmailValidator.validate(controllerEmail.text);
    final bool isPasswordValid = OwesomeValidator.password(controllerPassword.text, OwesomeValidator.passwordMinLen8withCamelAndSpecialChar);

    if(controllerName.text.isEmpty) {
      Widgets.snackBar("Full name is required");
    } else if(!controllerName.text.isAlphabetOnly){
      Widgets.snackBar("Name can only have alphabets");
    } else if(!isEmailValid) {
      Widgets.snackBar("Invalid Email");
    } else if(controllerPhone.text.length!=10){
      Widgets.snackBar("Phone number must be 10 digits");
    } else if(controllerPassword.text.length<8){
      Widgets.snackBar("Password must have a minimum length of 8");
    } else if(!isPasswordValid){
      Widgets.snackBar("Password must contain at least one special character, one uppercase letter, one lowercase letter and one number");
    } else if(controllerPassword.text!=controllerConfirmPassword.text) {
      Widgets.snackBar("Password and Confirm password do not match");
    } else if(!isAgreed.value){
      Widgets.snackBar("Terms and Privacy Policy must be accepted");
    } else {
      var res = await post(Uri.parse(Strings.signUpAPI), body: {
        "name" : controllerName.text,
        "email" : controllerEmail.text.toLowerCase(),
        "phonenum" : controllerPhone.text,
        "password" : controllerPassword.text,
        "confirmpassword" : controllerConfirmPassword.text,
        "agreements" : "true"
      });
      var json = jsonDecode(res.body);
      if(json["msg"] == "Registration Successful"){
        Widgets.snackBar("Registered successfully");
        Get.offAll(()=>const SignIn());
        Get.deleteAll();
      }
    }
  }
}