
import 'dart:async';
import 'package:e_commers/controllers/get-user-data-controller.dart';
import 'package:e_commers/screens/admin-panel/admin-main-screen.dart';
import 'package:e_commers/screens/auth-ui/welcome-screen.dart';
import 'package:e_commers/screens/user-panel/main-screen.dart';
import 'package:e_commers/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer( const Duration(seconds: 3), () {
      loggdin(context);
    });
  }

  Future<void> loggdin(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
      Get.put(GetUserDataController());
      var userData = await getUserDataController.getUserData(user!.uid);

      if (userData.isNotEmpty && userData.length >= 2) {

        if (userData[0]['isAdmin'] == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AdminMainScreen()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const MainScreen()));
        }
      } else {

        if (kDebugMode) {
          print('User data is empty or insufficient.');
        }
      }
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) =>  WelcomeScreen()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appScendoryColor,
      appBar: AppBar(

        backgroundColor: AppConstant.appScendoryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset('assets/images/splash-icon.json'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20.0),
            width: Get.width,
            alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,
              style: const TextStyle(
                  color: AppConstant.appTextColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
