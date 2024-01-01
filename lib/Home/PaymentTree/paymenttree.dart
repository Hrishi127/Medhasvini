import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medhasvinieducation/Home/PaymentTree/paymenttreecontroller.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../../Custom/Widgets.dart';

class PaymentTree extends StatelessWidget {
  const PaymentTree({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(PaymentTreeController());

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.withOpacity(0.5))
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Referral Commission", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: Colors.green, size: 18,),
                            Obx(()=> Text(controller.homeController.referralCommission.value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 16),)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Binary Commission", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: Colors.green, size: 18,),
                            Obx(()=> Text(controller.homeController.binaryCommission.value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 16),)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Pending Commission", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: Colors.green, size: 18,),
                            Obx(()=> Text(controller.homeController.pendingCommission.value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 16),)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Commission", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee, color: Colors.green, size: 18,),
                            Obx(()=> Text((double.parse(controller.homeController.referralCommission.value)+double.parse(controller.homeController.binaryCommission.value)).toString(), style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 16),)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
            child: ElevatedButton(
              onPressed: (){
                controller.payout();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payment),
                  SizedBox(width: 8),
                  Text("Withdraw"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.withOpacity(0.5))
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: (){
                  Clipboard.setData(ClipboardData(text: controller.homeController.myReferralCode.value));
                  Widgets.snackBar("Referral code copied to clipboard");
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Your referral code", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                          const SizedBox(height: 4),
                          Text(controller.homeController.myReferralCode.value, style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),),
                        ],
                      ),
                     IconButton(onPressed: (){
                       Clipboard.setData(ClipboardData(text: controller.homeController.myReferralCode.value));
                       Widgets.snackBar("Referral code copied to clipboard");
                     }, icon: const Icon(Icons.copy))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
             child: Obx(()=> controller.homeController.referralCommission.value=="0.00" || controller.homeController.referralCommission.value == "0"?
             Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Lottie.asset("assets/animations/empty.json"),
                 const SizedBox(height: 10),
                 Text("To earn commissions share \nyour referral code", style: TextStyle(color: Colors.black.withOpacity(0.5)),textAlign: TextAlign.center,)
               ],
             ):
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Material(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10),
                   side: BorderSide(color: Colors.grey.withOpacity(0.5))
                 ),
                 child:  controller.homeController.nodes.isEmpty?
                 const Center(child: CircularProgressIndicator()):
                 SingleChildScrollView(
                   physics: const BouncingScrollPhysics(),
                   child: Column(
                     children: [
                       const SizedBox(height: 8),
                       const Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Icon(Icons.currency_rupee, size: 18),
                             Text("Commission Tree", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                           ],
                         ),
                       ),
                       SizedBox(
                         width: Get.width,
                           child: SingleChildScrollView(
                             physics: const BouncingScrollPhysics(),
                             scrollDirection: Axis.horizontal,
                             child: TreeView(nodes: controller.homeController.nodes)
                           )
                       ),
                       const SizedBox(height: 8),
                     ],
                   ),
                 ),
               ),
             )),
           )
        ],
      ),
    );
  }
}
