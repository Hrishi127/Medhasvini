import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/PaymentTree/paymenttreecontroller.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import '../../Custom/Widgets.dart';

class PaymentTree extends StatelessWidget {
  const PaymentTree({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(PaymentTreeController());

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Commission", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                      Text(controller.homeController.totalCommission.value, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.green, fontSize: 18),),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                            const Text("Your referral code", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                            const SizedBox(height: 4),
                            Text(controller.homeController.myReferralCode.value, style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 14),),
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
           Obx(()=> controller.homeController.totalCommission.value=="0"?
           Expanded(child: Center(child: Text("No commissions yet", style: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w700, fontSize: 20),)),):
           SizedBox(
             width: Get.width,
               child: SingleChildScrollView(
                 physics: const BouncingScrollPhysics(),
                 scrollDirection: Axis.horizontal,
                 child: TreeView(nodes: controller.homeController.nodes))))
          ],
        ),
      ),
    );
  }
}
