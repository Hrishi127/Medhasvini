import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentPaymentController extends GetxController{

  var controllerReferral = TextEditingController();
  var controllerReferralChild = TextEditingController();
  late SharedPreferences sharedPreferences;
  String token = "";
  Map<String, dynamic>? paymentIntent;
  var hasChildCode = false.obs;
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

    if(controllerReferral.text == controllerReferralChild.text){
      Widgets.snackBar("Parent and child referral code can't be same");
    } else {
      var res = await http.get(
          hasChildCode.value
              ? Uri.parse("${Strings.validateReferralAPI}${controllerReferral
              .text}&child_referral_code=${controllerReferralChild.text}")
              : Uri.parse(
              "${Strings.validateReferralAPI}${controllerReferral.text}"),
          headers: {
            "Authorization": "Bearer $token"
          }
      );
      debugPrint(res.body);
      if (res.statusCode == 200) {
        paymentRazorpay();
      } else {
        var json = jsonDecode(res.body);
        Widgets.snackBar(json["message"]);
      }
    }
  }

  void paymentRazorpay(){

    Razorpay razorpay = Razorpay();
    var options = {
      'key': Strings.testMode? 'rzp_test_tumiFCOB1lz5rh' : 'rzp_live_rBpw2qKSNK9lFY',
      'amount': 100,
      'name': 'Medhasvini Education',
      'description': 'Course',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "91${homeController.phone.value}", 'email': homeController.email.value},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response){
    Widgets.snackBar("Payment failed");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    congDialog();
    var data = json.encode({
      "amount" : 1999,
      "referral_code": controllerReferral.text.toString(),
      "userid" : int.parse(homeController.id.value.toString())
    });
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
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    debugPrint(response.walletName);
  }



  // Future<void> paymentStripe() async {
  //
  //
  //   Map<String, dynamic> body = {
  //     "amount" : "199900",
  //     "currency" : "INR",
  //     "receipt_email" : homeController.email.value
  //   };
  //
  //   var res = await http.post(
  //       Uri.parse(Strings.stripeAPI),
  //       body: body,
  //       headers: {
  //         "Authorization" : "Bearer ${Strings.secretStripe}",
  //         "Content-type" : "application/x-www-form-urlencoded"
  //       }
  //   );
  //   paymentIntent = json.decode(res.body);
  //   debugPrint(paymentIntent.toString());
  //
  //   await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
  //     paymentIntentClientSecret: paymentIntent!["client_secret"],
  //     style: ThemeMode.light,
  //     merchantDisplayName: "Medhasvini Education",
  //     billingDetails: BillingDetails(
  //         email: homeController.email.value,
  //         name: homeController.username.value
  //     ),
  //   )).then((value) => {});
  //
  //   var data = json.encode({
  //     "amount" : 1999,
  //     "referral_code": controllerReferral.text.toString(),
  //     "userid" : int.parse(homeController.id.value.toString())
  //   });
  //
  //   await Stripe.instance.presentPaymentSheet().then((value) async {
  //     var res = await http.post(
  //       Uri.parse(Strings.paymentDoneAPI),
  //       body: data,
  //       headers: {
  //         "content-type" : "application/json",
  //         "accept" : "application/json",
  //         "Authorization" : "Bearer $token"
  //       }
  //     );
  //     debugPrint("PaymentDone ${res.body}");
  //     congDialog();
  //   });
  //
  // }

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
