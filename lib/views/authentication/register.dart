import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/views/authentication/login_with_socmed.dart';
import 'package:able_me/views/authentication/register_details.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with ColorPalette {
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
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => RegistrationDetails(
        valueCallback: (List<String> data) async {
          Navigator.of(context).pop();
          print("DATA $data");
          setState(() {
            isLoading = true;
          });
          await Future.delayed(1500.ms);
          setState(() {
            isLoading = false;
          });
          // context.pushReplacement('/landing_page/0');
          // ignore: use_build_context_synchronously
          context.pushReplacement(
            '/landing-page/0',
          );
          // print(data);
        },
      ),
    );
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
                      Text(
                        "REGISTER",
                        style: fontTheme.headlineLarge!.copyWith(
                          color: greenPalette.shade900,
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
                                  print("Complete");
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
                                    print("GOODS");
                                    await register();
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: "example@email.com",
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
                                      print("VALID");
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
                                  decoration: const InputDecoration(
                                    hintText: "∗∗∗∗∗",
                                    // hintText: "⁕⁕⁕⁕⁕",
                                    label: Text("Password"),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 700.ms)
                                    .slideY(begin: 1, end: 0),
                                const Gap(10),
                                TextFormField(
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
                                      print("VALID");
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
                                  decoration: const InputDecoration(
                                    hintText: "∗∗∗∗∗",
                                    // hintText: "⁕⁕⁕⁕⁕",
                                    label: Text("Confirm Password"),
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
                            value: !isObscured,
                            onChanged: (bool? f) {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                          ),
                          Text(
                            "Show Password",
                            style: fontTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      const Gap(30),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account but forgot password? ",
                          style: TextStyle(
                            color: Colors.grey.shade900,
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
                            print("VALID");
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
                        loadingCallback: (bool l) {},
                      ),
                      const Gap(25),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: Colors.grey.shade800,
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
              child: CircularProgressIndicator.adaptive(
                valueColor: const AlwaysStoppedAnimation(Colors.white),
                backgroundColor: Platform.isIOS
                    ? Colors.white
                    : Colors.white.withOpacity(.5),
              ),
            ),
          ),
        },
      ],
    );
  }
}
