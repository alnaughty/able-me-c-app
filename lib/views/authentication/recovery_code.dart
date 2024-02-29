import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/views/authentication/pin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RecoveryCodePage extends StatefulWidget {
  const RecoveryCodePage({super.key});

  @override
  State<RecoveryCodePage> createState() => _RecoveryCodePageState();
}

class _RecoveryCodePageState extends State<RecoveryCodePage> with ColorPalette {
  bool isLoading = false;
  String code = "";

  void submit() {
    if (code.isEmpty) return;
    print("SUBMIT  : $code");
  }

  static const PIN_LENGTH = 5;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * .05,
                  vertical: 15,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SafeArea(
                      bottom: false,
                      child: Gap(50),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Hero(
                            tag: "splash-tag",
                            child: logo(size.width * .4),
                          ),
                          Text(
                            "ABLE ME",
                            style: fontTheme.headlineLarge!.copyWith(
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ).animate().slideY(duration: 500.ms).fadeIn(),
                          Text(
                            "Inclusive Transportation",
                            style: fontTheme.bodyLarge!.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          )
                              .animate(delay: 400.ms)
                              .slideY(duration: 500.ms)
                              .fadeIn()
                        ],
                      ),
                    ),
                    const Gap(20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "RECOVERY",
                          style: fontTheme.headlineLarge!.copyWith(
                            color: greenPalette.shade900,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate()
                            .slideX(duration: 500.ms)
                            .fadeIn(duration: 500.ms),
                        Text(
                          "CODE",
                          style: fontTheme.headlineLarge!.copyWith(
                            color: greenPalette.shade900,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate()
                            .slideX(duration: 550.ms)
                            .fadeIn(duration: 550.ms),
                        Text.rich(
                          TextSpan(
                              text: "A 5-digit code has been sent to ",
                              children: [
                                TextSpan(
                                  text: "example@email.com",
                                  style: TextStyle(
                                      color: blue, fontWeight: FontWeight.w600),
                                ),
                                const TextSpan(
                                  text:
                                      ". Please check your inbox and enter the code to proceed.",
                                )
                              ]),
                          // "Trouble logging in? No problem! Enter your email associated to your account to reset your password and get back to enjoying our services.",
                          style: fontTheme.titleMedium!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            height: 1,
                          ),
                        )
                            .animate()
                            .slideY(duration: 500.ms)
                            .fadeIn(duration: 500.ms),
                        const Gap(25),
                        PinForm(
                          length: PIN_LENGTH,
                          fieldWidth: 60,
                          // onChanged: (String f) {
                          //   print("CODE : $f");
                          // },
                          onCompleted: (String c) {
                            print("FINAL CODE : $c");
                            setState(() {
                              code = c;
                            });

                            submit();
                          },
                          onChanged: (String f) {
                            if (f.length < PIN_LENGTH) {
                              print("EMPTY CODE! $f");
                              setState(() {
                                code = "";
                              });
                            } else {
                              setState(() {
                                code = f;
                              });
                            }
                          },
                        ),
                        TextButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.resolveWith(
                              (states) => const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: "Montserrat",
                              ),
                            ),
                          ),
                          onPressed: () {
                            // context.pushNamed('forgot-password');
                          },
                          child: const Text(
                            "Resend Code",
                          ),
                        )
                            .animate(delay: 600.ms)
                            .fadeIn(duration: 700.ms)
                            .slideY(begin: 1, end: 0),
                        const Gap(20),
                        MaterialButton(
                          height: 60,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          color: greenPalette,
                          onPressed: () {
                            submit();
                          },
                          child: Center(
                            child: Text(
                              "SUBMIT",
                              style: fontTheme.bodyLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                            .animate(delay: 700.ms)
                            .fadeIn(duration: 700.ms)
                            .slideY(begin: 1, end: 0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: BackButton(
            onPressed: () {
              context.pop();
            },
          ),
        ),
        if (isLoading) ...{
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(.5),
              child: Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  backgroundColor: Platform.isIOS
                      ? Colors.white
                      : Colors.white.withOpacity(.5),
                ),
              ),
            ),
          ),
        },
      ],
    );
  }
}
