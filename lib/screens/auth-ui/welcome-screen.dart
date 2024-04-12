

import 'package:e_commers/controllers/google-sign-in-controller.dart';
import 'package:e_commers/screens/auth-ui/sign-in-screen.dart';
import 'package:e_commers/screens/user-panel/main-screen.dart';
import 'package:e_commers/utils/app-constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppConstant.appTextColor),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppConstant.appScendoryColor,
        title: const Text(
          "Welcome to my app",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            child: Lottie.asset('assets/images/splash-icon.json'),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: const Text(
              "Happy Shopping",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 12,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                color: AppConstant.appScendoryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                icon: Image.asset(
                  'assets/images/img.png',
                  width: Get.width / 12,
                  height: Get.height / 12,
                ),
                label: const Text(
                  "Sign in with google",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                onPressed: ()async {
                  await _googleSignInController.signInWithGoogle();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 50,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                color: AppConstant.appScendoryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextButton.icon(
                icon: const Icon(
                  Icons.email,
                  color: AppConstant.appTextColor,
                ),
                label: const Text(
                  "Sign in with email",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
