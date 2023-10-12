import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medhasvinieducation/Home/LiveClass/LiveClassPreview/liveclasspreviewcontroller.dart';
import 'package:pod_player/pod_player.dart';

class LiveClassPreview extends StatelessWidget {
  const LiveClassPreview({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(LiveClassPreviewController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: false,
        title: Text(controller.title),
      ),
      body: Column(
        children: [
          PodVideoPlayer(controller: PodPlayerController(
            playVideoFrom: PlayVideoFrom.youtube(
              controller.videoID
            )
          )..initialise()),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(8, 14, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat),
                      SizedBox(width: 8),
                      Text("Live Chat", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                    ],
                  ),
                ),
                const Divider(height: 0.25),
                Expanded(
                  child: Stack(
                    children: [
                      Obx(()=>
                      (controller.chats.isEmpty)
                          ?Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/animations/empty.json"),
                          const SizedBox(height: 10),
                          Text("No messages yet.", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                        ],
                      ))
                          :ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          itemCount: controller.chats.length,
                          itemBuilder: (context, index){
                            DateTime dt = DateTime.parse(controller.chats[index]["time"]);
                            String hour = dt.hour.toString();
                            String minute = "";
                            if(dt.minute.toString().length==1){
                               minute = "0${dt.minute.toString()}";
                            } else {
                               minute = dt.minute.toString();
                            }
                            return
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                                children: [
                                                  Text(controller.chats[index]["name"], style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Icon(Icons.circle_rounded, size: 5, color: Colors.black.withOpacity(0.1),),
                                                  ),
                                                  Text("$hour:$minute", style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),),
                                                ],
                                              ),
                                            Text(controller.chats[index]["message"], style: const TextStyle(color: Colors.black, fontSize: 14),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  index==controller.chats.length-1?
                                      const SizedBox(height: 100):const Stack()
                                ],
                              );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.grey.withOpacity(0.5))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: TextField(
                                        controller: controller.controllerMessage,
                                        decoration: const InputDecoration(
                                            hintText: "Message",
                                            border: InputBorder.none
                                        ),
                                        textInputAction: TextInputAction.send,
                                        onSubmitted: (val){
                                          controller.pushMessage();
                                        },
                                      ),
                                    )),
                                    IconButton(onPressed: (){
                                      controller.pushMessage();
                                    }, icon: Icon(Icons.send, color: Colors.indigo,))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
