import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Forgot/forgotcontroller.dart';

class Forgot extends StatelessWidget {
  const Forgot({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(ForgotController());

    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white60,
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
              child: SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/logo.png", height: 60, width: 60),
                      const SizedBox(height: 20),
                      const Text("Forgot password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      const SizedBox(height: 6),
                      const Text("Enter your email to reset your password", style: TextStyle(fontWeight: FontWeight.w500),),
                      const SizedBox(height: 30),
                      const Text("Email address", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: controller.controllerEmail,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(color: Colors.indigo)
                            )
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: Get.width,
                        child: Theme(
                          data: ThemeData(
                              primarySwatch: Colors.grey
                          ),
                          child: TextButton(
                              onPressed: (){
                                controller.resetPassword();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(17)
                                  )
                                  )
                              ),
                              child: const Text("Send reset link", style: TextStyle(color: Colors.white),)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text("Return to", style: TextStyle(fontWeight: FontWeight.w500),),
                          SizedBox(
                            height: 32,
                            child: TextButton(
                              onPressed: (){
                                controller.singIn();
                              },
                              style: const ButtonStyle(),
                              child: const Text("Sign in", style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w700)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
