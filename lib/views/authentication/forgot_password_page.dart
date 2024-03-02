import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/views/authentication/login_with_socmed.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with ColorPalette {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  late final TextEditingController _email;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    super.dispose();
  }

  void sendCode() {
    print("SEND CODE");
    context.pushNamed("recovery-page");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
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
                            style: fontTheme.displayLarge!.copyWith(
                              color: purplePalette,
                              fontFamily: "Lokanova",
                              // fontWeight: FontWeight.w600,
                            ),
                          ).animate().slideY(duration: 500.ms).fadeIn(),
                          Text(
                            "Inclusive Transportation",
                            style: fontTheme.bodyLarge!.copyWith(
                              color: textColor,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "ACCOUNT",
                          style: fontTheme.headlineLarge!.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate()
                            .slideX(duration: 500.ms)
                            .fadeIn(duration: 500.ms),
                        Text(
                          "RECOVERY",
                          style: fontTheme.headlineLarge!.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            .animate()
                            .slideX(duration: 550.ms)
                            .fadeIn(duration: 550.ms),
                        Text(
                          "Trouble logging in? No problem! Enter your email associated to your account to reset your password and get back to enjoying our services.",
                          style: fontTheme.titleMedium!.copyWith(
                              color: textColor.withOpacity(.5),
                              fontWeight: FontWeight.w400,
                              height: 1),
                        )
                            .animate(delay: 400.ms)
                            .slideY(duration: 500.ms)
                            .fadeIn(),
                      ],
                    ),
                    const Gap(25),
                    Form(
                      key: _kForm,
                      child: TextFormField(
                        controller: _email,
                        // autovalidateMode: AutovalidateMode.always,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ]),
                        onEditingComplete: () async {
                          print("Complete");
                          final bool isValidated =
                              _kForm.currentState!.validate();
                          if (isValidated) {
                            // await login();
                            sendCode();
                          }
                        },
                        style: TextStyle(color: textColor),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "example@email.com",
                          hintStyle:
                              TextStyle(color: textColor.withOpacity(.5)),
                          labelStyle:
                              TextStyle(color: textColor.withOpacity(1)),
                          label: const Text("Email"),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _email.clear();
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 15,
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms)
                          .slideY(begin: 1, end: 0, duration: 600.ms),
                    ),
                    const Gap(20),
                    MaterialButton(
                      height: 60,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      color: greenPalette,
                      onPressed: () {
                        final bool isValidated =
                            _kForm.currentState!.validate();
                        if (isValidated) {
                          sendCode();
                        }
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
                    // const Gap(10),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(60),
                    //     border: Border.all(
                    //       color: Colors.black.withOpacity(.3),
                    //     ),
                    //   ),
                    //   child: MaterialButton(
                    //     height: 60,
                    //     onPressed: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     color: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(60),
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         "CANCEL",
                    //         style: fontTheme.bodyLarge!.copyWith(
                    //           color: Colors.grey.shade700,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                    //     .animate(delay: 720.ms)
                    //     .fadeIn(duration: 720.ms)
                    //     .slideY(begin: 1, end: 0),
                    const Gap(30),

                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: .5,
                            color: textColor.withOpacity(.5),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "OR",
                              style: fontTheme.bodyMedium!.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        Expanded(
                          child: Divider(
                            thickness: .5,
                            color: textColor.withOpacity(.5),
                          ),
                        )
                      ],
                    ),
                    const Gap(30),
                    LoginWithSocMed(
                      loadingCallback: (bool l) {},
                    ),
                    const Gap(25),
                    RichText(
                      text: TextSpan(
                        text: "Email already unavailable? ",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                        ),
                        children: [
                          TextSpan(
                            text: "Create an account",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                context.goNamed('register');
                                // Navigator.of(context).pop();
                              },
                            style: TextStyle(
                              color: greenPalette,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          )
                        ],
                      ),
                    ),

                    const SafeArea(
                      top: false,
                      child: Gap(10),
                    )
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: BackButton(
              color: textColor,
              onPressed: () {
                context.pop();
              },
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     context.pop();
          //   },
          //   icon: Back,
          // ),
          if (isLoading) ...{
            Positioned.fill(
              child: Container(
                color: textColor.withOpacity(.5),
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
      ),
    );
  }
}
