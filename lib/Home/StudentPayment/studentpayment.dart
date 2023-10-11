import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/StudentPayment/studentpaymentcontroller.dart';

class StudentPayment extends StatelessWidget {
  const StudentPayment({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(StudentPaymentController());

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "After the payment, you'll be granted access to our courses.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.redeem),
                      SizedBox(width: 8),
                      Text("Referral Code", style: TextStyle(fontWeight: FontWeight.w700),),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller.controllerReferral,
                    decoration: InputDecoration(
                      labelText: "Code",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  Theme(
                    data: ThemeData(
                      primarySwatch: Colors.grey
                    ),
                    child: SizedBox(
                      width: Get.width,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.indigo),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ))
                        ),
                        onPressed: (){
                          controller.validate();
                        },
                        child: const Text("Buy now", style: TextStyle(color: Colors.white),)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}
