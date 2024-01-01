import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' as g;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Home/homecontroller.dart';

class PaymentTreeController extends g.GetxController{

  var homeController = g.Get.find<HomeController>();
  var controllerUPIID = TextEditingController();
  var controllerAmount= TextEditingController();

  void payout() async {

    Get.dialog(AlertDialog(
      title: const Text("Payout"),
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

          String username = 'rzp_live_rBpw2qKSNK9lFY';
          String password = 'hrudFzTCWbLWg6QT6aDj0aBQ';
          String apiUrl = 'https://api.razorpay.com/v1/payments/validate/vpa';

          // Replace 'your_api_key' with your actual Razorpay API key

          // Encode the API key to Base64 for Basic Authentication
          String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

          try {
            final response = await http.post(
              Uri.parse(apiUrl),
              headers: {'Authorization': basicAuth},
              body: {'vpa': controllerUPIID.text},
            );

            if (response.statusCode == 200) {
              // Successful validation
              debugPrint('VPA validated successfully');
            } else {
              // Handle error response
              debugPrint('Error: ${response.statusCode}, ${response.reasonPhrase}');
              debugPrint('Response body: ${response.body}');
            }
          } catch (e) {
            // Handle any exceptions during the request
            debugPrint('Error: $e');
          }


          String apiKey = "rzp_live_rBpw2qKSNK9lFY";
          String apiSecret = "hrudFzTCWbLWg6QT6aDj0aBQ";
          Map<String, dynamic> payoutData = {
            "account_number": "984536237494263",
            "amount": controllerAmount.text,
            "currency": "INR",
            "mode": "UPI",
            "purpose": "refund",
            "fund_account": {
              "account_type": "vpa",
              "vpa": {
                "address": controllerUPIID.text
              },
              "contact": {
                "name": "Gaurav Kumar",
                "email": "gaurav.kumar@example.com",
                "contact": "9876543210",
                "type": "self",
                "reference_id": "Acme Contact ID 12345",
                "notes": {
                  "notes_key_1": "Tea, Earl Grey, Hot",
                  "notes_key_2": "Tea, Earl Grey… decaf."
                }
              }
            },
            "queue_if_low_balance": true,
            "reference_id": "Acme Transaction ID 12345",
            "narration": "Acme Corp Fund Transfer",
            "notes": {
              "notes_key_1": "Beam me up Scotty",
              "notes_key_2": "Engage"
            }
          };
          try {
            final http.Response response = await http.post(
              Uri.parse("https://api.razorpay.com/v1/payouts"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}",
              },
              body: jsonEncode(payoutData),
            );

            if (response.statusCode == 200) {
              debugPrint("Payout initiated successfully");
              debugPrint("Response: ${response.body}");
              // Handle the response as needed
            } else {
              debugPrint("Failed to initiate payout. Status code: ${response.statusCode}");
              debugPrint("Response: ${response.body}");
              // Handle the error
            }
          } catch (e) {
            debugPrint("Error: $e");
            // Handle network or other errors
          }
        }, child: const Text("Withdraw"))
      ],
    ));

  }

}