import 'dart:convert';
import 'dart:ffi';
import 'package:confetti/confetti.dart';
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
      var json = jsonDecode(res.body);
      Widgets.snackBar(json["message"]);
    }
  }


  Future<void> payment() async {


    Map<String, dynamic> body = {
      "amount" : "10000",
      "currency" : "INR",
      "receipt_email" : homeController.email.value
    };

    var res = await http.post(
        Uri.parse(Strings.stripeAPI),
        body: body,
        headers: {
          "Authorization" : "Bearer ${Strings.secretStripe}",
          "Content-type" : "application/x-www-form-urlencoded"
        }
    );
    paymentIntent = json.decode(res.body);
    debugPrint(paymentIntent.toString());

    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntent!["client_secret"],
      style: ThemeMode.light,
      merchantDisplayName: "Medhasvini Education",
      billingDetails: BillingDetails(
          email: homeController.email.value,
          name: homeController.username.value
      ),
    )).then((value) => {});

    var data = json.encode({
      "amount" : 500,
      "referral_code": controllerReferral.text.toString(),
      "userid" : int.parse(homeController.id.value.toString())
    });

    await Stripe.instance.presentPaymentSheet().then((value) async {
      var res = await http.post(
        Uri.parse(Strings.paymentDoneAPI),
        body: data,
        headers: {
          "content-type" : "application/json",
          "accept" : "application/json",
          "Authorization" : "Bearer $token"
        }
      );
      debugPrint("PaymentDone ${res.body}");
      congDialog();
    });

  }

  void congDialog() async {
    homeController.confettiController.play();
    homeController.loadProfile();
    Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 8),
              Text("Payment successful"),
            ],
          ),
          content: const Text("You are now subscribed to the Medhasvini Education app."),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child: const Text("BACK"))
          ],
        )
    );
    await Future.delayed(const Duration(seconds: 5));
    homeController.confettiController.stop();
  }

}
