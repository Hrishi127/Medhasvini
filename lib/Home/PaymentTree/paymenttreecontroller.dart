import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/Home/PaymentTree/WithdrawnHistory/withdrawnhistory.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';
import '../../Custom/Strings.dart';

class PaymentTreeController extends g.GetxController{

  var homeController = g.Get.find<HomeController>();
  var controllerUPIID = TextEditingController();
  var controllerAmount= TextEditingController();
  var isWithDrawClicked = false.obs;

  void payout() async {
    isWithDrawClicked.value = true;
    await http.get(
        Uri.parse(Strings.withdrawEligibleAPI),
        headers: {
          "Authorization" : "Bearer ${homeController.token}"
        }
    ).then((value) {
      isWithDrawClicked.value = false;
      if(value.statusCode == 200){
        Get.dialog(AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          title: const Text("Withdraw"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                textInputAction: TextInputAction.next,
                controller: controllerUPIID,
                decoration: InputDecoration(
                    labelText: "UPI ID",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                controller: controllerAmount,
                decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: (){Get.back();}, child: const Text("Back")),
            TextButton(onPressed: () async {
              Get.back();
              await http.post(
                Uri.parse(Strings.withdrawAPI),
                headers: {"Authorization" : "Bearer ${homeController.token}"},
                body: {"upiid" : controllerUPIID.text, "amountwithdraw" : controllerAmount.text}
              ).then((value){
                debugPrint(value.body);
                if(value.statusCode == 200){
                  Widgets.snackBar("Withdraw successful");
                  homeController.updateCommission();
                } else {
                  var json = jsonDecode(value.body);
                  Widgets.snackBar(json["message"]);
                }
              });
            }, child: const Text("Done"))
          ],
        ));
      } else {
        Widgets.snackBar("You are not eligible for withdrawal at this moment. Check out withdrawal instruction for more details.");
      }
    });

  }

  void history(){
    Get.to(const WithdrawnHistory());
  }

  void instructions(){
    Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: const Text("Withdraw Instructions"),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Minimum withdrawal amount is 100"),
            Divider(),
            Text("At binary levels 1, 2, 3, 4, 5, 7 no minimum direct referrals are required"),
            Divider(),
            Text("At binary level 6 minimum 2 direct referrals are required"),
            Divider(),
            Text("At binary level 8 minimum 16 direct referrals are required"),
            Divider(),
            Text("At binary level 9 minimum 32 direct referrals are required"),
            Divider(),
            Text("At binary level 10 minimum 50 direct referrals are required"),

          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){Get.back();}, child: const Text("Back"))
      ],
    ));
  }

  // void payout2() async {
  //   String username = 'rzp_live_rBpw2qKSNK9lFY';
  //   String password = 'hrudFzTCWbLWg6QT6aDj0aBQ';
  //   String apiUrl = 'https://api.razorpay.com/v1/payments/validate/vpa';
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {
  //         "Content-Type": "application/json",
  //         'Authorization': "Basic ${base64Encode(utf8.encode('$username:$password'))}",
  //       },
  //       body: jsonEncode({'vpa': controllerUPIID.text}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Successful validation
  //       debugPrint('VPA validated successfully');
  //     } else {
  //       // Handle error response
  //       debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
  //       debugPrint('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     // Handle any exceptions during the request
  //     debugPrint('Error: $e');
  //   }
  //
  //
  //   String apiKey = ! Strings.testMode?"rzp_test_htyBOTl7brBNsN":"rzp_live_rBpw2qKSNK9lFY";
  //   String apiSecret = ! Strings.testMode?"KZy7qp26f1mD5FTEA9x0y9sc":"hrudFzTCWbLWg6QT6aDj0aBQ";
  //   Map<String, dynamic> payoutData = {
  //     "account_number": ! Strings.testMode?"2323230069343297":"984536237494263",
  //     "amount": "100",
  //     "currency": "INR",
  //     "mode": "UPI",
  //     "purpose": "refund",
  //     "fund_account": {
  //       "account_type": "vpa",
  //       "vpa": {
  //         "address": "hrishizsuthar@okhdfcbank"
  //       },
  //       "contact": {
  //         "name": "Gaurav Kumar",
  //         "email": "gaurav.kumar@example.com",
  //         "contact": "9876543210",
  //         "type": "self",
  //         "reference_id": "Acme Contact ID 12345",
  //         "notes": {
  //           "notes_key_1": "Tea, Earl Grey, Hot",
  //           "notes_key_2": "Tea, Earl Grey… decaf."
  //         }
  //       }
  //     },
  //     "queue_if_low_balance": true,
  //     "reference_id": "Acme Transaction ID 12345",
  //     "narration": "Acme Corp Fund Transfer",
  //     "notes": {
  //       "notes_key_1": "Beam me up Scotty",
  //       "notes_key_2": "Engage"
  //     }
  //   };
  //   try {
  //     final http.Response response = await http.post(
  //       Uri.parse("https://api.razorpay.com/v1/payouts"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}",
  //       },
  //       body: jsonEncode(payoutData),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       debugPrint("Payout initiated successfully");
  //       debugPrint("Response: ${response.body}");
  //       // Handle the response as needed
  //     } else {
  //       debugPrint("Failed to initiate payout. Status code: ${response.statusCode}");
  //       debugPrint("Response: ${response.body}");
  //       // Handle the error
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //     // Handle network or other errors
  //   }
  // }


}