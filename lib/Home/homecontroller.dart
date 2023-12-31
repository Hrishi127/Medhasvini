import 'dart:convert';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medhasvinieducation/Custom/Widgets.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Custom/Strings.dart';

class HomeController extends GetxController{

  RxString username = "".obs;
  RxString email = "".obs;
  RxString phone = "".obs;
  RxString id = "".obs;
  late SharedPreferences sharedPreferences;
  RxInt currentPage = 0.obs;
  RxBool isSearching = false.obs;
  var controllerSearch = TextEditingController();
  var searchText = "".obs;
  FocusNode searchFocus = FocusNode();
  RxBool isSearchAvailable = true.obs;
  RxBool isLoadingUserPaidOrNot = true.obs;
  RxString isAdmin = "false".obs;
  String token = "";
  RxString referralCommission = "".obs;
  RxString binaryCommission = "".obs;
  RxString pendingCommission = "".obs;
  RxString totalWithdrawal = "".obs;
  RxString availableAmount = "".obs;
  RxList<TreeNode> nodes = <TreeNode>[].obs;
  RxString myReferralCode = "".obs;
  RxString isPaidUser = "false".obs;
  ConfettiController confettiController = ConfettiController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void search(){
    isSearching.value = true;
    searchFocus.requestFocus();
  }

  void closeSearch(){
    isSearching.value = false;
    controllerSearch.text = "";
    searchText.value = "";
  }

  void loadProfile() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token")??"";
    isAdmin.value = sharedPreferences.getString("isAdmin")??"false";
    var res = await http.get(
      Uri.parse(Strings.profileAPI),
      headers: {
       "Authorization" : "Bearer $token"
      }
    );
    debugPrint(res.body);
    var json = jsonDecode(res.body);
    username.value = json["name"];
    email.value = json["email"];
    phone.value = json["phonenum"];
    id.value = json["id"].toString();

    debugPrint("${Strings.binaryTreeAPI}/${id.value}");

    var resPaid = await http.get(
        Uri.parse("${Strings.binaryTreeAPI}/${id.value}"),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    debugPrint(resPaid.body);
    var jsonPaid = jsonDecode(resPaid.body);

    isLoadingUserPaidOrNot.value = false;

    try{
    if(jsonPaid["msg"]!=null) {
      // Free user
      sharedPreferences.setString("paidUser", "");
      debugPrint("Free user");
      currentPage.value = 2;
      isPaidUser.value = "false";
    }
    }catch(e){debugPrint(e.toString());}

    try {
      // Paid User
      if (jsonPaid[0]["label"] != null) {
        sharedPreferences.setString("paidUser", "true");
        debugPrint("Paid user");
        currentPage.value = 0;
        isPaidUser.value = "true";
        getCommission(jsonPaid);
      }
    }catch(e){debugPrint(e.toString());}
  }

  Future<dynamic> getJsonPaid() async {
    var resPaid = await http.get(
      Uri.parse("${Strings.binaryTreeAPI}/${id.value}"),
      headers: {
        "Authorization" : "Bearer $token"
      }
    );
    debugPrint(resPaid.body);
    var jsonPaid = jsonDecode(resPaid.body);
    return jsonPaid;
  }

  List<TreeNode> getNodes(jsonPaid){
    
    List<TreeNode> temp = [];
    if((jsonPaid as List).isNotEmpty) {
      for(int i= 0; i < (jsonPaid as List).length; i++) {
        String usernameWithReferralCode = jsonPaid[i]["label"].toString();
        String username = usernameWithReferralCode.substring(0, usernameWithReferralCode.indexOf(",")-1);
        String referralCode = usernameWithReferralCode.substring(usernameWithReferralCode.indexOf(",")+1, usernameWithReferralCode.length);
        temp.add(TreeNode(content: Widgets.commissionView(username, referralCode),children: getNodes(jsonPaid[i]["children"])));
      }
    }
    return temp;
  }




  void getCommission(jsonPaid) async {

    myReferralCode.value = jsonPaid[0]["label"].substring(jsonPaid[0]["label"].indexOf(",")+1, jsonPaid[0]["label"].length);
    nodes.add(
        TreeNode(content: Stack(
          children: [
            Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey.withOpacity(0.5))
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("You"),
              ),
            ),
            Positioned.fill(child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: (){
                  Clipboard.setData(ClipboardData(text: myReferralCode.value));
                  Widgets.snackBar("Referral code copied to clipboard");
                },
              ),
            ))
          ],
        ), children: getNodes(jsonPaid[0]["children"]))
    );

    updateCommission();
  }

  void updateCommission() async {
    var res = await http.get(
        Uri.parse(Strings.totalCommissionAPI),
        headers: {
          "Authorization" : "Bearer $token"
        }
    );
    if(res.statusCode == 200){
      var json = jsonDecode(res.body);
      debugPrint(res.body);
      referralCommission.value = json["direct_amount"].toString();
      binaryCommission.value = json["binary_amount"].toString();
      pendingCommission.value = json["pending_commission_amount"].toString();
      totalWithdrawal.value = json["total_withdrawal_amount"].toString();
      availableAmount.value = (double.parse(binaryCommission.value) + double.parse(referralCommission.value) - double.parse(totalWithdrawal.value)).toString();
      debugPrint("Total withdrawal: ${totalWithdrawal.value}");

    } else {
      referralCommission.value = "0.0";
      binaryCommission.value = "0.0";
      pendingCommission.value = "0.0";
      totalWithdrawal.value = "0.0";
      availableAmount.value = "0.0";
    }
  }

  void changePage(int index){

    if((sharedPreferences.getString("paidUser"))=="true"){
      currentPage.value = index;
      Future.delayed(const Duration(milliseconds: 250));
      Get.back();
    }else{
      Widgets.snackBar("Buy the course to get access");
    }

    if(index==0){
      isSearchAvailable.value = true;
    }else{
      isSearchAvailable.value = false;
    }
  }

  void signOut() async {
    await Future.delayed(const Duration(milliseconds: 100));
    sharedPreferences.setString("token", "");
    sharedPreferences.setString("paidUser", "");
    Get.offAll(()=>const SignIn());
    Get.deleteAll();
  }

}