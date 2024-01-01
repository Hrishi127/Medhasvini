import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Custom/Strings.dart';
import 'package:medhasvinieducation/Home/home.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:medhasvinieducation/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  // Stripe.publishableKey = Strings.publishableStripe;
  // Stripe.merchantIdentifier = 'Medhasvini Education';
  // await Stripe.instance.applySettings();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = sharedPreferences.getString("token")??"";
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home:  (token=="")?const SignIn():const Home(),
    theme: ThemeData(
      primarySwatch: Colors.indigo,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w600
        )
      )
    ),
  ));
}