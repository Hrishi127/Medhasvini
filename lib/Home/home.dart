import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/LiveClass/liveclass.dart';
import 'package:medhasvinieducation/Home/Membership/membership.dart';
import 'package:medhasvinieducation/Home/PaymentTree/paymenttree.dart';
import 'package:medhasvinieducation/Home/StudentCourse/studentcourse.dart';
import 'package:medhasvinieducation/Home/homecontroller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(HomeController());

    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xfff1f5f9),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.white,
            title: Obx(() => controller.isSearching.value?
              TextField(
                focusNode: controller.searchFocus,
                controller: controller.controllerSearch,
                onChanged: (val){
                  controller.searchText.value = val;
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none
                ),
              ):
              const Text("Medhasvini Education", style: TextStyle(color: Colors.black))
            ),
            leading: Obx(()=>
              controller.isSearching.value?
                IconButton(onPressed: (){
                  controller.closeSearch();
                },icon: const Icon(Icons.arrow_back_ios_new), tooltip: "Back"):
                Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: (){
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu, color: Colors.black),
                      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                    );
                  }
                ),
              ),
            actions: [
              Obx(() =>
              controller.isPaidUser.value=="true"?
              controller.isSearchAvailable.value?
              controller.isSearching.value?const Stack():
              IconButton(
                onPressed: (){
                  controller.search();
                },
                tooltip: "Search",
                icon: const Icon(Icons.search, color: Colors.black,),
              ): const Stack(): const Stack()),
              Obx(()=>
                controller.currentPage.value == 2?
                controller.isPaidUser.value == "true"?
                 IconButton(
                  onPressed: ()  {
                    controller.nodes.clear();
                    controller.getJsonPaid().then((value) => controller.getCommission(value));
                  },
                  tooltip: "Refresh",
                  icon: const Icon(Icons.refresh, color: Colors.black)): const Stack(): const Stack(),
              ),
            ],
          ),
          drawer: SizedBox(
            width: Get.width/1.5,
            height: Get.height,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: Get.height,
                color: Colors.indigo,
                child: Material(
                  color: Colors.transparent,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/logo.png", height: 40, width: 40, color: Colors.white.withOpacity(0.7),),
                              const Spacer(),
                              PopupMenuButton<int>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                itemBuilder: (context)=>[
                                  PopupMenuItem(enabled: false,child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        const Text("Signed in as "),
                                        Text(controller.username.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  )),
                                  const PopupMenuDivider(),
                                  PopupMenuItem(child: Row(
                                    children: [
                                      Icon(Icons.person_outline, color: Colors.black.withOpacity(0.7)),
                                      const SizedBox(width: 10),
                                      Text("Profile", style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                                  PopupMenuItem(child: Row(
                                    children: [
                                      Icon(Icons.settings_outlined, color: Colors.black.withOpacity(0.7)),
                                      const SizedBox(width: 10),
                                      Text("Settings", style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                                  PopupMenuItem(child: Row(
                                    children: [
                                      Icon(Icons.do_not_disturb_on_outlined, color: Colors.black.withOpacity(0.7)),
                                      const SizedBox(width: 10),
                                      Text("Status", style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                                  const PopupMenuDivider(),
                                  PopupMenuItem(onTap: controller.signOut,
                                    child: Row(
                                      children: [
                                        Icon(Icons.exit_to_app_outlined, color: Colors.black.withOpacity(0.7)),
                                        const SizedBox(width: 10),
                                        Text("Sign out", style: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w500)),
                                      ],
                                    ), ),
                                ],
                                icon: Icon(Icons.person, color: Colors.white.withOpacity(0.7))
                              ),
                              IconButton(onPressed: (){
                                Get.back();
                              },  tooltip: "Close navigation menu",
                                  icon: Icon(Icons.close, color: Colors.white.withOpacity(0.7),))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset("assets/avatar.jpg", fit: BoxFit.cover, height: 100, width: 100,)),
                          ),
                          Obx(()=> Text(controller.username.value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                          Obx(()=> Text(controller.email.value, style: TextStyle(color: Colors.white.withOpacity(0.5)),)),
                          const SizedBox(height: 8),
                          Obx(()=>
                            controller.isAdmin.value == "true"?
                             Material(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: Colors.white.withOpacity(0.5))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text("ADMIN", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 10),),
                              )
                            ):const Stack(),
                          ),
                          const SizedBox(height: 24),
                          Obx(()=> Material(
                              color: controller.currentPage.value==0?
                                Colors.white.withOpacity(0.1):
                                Colors.indigo,
                              shape: controller.currentPage.value==0?
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ):null,
                              child: ListTile(
                                onTap: () async {
                                  controller.changePage(0);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                leading: Icon(Icons.menu_book_outlined, color: Colors.white.withOpacity(0.7),),
                                title: Text("Courses", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),),
                              ),
                            ),
                          ),

                          // Divider(color: Colors.grey.withOpacity(0.10)),

                          const SizedBox(height: 4),
                          // Divider(color: Colors.grey.withOpacity(0.10)),
                          Obx(()=> Material(
                              color: controller.currentPage.value==1?
                              Colors.white.withOpacity(0.1):
                              Colors.indigo,
                              shape: controller.currentPage.value==1?
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ):null,
                              child: ListTile(
                                onTap: (){
                                  controller.changePage(1);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                leading: Icon(Icons.live_tv, color: Colors.white.withOpacity(0.7),),
                                title: Text("Live Class", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Obx(()=> Material(
                            color: controller.currentPage.value==2?
                            Colors.white.withOpacity(0.1):
                            Colors.indigo,
                            shape: controller.currentPage.value==2?
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ):null,
                            child: ListTile(
                              onTap: (){
                                controller.changePage(2);
                              },
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              leading: Icon(Icons.people, color: Colors.white.withOpacity(0.7),),
                              title: Text("Membership", style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: Obx(()=>
            controller.isLoadingUserPaidOrNot.value
            ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
            : (controller.currentPage.value == 0)
              ? const StudentCourse()
              : (controller.currentPage.value == 1)
                ? const LiveClass()
                : (controller.isPaidUser.value=="true") ?
                const PaymentTree():
            const Membership()
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: controller.confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.01,
              numberOfParticles: 25,
              gravity: 0.05,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.red,
                Colors.yellow,
                Colors.blue,
              ],
            )
        )
      ],
    );
  }
}
