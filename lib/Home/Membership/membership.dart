import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/Membership/membershipcontroller.dart';
import '../../Custom/Widgets.dart';

class Membership extends StatelessWidget {
  const Membership({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(MembershipController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text("MEMBERSHIP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey), textAlign: TextAlign.center),
              const Text("Take control of your education", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              Material(
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.currency_rupee, size: 32,),
                          Text("1,999", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text("No monthly subscription,\nyou only pay once.", style: TextStyle(color: Colors.grey), textAlign: TextAlign.center),
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
                          labelText: "Parent Code",
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(()=> SwitchListTile(
                        value: controller.hasChildCode.value,
                        title: const Text("Do you have child referral code?", style: TextStyle(fontSize: 12),),
                        onChanged: (checked){
                          controller.hasChildCode.value = !controller.hasChildCode.value;
                        },
                        contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      )),
                      Obx(()=>
                         controller.hasChildCode.value?Column(
                          children: [
                            TextField(
                              controller: controller.controllerReferralChild,
                              decoration: InputDecoration(
                                  labelText: "Child Code",
                                  border: OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ):const Stack(),
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
                            child: const  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Buy now", style: TextStyle(color: Colors.white)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,)
                              ],
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Material(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text("Lifetime Membership", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text("Join the Medhasvini Education community of individuals with a shared passion for educational skill development, where you can enhance your skills and knowledge With a single payment, gain lifelong membership and the opportunity to continuously learn and grow in your field.", textAlign: TextAlign.start),
                      const SizedBox(height: 32),
                      const Row(
                        children: [
                          Text("INCLUDED FEATURES"),
                          SizedBox(width: 8),
                          Expanded(child: Divider())
                        ],
                      ),
                      const SizedBox(height: 16),
                      Widgets.tickMessage("Unlimited course access"),
                      Widgets.tickMessage("Live class with chat"),
                      Widgets.tickMessage("Regular assessment"),
                      Widgets.tickMessage("One to one interaction"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Get.bottomBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}
