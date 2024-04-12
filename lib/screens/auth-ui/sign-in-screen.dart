

import 'package:e_commers/screens/auth-ui/sign-up-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/get-user-data-controller.dart';
import '../../controllers/sign-in-controller.dart';
import '../../utils/app-constant.dart';
import '../admin-panel/admin-main-screen.dart';
import '../user-panel/main-screen.dart';
import 'forget-password-screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserDataController getUserDataController =
  Get.put(GetUserDataController());
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstant.appScendoryColor,
          centerTitle: true,
          title: const Text(
            "Sign In",
            style: TextStyle(color: AppConstant.appTextColor),
          ),
        ),
        body: Column(
          children: [
            isKeyboardVisible
                ? const Text("Welcome to my app")
                : Column(
              children: [
                Lottie.asset('assets/images/splash-icon.json'),
              ],
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: userEmail,
                  cursorColor: AppConstant.appScendoryColor,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: const Icon(Icons.email),
                    contentPadding: const EdgeInsets.only(top: 2.0, left: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              width: Get.width,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Obx(
                        () => TextFormField(
                      controller: userPassword,
                      obscureText: signInController.isPasswordVisible.value,
                      cursorColor: AppConstant.appScendoryColor,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            signInController.isPasswordVisible.toggle();
                          },
                          child: signInController.isPasswordVisible.value
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        contentPadding: const EdgeInsets.only(top: 2.0, left: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                      color: AppConstant.appScendoryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Material(
              child: Container(
                width: Get.width / 2,
                height: Get.height / 18,
                decoration: BoxDecoration(
                  color: AppConstant.appScendoryColor,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: TextButton(
                  child: const Text(
                    "SIGN IN",
                    style: TextStyle(color: AppConstant.appTextColor),
                  ),
                  onPressed: () async {
                    String email = userEmail.text.trim();
                    String password = userPassword.text.trim();

                    if (email.isEmpty || password.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please enter all details",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppConstant.appScendoryColor,
                        colorText: AppConstant.appTextColor,
                      );
                    } else {
                      UserCredential? userCredential = await signInController
                          .signInMethod(email, password);

                      var userData = await getUserDataController
                          .getUserData(userCredential!.user!.uid);

                      if (userCredential.user!.emailVerified) {

                        if (userData[0]['isAdmin'] == true) {
                          Get.snackbar(
                            "Success Admin Login",
                            "login Successfully!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminMainScreen()));

                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                          Get.snackbar(
                            "Success User Login",
                            "login Successfully!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Error",
                          "Please verify your email before login",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appScendoryColor,
                          colorText: AppConstant.appTextColor,
                        );
                      }
                                        }
                  },
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(color: AppConstant.appScendoryColor),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()))
                  ,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        color: AppConstant.appScendoryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}