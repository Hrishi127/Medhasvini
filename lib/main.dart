import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medhasvinieducation/Home/home.dart';
import 'package:medhasvinieducation/SignIn/signin.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51Ny7wfSDwhqjewtiIbelx6sJJj1Dz2K73zIjYVpKUZAMoMS1zhtFH9Q3kTGPgUxnstNj4sifm5sFnHvIHTgAxT9J00yRuwpViF";
  Stripe.merchantIdentifier = 'ridgeant';
  await Stripe.instance.applySettings();
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