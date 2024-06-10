import 'dart:io';

import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/services/firebase/apple_auth.dart';
import 'package:able_me/services/firebase/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class LoginWithSocMed extends StatelessWidget with GoogleAuth, AppleAuth {
  LoginWithSocMed({super.key, required this.userCallback});
  final ValueChanged<User> userCallback;
  Future<void> login() async {
    // loadingCallback(true);
    // await Future.delayed(3000.ms);
    // loadingCallback(false);
  }

  Widget container(Color textColor, Color bgColor,
          {required Function() onPressed, required String name}) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: textColor.withOpacity(.3),
          ),
        ),
        child: MaterialButton(
          height: 60,
          onPressed: onPressed,
          color: bgColor.darken(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/${name.toLowerCase()}.png",
                height: 35,
              ),
              const Gap(10),
              Text(
                "Login with $name".toUpperCase(),
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Column(
      children: [
        container(textColor, bgColor, onPressed: () {}, name: "Facebook")
            .animate()
            .fade(duration: 1000.ms)
            .slideY(duration: 1000.ms, begin: 1, end: 0),
        const Gap(10),
        container(textColor, bgColor, onPressed: () async {
          await googleSignIn().then((value) {
            if (value != null) {
              userCallback(value);
            }
          });
        }, name: "Google")
            .animate()
            .fade(duration: 1500.ms)
            .slideY(duration: 1500.ms, begin: 1, end: 0),
        if (Platform.isIOS) ...{
          const Gap(10),
          container(textColor, bgColor, onPressed: () async {
            await appleSignIn().then((value) {
              if (value != null) {
                userCallback(value);
              }
            });
          }, name: "Apple")
              .animate()
              .fade(duration: 1550.ms)
              .slideY(duration: 1500.ms, begin: 1, end: 0),
        }
      ],
    );
  }
}
