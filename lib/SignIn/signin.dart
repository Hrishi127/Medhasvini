import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/SignIn/signincontroller.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(SignInController());

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
                      const Text("Sign in", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35)),
                      Row(
                        children: [
                          const Text("Don't have an account?", style: TextStyle(fontWeight: FontWeight.w500),),
                          SizedBox(
                            height: 32,
                            child: TextButton(
                              onPressed: (){
                                controller.singUp();
                              },
                              style: const ButtonStyle(),
                              child: const Text("Sign up", style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w700)),
                            ),
                          )
                        ],
                      ),
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
                      const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Obx(()=>
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (val){controller.signIn();},
                          obscureText: !controller.isVisible.value,
                          controller: controller.controllerPassword,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                            onPressed: (){
                              controller.isVisible.value = !controller.isVisible.value;
                            },
                            icon: Icon(controller.isVisible.value
                              ?Icons.visibility_off
                              :Icons.visibility)
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
                              title: const Text("Remember me", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                              value: controller.isRememberOn.value,
                              contentPadding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              onChanged: (val){
                                controller.isRememberOn.value = !controller.isRememberOn.value;
                              }
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                          child: TextButton(
                              onPressed: (){
                                controller.forgot();
                              },
                              style: const ButtonStyle(),
                            child: const Text("Forgot password?", style: TextStyle(color: Colors.indigo,fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Get.width,
                        child: Theme(
                          data: ThemeData(
                            primarySwatch: Colors.grey
                          ),
                          child: TextButton(
                            onPressed: (){
                              controller.signIn();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.indigo),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17)
                                )
                              )
                            ),
                            child: const Text("Sign in", style: TextStyle(color: Colors.white),)
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Or continue with", style: TextStyle(color: Colors.black26),),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextButton(
                                onPressed: (){},
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: BorderSide(color: Colors.grey.withOpacity(0.25))
                                  ))
                                ),
                                child: Opacity(opacity: 0.3,child: Image.asset("assets/LoginButtons/1.png", height: 24,width: 24,))
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextButton(
                                  onPressed: (){},
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(color: Colors.grey.withOpacity(0.25))
                                      ))
                                  ),
                                  child: Opacity(opacity: 0.3,child: Image.asset("assets/LoginButtons/2.png", height: 23,width: 23))
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextButton(
                                  onPressed: (){},
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: BorderSide(color: Colors.grey.withOpacity(0.25))
                                      ))
                                  ),
                                  child: Opacity(opacity: 0.3,child: Image.asset("assets/LoginButtons/3.png", height: 20,width:20,))
                              ),
                            ),
                          )
                        ],
                      )
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
