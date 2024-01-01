import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:medhasvinieducation/Home/StudentCourse/studentcoursecontroller.dart';

class StudentCourse extends StatelessWidget {
  const StudentCourse({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(StudentCoursesController());

    return Scaffold(
      floatingActionButton:
        Obx(()=>
           Visibility(
            visible: (controller.isAdmin.value == "true")?true:false,
            child: FloatingActionButton(
              onPressed: controller.addCourse,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      body: Obx(()=>
      (controller.loading.value)
        ?const Center(child: CircularProgressIndicator(color: Colors.indigo)):
        (controller.courses.isEmpty)
          ?Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animations/empty.json"),
          const SizedBox(height: 10),
          Text("No courses yet", style: TextStyle(color: Colors.black.withOpacity(0.5)),)
        ],
      ))
            : controller.homeController.isSearching.value?
        ListView.builder(
          itemCount: controller.courses.length,
          itemBuilder: (context, index){

            debugPrint(controller.courses[index]["courseName"].toString().toLowerCase().replaceAll(" ", ""));
            debugPrint(controller.homeController.searchText.value.toLowerCase().replaceAll(" ", ""));

            return Obx(()=>
              controller.courses[index]["courseName"].toString().toLowerCase().replaceAll(" ", "").contains(controller.homeController.searchText.value.toLowerCase().replaceAll(" ", ""))?
              Padding(
                padding: (index==controller.courses.length-1)
                    ?const EdgeInsets.fromLTRB(8, 8, 8, 8)
                    :const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.withOpacity(0.50))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(()=>
                                  SizedBox(
                                      width: Get.width,
                                      height: Get.width/2,
                                      child: Image.memory(controller.images[index], fit: BoxFit.cover)
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 40, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.courses[index]["courseName"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(controller.courses[index]["courseDescription"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(child: Material(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: (){
                                  controller.onTap(index);
                                },
                              ),
                              Obx(()=>
                              controller.isAdmin.value=="true"
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
                                            controller.editCourse(index);
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
                        )),
                      ],
                    ),
                  ),
                ),
              ):const Stack(),
            );
          },
        ):
        RefreshIndicator(
          onRefresh: () async {
            controller.loading.value = true;
            controller.loadCourses();
          },
          child: ListView.builder(
            itemCount: controller.courses.length,
            itemBuilder: (context, index){
              return Padding(
                padding: (index==controller.courses.length-1)
                  ?const EdgeInsets.fromLTRB(8, 8, 8, 8)
                  :const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.withOpacity(0.50))
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(()=>
                                  SizedBox(
                                  width: Get.width,
                                  height: Get.width/2,
                                  child: Image.memory(controller.images[index], fit: BoxFit.cover)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 10, 40, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller.courses[index]["courseName"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(controller.courses[index]["courseDescription"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(child: Material(
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap: (){
                                  controller.onTap(index);
                                },
                              ),
                              Obx(()=>
                              controller.isAdmin.value=="true"
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
                                          controller.editCourse(index);
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
                        )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      )
    );
  }
}
