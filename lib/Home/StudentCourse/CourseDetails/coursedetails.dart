import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medhasvinieducation/Home/StudentCourse/CourseDetails/coursedetailscontroller.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(CourseDetailsController());

    return Scaffold(
      floatingActionButton: Obx(()=>
          Visibility(
            visible: (controller.homeController.isAdmin.value == "true")?true:false,
            child: FloatingActionButton(
              onPressed: controller.addVideo,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      appBar: AppBar(
        title: Text(controller.courseName),
        centerTitle: false,
      ),
      body: Obx(()=>
      (controller.loading.value)
          ?const Center(child: CircularProgressIndicator(color: Colors.indigo)):
      (controller.videos.isEmpty)
          ?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/empty.json"),
          const SizedBox(height: 10),
          Text("To add a video click on + button.", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
        ],
      ))
          :ListView.builder(
            itemCount: controller.videos.length,
            itemBuilder: (context, index){
              return Padding(
                padding: (index==controller.videos.length-1)
                  ?const EdgeInsets.fromLTRB(8, 8, 8, 8)
                  :const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                      side: BorderSide(color: Colors.grey.withOpacity(0.50))
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: Get.width,
                              child: YoutubePlayerIFramePlus(
                                controller: YoutubePlayerController(initialVideoId: controller.videoIDs[index], params: const YoutubePlayerParams(autoPlay: false, showFullscreenButton: true)),
                              )
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(controller.videos[index]["videoName"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Text(controller.videos[index]["videoDescription"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                                    ],
                                  ),
                                ),
                              ),
                              Obx(()=>
                              controller.homeController.isAdmin.value=="true"
                                  ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      icon: Icon(Icons.more_vert, color: Colors.black.withOpacity(0.7)),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context)=>[
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, color: Colors.black.withOpacity(0.7)),
                                              const SizedBox(width: 8),
                                              const Text("Edit", style: TextStyle(fontWeight: FontWeight.w600),),
                                            ],
                                          ),
                                          onTap: (){
                                            controller.editVideo(index);
                                          },
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.black.withOpacity(0.7)),
                                              const SizedBox(width: 8),
                                              const Text("Delete", style: TextStyle(fontWeight: FontWeight.w600),),
                                            ],
                                          ),
                                          onTap: (){
                                            controller.delete(index);
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      )
    );
  }
}
