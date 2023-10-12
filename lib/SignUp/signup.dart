import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'signupcontroller.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SignUpController());

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
                      const Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      Row(
                        children: [
                          const Text("Already have an account?", style: TextStyle(fontWeight: FontWeight.w500),),
                          SizedBox(
                            height: 32,
                            child: TextButton(
                              onPressed: (){
                                controller.signIn();
                              },
                              style: const ButtonStyle(),
                              child: const Text("Sign in", style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w700)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text("Full name", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: controller.controllerName,
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
                      const Text("Phone number", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: controller.controllerPhone,
                        keyboardType: TextInputType.phone,
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
                      const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Obx(()=>
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            obscureText: !controller.isVisible.value,
                            controller: controller.controllerPassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffixIcon: Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                      onPressed: (){
                                        controller.isVisible.value = !controller.isVisible.value;
                                      },
                                      icon: Icon(controller.isVisible.value
                                          ?Icons.visibility_off
                                          :Icons.visibility)
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.indigo)
                                )
                            ),
                          ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Confirm password", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Obx(()=>
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (val){
                              controller.signUp();
                            },
                            obscureText: !controller.isVisibleConfirm.value,
                            controller: controller.controllerConfirmPassword,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                                suffixIcon: Focus(
                                  canRequestFocus: false,
                                  descendantsAreFocusable: false,
                                  child: IconButton(
                                      onPressed: (){
                                        controller.isVisibleConfirm.value = !controller.isVisibleConfirm.value;
                                      },
                                      icon: Icon(controller.isVisibleConfirm.value
                                          ?Icons.visibility_off
                                          :Icons.visibility)
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.indigo)
                                )
                            ),
                          ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Obx(()=> CheckboxListTile(
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Row(
                                  children: [
                                    const Text("I agree with ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    InkWell(
                                      onTap: (){
                                        launch("http://medhasvinieducation.com/terms");
                                      },
                                      child: const Text("Terms", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.indigo))),
                                    const Text(" and ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                                    InkWell(
                                      onTap: (){
                                        launch("http://medhasvinieducation.com/privacy");
                                      },
                                      child: const Text("Privacy Policy", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.indigo)))
                                  ],
                                ),
                                value: controller.isAgreed.value,
                                contentPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onChanged: (val){
                                  controller.isAgreed.value = !controller.isAgreed.value;
                                }
                            ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Theme(
                        data: ThemeData(
                            primarySwatch: Colors.grey
                        ),
                        child: SizedBox(
                          width: Get.width,
                          child: TextButton(
                              onPressed: (){
                                controller.signUp();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(17)
                                      )
                                  )
                              ),
                              child: const Text("Sign up", style: TextStyle(color: Colors.white),)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
