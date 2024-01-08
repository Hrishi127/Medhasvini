import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medhasvinieducation/Home/PaymentTree/WithdrawnHistory/withdrawnhistorycontroller.dart';
import 'package:timeago/timeago.dart' as timeago;


class WithdrawnHistory extends StatelessWidget {
  const WithdrawnHistory({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(WithdrawnHistoryController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("History"),
        actions: [
          IconButton(
          onPressed: (){
            controller.getHistory();
          },
          tooltip: "Refresh",
          icon: const Icon(Icons.refresh, color: Colors.black))
        ],
      ),
      body: Obx(()=>
       controller.isLoading.value?
       const Center(child: CircularProgressIndicator(color: Colors.indigo)):
       (controller.items.isEmpty)
           ?Center(child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Lottie.asset("assets/animations/empty.json"),
           const SizedBox(height: 10),
           Text("No withdrawals yet", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
         ],
       )):
       ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (context, index){
            return Padding(
              padding: (index==0) ? const EdgeInsets.all(8.0) : const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.withOpacity(0.5))
                ),
                child: InkWell(
                  onTap: (){
                    controller.status(index);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.items[index]["upi_id"].toString(), style: const TextStyle(fontSize: 16),),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.currency_rupee, color: Colors.green, size: 16,),
                                  const SizedBox(width: 8),
                                  Text(controller.items[index]["amount"].toString(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ]
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_sharp, color: Colors.grey, size: 16),
                                  const SizedBox(width: 8),
                                  Text(timeago.format(DateTime.parse(controller.items[index]["created_at"].toString())), style: const TextStyle(color: Colors.grey)),
                                ]
                              )
                            ]
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            (controller.items[index]["status"]=="Processed")
                                ? Icons.check_circle_outline
                                : Icons.watch_later_outlined,
                            color: (controller.items[index]["status"]=="Processed")
                                ? Colors.green
                                : Colors.grey,
                          )
                        )
                      ],
                    )
                  ),
                )
              )
            );
          }
        )
      )
    );
  }
}
