import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/StudentPayment/studentpaymentcontroller.dart';

class StudentPayment extends StatelessWidget {
  const StudentPayment({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(StudentPaymentController());

    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "After the payment, you'll be granted access to our courses.",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  const Text("Referral Code", style: TextStyle(fontWeight: FontWeight.w700),),
                  const SizedBox(height: 8),
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
                  )
                ],
              ),
            )
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: controller.confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.01,
            numberOfParticles: 25,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.red,
              Colors.yellow,
              Colors.blue,
            ],
          )
        )
      ],
    );
  }
}
