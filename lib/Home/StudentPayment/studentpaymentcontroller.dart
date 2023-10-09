import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentPaymentController extends GetxController{

  var controllerReferral = TextEditingController();
  late SharedPreferences sharedPreferences;
  String token = "";
  Map<String, dynamic>? paymentIntent;
  ConfettiController confettiController = ConfettiController();
  var homeController = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  void loadToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token")??"";
  }

  void validate() async {
    var res = await http.get(
      Uri.parse("${Strings.validateReferralAPI}${controllerReferral.text}"),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    debugPrint(res.body);
    if(res.statusCode == 200){
      Widgets.snackBar("Valid referral code");
      payment();
    }else{
      Widgets.snackBar("Invalid referral code");
    }
  }


  Future<void> payment() async {


    Map<String, dynamic> body = {
      "amount" : "10000",
      "currency": "INR"
    };

    var res = await http.post(
        Uri.parse(Strings.stripeAPI),
        body: body,
        headers: {
          "Authorization" : "Bearer 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",
          "Content-type" : "application/x-www-form-urlencoded"
        }
    );
    paymentIntent = json.decode(res.body);
    print(paymentIntent);

    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntent!["client_secret"],
      style: ThemeMode.light,
      merchantDisplayName: "Ridgeant"
    )).then((value) => {});

    await Stripe.instance.presentPaymentSheet().then((value) async {
      var res = await http.post(
        Uri.parse(Strings.paymentDoneAPI),
        body: {
          "amount" : "100",
          "referral_code": controllerReferral.text.toString(),
          "userid" : homeController.id.value.toString()
        },
        headers: {
          "Authorization" : "Bearer $token"
        }
      );
      debugPrint(res.body);
      congDialog();
    });

  }

  void congDialog() async {
    confettiController.play();
    homeController.loadProfile();
    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("Congratulations!"),
          content: const Text("You are now subscribed to the Medhasvini Education app."),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child: const Text("BACK"))
          ],
        )
    );
    await Future.delayed(const Duration(seconds: 5));
    confettiController.stop();
  }

}
