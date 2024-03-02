import 'dart:io';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/auth_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/globals.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/authentication/login_with_socmed.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.tag});
  final String? tag;
  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with ColorPalette, AuthHelper {
  final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  bool isObscured = true;
  bool isLoading = false;
  Future<void> login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      isLoading = true;
    });
    final String? _accessToken = await apiLogin(
      _email.text,
      _password.text,
    );
    isLoading = false;
    if (mounted) setState(() {});
    if (_accessToken != null) {
      // accessTokenProvider. = _accessToken;
      ref.read(accessTokenProvider.notifier).update((state) => _accessToken);
      cacher.setUserToken(_accessToken);
      // ignore: use_build_context_synchronously
      context.pushReplacement(
        '/landing-page/0',
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
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
                            if (widget.tag == null) ...{
                              logo(size.width * .4),
                            } else ...{
                              Hero(
                                tag: widget.tag!,
                                child: logo(size.width * .4),
                              ),
                            },
                            const Gap(10),
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
                            "LOGIN",
                            style: fontTheme.headlineLarge!.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                              .animate(delay: 400.ms)
                              .slideX(duration: 500.ms)
                              .fadeIn(),
                          Text(
                            "Use your email or continue with social to login your account",
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
                        child: Column(
                          children: [
                            TextFormField(
                              focusNode: _emailNode,
                              controller: _email,
                              // autovalidateMode: AutovalidateMode.always,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                              style: TextStyle(color: textColor),
                              onEditingComplete: () async {
                                print("Complete");
                                // if (_email.text.isValidEmail) {

                                // }
                                if (_password.text.isEmpty) {
                                  _passwordNode.requestFocus();
                                  return;
                                }
                                final bool isValidated =
                                    _kForm.currentState!.validate();
                                if (isValidated) {
                                  await login();
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintStyle:
                                    TextStyle(color: textColor.withOpacity(.5)),
                                labelStyle:
                                    TextStyle(color: textColor.withOpacity(1)),
                                hintText: "example@email.com",
                                label: const Text("Email"),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _email.clear();
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    size: 15,
                                    color: textColor.withOpacity(.5),
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 700.ms)
                                .slideY(begin: 1, end: 0),
                            const Gap(10),
                            TextFormField(
                              style: TextStyle(color: textColor),
                              controller: _password,
                              focusNode: _passwordNode,
                              // autovalidateMode: AutovalidateMode.always,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                              onEditingComplete: () async {
                                final bool isValidated =
                                    _kForm.currentState!.validate();
                                if (_email.text.isEmpty) {
                                  _emailNode.requestFocus();
                                  return;
                                }

                                if (isValidated) {
                                  print("VALID");
                                  await login();
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isObscured,
                              decoration: InputDecoration(
                                hintText: "Password",
                                // hintText: "⁕⁕⁕⁕⁕",
                                label: const Text("Password"),
                                hintStyle:
                                    TextStyle(color: textColor.withOpacity(.5)),
                                labelStyle:
                                    TextStyle(color: textColor.withOpacity(1)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    isObscured = !isObscured;
                                    if (mounted) setState(() {});
                                  },
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 15,
                                    color: textColor.withOpacity(.5),
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(duration: 700.ms)
                                .slideY(begin: 1, end: 0)
                          ],
                        ),
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
                          context.pushNamed('forgot-password');
                        },
                        child: const Text(
                          "Forgot Password?",
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
                        onPressed: () async {
                          final bool isValidated =
                              _kForm.currentState!.validate();
                          if (isValidated) {
                            print("VALID");
                            await login();
                          }
                        },
                        child: Center(
                          child: Text(
                            "LOGIN",
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
                              color: textColor.withOpacity(.5),
                            ),
                          ),
                          Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                          text: "New to our platform? ",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                          ),
                          children: [
                            TextSpan(
                              text: "Register",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  context.pushNamed(
                                    'register',
                                  );
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
