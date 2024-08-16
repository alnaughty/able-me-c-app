import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/views/authentication/login_with_socmed.dart';
import 'package:able_me/views/authentication/register_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../services/firebase/email_and_password_auth.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> with ColorPalette {
  final FirebaseEmailPasswordAuth _auth = FirebaseEmailPasswordAuth();
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confpassword;
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _confpasswordNode = FocusNode();
  bool isObscured = true;
  bool isLoading = false;

  String _pwdText = "";
  String _confPwdText = "";

  Future<void> register() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });

    await _auth
        .create(email: _email.text, password: _pwdText)
        .then((value) async {
      if (value == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      await registerUser(value, false);
    });
  }

  Future<void> registerUser(User user, bool isSocMed) async {
    final String? token = await user.getIdToken();
    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    await showModalBottomSheet(
      // ignore: use_build_context_synchronously
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        // ignore: use_build_context_synchronously
        maxHeight: MediaQuery.of(context).size.height,
      ),
      builder: (_) => RegistrationDetails(
        email: isSocMed ? user.email! : _email.text,
        password: isSocMed ? "theableme" : _pwdText,
        firebaseToken: token,
      ),
    );
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    _confpassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    _confpassword.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _kEmailForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Color textColor = context.theme.secondaryHeaderColor;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SizedBox(
                width: size.width,
                child: SingleChildScrollView(
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
                      Text(
                        "REGISTER",
                        style: fontTheme.headlineLarge!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                          .animate(delay: 400.ms)
                          .slideX(duration: 500.ms)
                          .fadeIn(),
                      const Gap(25),
                      Form(
                        key: _kForm,
                        child: Column(
                          children: [
                            Form(
                              key: _kEmailForm,
                              child: TextFormField(
                                focusNode: _emailNode,
                                controller: _email,
                                // autovalidateMode: AutovalidateMode.always,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),

                                onEditingComplete: () async {
                                  final bool isValidEmail =
                                      _kEmailForm.currentState!.validate();

                                  if (isValidEmail) {
                                    if (_password.text.isEmpty) {
                                      _passwordNode.requestFocus();
                                      return;
                                    } else if (_confpassword.text.isEmpty) {
                                      _confpasswordNode.requestFocus();
                                      return;
                                    }
                                  }
                                  final bool isValidated =
                                      _kForm.currentState!.validate();
                                  if (isValidated) {
                                    // await login();

                                    await register();
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(color: textColor),
                                decoration: InputDecoration(
                                  hintText: "example@email.com",
                                  hintStyle: TextStyle(
                                      color: textColor.withOpacity(.5)),
                                  labelStyle: TextStyle(
                                      color: textColor.withOpacity(1)),
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
                                  .fadeIn(duration: 650.ms)
                                  .slideY(begin: 1, end: 0),
                            ),
                            const Gap(10),
                            Column(
                              children: [
                                TextFormField(
                                  controller: _password,
                                  focusNode: _passwordNode,
                                  style: TextStyle(color: textColor),
                                  // autovalidateMode: AutovalidateMode.always,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.match(_confPwdText,
                                        errorText: "Password mismatch")
                                  ]),
                                  onChanged: (text) {
                                    setState(() {
                                      _pwdText = text;
                                    });
                                  },
                                  onEditingComplete: () async {
                                    final bool isValidated =
                                        _kForm.currentState!.validate();
                                    if (isValidated) {
                                      await register();
                                      // await login();
                                    } else {
                                      if (_email.text.isEmpty) {
                                        _emailNode.requestFocus();
                                        return;
                                      } else if (_confpassword.text.isEmpty) {
                                        _confpasswordNode.requestFocus();
                                        return;
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isObscured,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintStyle: TextStyle(
                                        color: textColor.withOpacity(.5)),
                                    labelStyle: TextStyle(
                                        color: textColor.withOpacity(1)),
                                    hintText: "∗∗∗∗∗",
                                    // hintText: "⁕⁕⁕⁕⁕",
                                    label: const Text("Password"),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 700.ms)
                                    .slideY(begin: 1, end: 0),
                                const Gap(10),
                                TextFormField(
                                  style: TextStyle(color: textColor),
                                  controller: _confpassword,
                                  focusNode: _confpasswordNode,
                                  onChanged: (text) {
                                    setState(() {
                                      _confPwdText = text;
                                    });
                                  },
                                  // autovalidateMode: AutovalidateMode.always,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.match(
                                      _pwdText,
                                      errorText: "Password mismatch",
                                    )
                                  ]),
                                  onEditingComplete: () async {
                                    final bool isValidated =
                                        _kForm.currentState!.validate();
                                    if (isValidated) {
                                      // await login();
                                      await register();
                                    } else {
                                      if (_email.text.isEmpty) {
                                        _emailNode.requestFocus();
                                        return;
                                      } else if (_password.text.isEmpty) {
                                        _passwordNode.requestFocus();
                                        return;
                                      }
                                    }
                                  },
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: isObscured,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintStyle: TextStyle(
                                        color: textColor.withOpacity(.5)),
                                    labelStyle: TextStyle(
                                        color: textColor.withOpacity(1)),
                                    hintText: "∗∗∗∗∗",
                                    // hintText: "⁕⁕⁕⁕⁕",
                                    label: const Text("Confirm Password"),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 750.ms)
                                    .slideY(begin: 1, end: 0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox.adaptive(
                            activeColor: purplePalette,
                            value: !isObscured,
                            // fillColor: MaterialStateProperty.resolveWith(
                            //     (states) => Colors.red),
                            onChanged: (bool? f) {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                          Text(
                            "Show Password",
                            style: fontTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.w500, color: textColor),
                          )
                        ],
                      ),
                      const Gap(30),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account but forgot password? ",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                          ),
                          children: [
                            TextSpan(
                              text: "Recover Account",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  context.pushNamed('forgot-password');
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
                      const Gap(30),
                      MaterialButton(
                        height: 60,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        color: greenPalette,
                        onPressed: () async {
                          final bool isEmailValid =
                              _kEmailForm.currentState!.validate();
                          final bool isValidated =
                              _kForm.currentState!.validate();
                          if (isValidated && isEmailValid) {
                            await register();
                          }
                        },
                        child: Center(
                          child: Text(
                            "REGISTER",
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
                      const Gap(30),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: .5,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "OR",
                                style: fontTheme.bodyMedium!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          Expanded(
                            child: Divider(
                              thickness: .5,
                              color: Colors.black.withOpacity(.5),
                            ),
                          )
                        ],
                      ),
                      const Gap(30),
                      LoginWithSocMed(
                        userCallback: (User user) async {
                          setState(() {
                            isLoading = true;
                          });
                          await registerUser(user, true);
                          isLoading = false;
                          if (mounted) setState(() {});
                        },
                      ),
                      const Gap(25),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                          ),
                          children: [
                            TextSpan(
                              text: "Login",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  context.goNamed('login-auth');
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
