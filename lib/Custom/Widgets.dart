import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Widgets{

  static void snackBar(String message){
    Get.showSnackbar(GetSnackBar(
      message: message,
      duration: const  Duration(seconds: 3),
    ));
  }

  static Widget commissionView(String userName, String referralCode){
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const  BorderSide(color: Colors.grey)
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(userName),
                ),
                Material(
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Code:$referralCode", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned.fill(child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: (){
              Clipboard.setData(ClipboardData(text: referralCode));
              snackBar("Referral code copied to clipboard");
            },
          ),
        ))
      ],
    );
  }

}