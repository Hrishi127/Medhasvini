import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
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
        // paymentRazorpay();
        paymentStripe();
      } else {
        var json = jsonDecode(res.body);
        Widgets.snackBar(json["message"]);
      }
    }
  }

//   void payout() async {
//     final String apiKey = "rzp_test_dWjYKWCwoNduNH";
//     final String apiSecret = "mDickwLnmEofr8Oa37OkvFUu";
//     Map<String, dynamic> payoutData = {
//       "account_number": "2323230006858052",
//       "amount": 1000000,
//       "currency": "INR",
//       "mode": "UPI",
//       "purpose": "refund",
//       "fund_account": {
//         "account_type": "vpa",
//         "vpa": {
//           "address": "gauravkumar@exampleupi"
//         },
//         "contact": {
//           "name": "Gaurav Kumar",
//           "email": "gaurav.kumar@example.com",
//           "contact": "9876543210",
//           "type": "self",
//           "reference_id": "Acme Contact ID 12345",
//           "notes": {
//             "notes_key_1": "Tea, Earl Grey, Hot",
//             "notes_key_2": "Tea, Earl Grey… decaf."
//           }
//         }
//       },
//       "queue_if_low_balance": true,
//       "reference_id": "Acme Transaction ID 12345",
//       "narration": "Acme Corp Fund Transfer",
//       "notes": {
//         "notes_key_1": "Beam me up Scotty",
//         "notes_key_2": "Engage"
//       }
//     };
//     try {
//       final http.Response response = await http.post(
//         Uri.parse("https://api.razorpay.com/v1/payouts"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}",
//         },
//         body: jsonEncode(payoutData),
//       );
//
//       if (response.statusCode == 200) {
//         print("Payout initiated successfully");
//         print("Response: ${response.body}");
//         // Handle the response as needed
//       } else {
//         print("Failed to initiate payout. Status code: ${response.statusCode}");
//         print("Response: ${response.body}");
//         // Handle the error
//       }
//     } catch (e) {
//       print("Error: $e");
//       // Handle network or other errors
//   }
//
// }
//
//   void paymentRazorpay(){
//
//     Razorpay razorpay = Razorpay();
//     var options = {
//       'key': 'rzp_test_E4Mzn98fIHcXek',
//       'amount': 170000,
//       'name': 'Medhasvini Education',
//       'description': 'Course',
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {'contact': "91${homeController.phone.value}", 'email': homeController.email.value},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//     razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
//     razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
//     razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
//     razorpay.open(options);
//   }
//
//   void handlePaymentErrorResponse(PaymentFailureResponse response){
//     Widgets.snackBar("Payment failed");
//   }
//
//   void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
//     congDialog();
//     var data = json.encode({
//       "amount" : 1700,
//       "referral_code": controllerReferral.text.toString(),
//       "userid" : int.parse(homeController.id.value.toString())
//     });
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
//   }
//
//   void handleExternalWalletSelected(ExternalWalletResponse response){
//     debugPrint(response.walletName);
//   }



  Future<void> paymentStripe() async {


    Map<String, dynamic> body = {
      "amount" : "199900",
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
      "amount" : 1999,
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
