import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/kyc_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({
    super.key,
    this.reload = false,
    required this.email,
  });
  final bool reload;
  final String email;
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage>
    with ColorPalette, KYCHelper {
  // final AppColors _colors = AppColors.instance;
  // final UserApi _api = UserApi();
  final DataCacher _cacher = DataCacher.instance;
  bool _hasSent = false;
  late final TextEditingController _code;
  @override
  void initState() {
    // TODO: implement initState
    _code = TextEditingController();
    super.initState();

    initPlatformState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _code.dispose();
    super.dispose();
  }

  initPlatformState() async {
    setState(() {
      _hasSent = false;
      _isLoading = true;
    });
    final String? accessToken = _cacher.getUserToken();
    if (accessToken == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final bool f =
        await kycApi.sendEmailVerificationCode(accessToken, widget.email);
    setState(() {
      _hasSent = f;
      _isLoading = false;
    });
  }

  Future<void> validateEmailCode(String email, String code) async {
    final String? accessToken = _cacher.getUserToken();
    if (accessToken == null) return;
    setState(() {
      _isLoading = true;
    });
    await kycApi
        .sendValidationCode(accessToken, email: email, code: code)
        .then((value) {
      context.pushReplacement('/');
    });
    _isLoading = false;
    if (mounted) setState(() {});
  }

  String? __code;
  bool _isLoading = false;
  final GlobalKey<FormState> _kCodeForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final Color scColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Verify Email"),
                centerTitle: true,
                backgroundColor: scColor,
                titleTextStyle:
                    context.fontTheme.headlineSmall!.copyWith(color: textColor),
                // actions: [
                //   IconButton(
                //     onPressed: () async {
                //       await Navigator.push(
                //         context,
                //         PageTransition(
                //           child: const ForgotPasswordPage(),
                //           type: PageTransitionType.rightToLeft,
                //         ),
                //       );
                //     },
                //     icon: Icon(
                //       Icons.password_outlined,
                //     ),
                //   )
                // ],
              ),
              body: SafeArea(
                top: false,
                child: Container(
                  width: double.maxFinite,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: purplePalette,
                            boxShadow: [
                              BoxShadow(
                                color: textColor.withOpacity(.3),
                                offset: const Offset(2, 2),
                                blurRadius: 2,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  bottom: -20,
                                  child: Image.asset(
                                    "assets/images/safe-mail.png",
                                    height: 130,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Verify Your Email",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ),
                        Text.rich(
                          TextSpan(
                            text:
                                "An 8 character code ${_hasSent ? "has been" : "will be"} sent to ",
                            style: TextStyle(
                              color: textColor.withOpacity(.5),
                            ),
                            children: [
                              // TextSpan(
                              //   text: "",
                              //   style: const TextStyle(
                              //     color: Colors.black,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                              TextSpan(
                                text: " Resend Code ",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    initPlatformState();
                                  },
                                style: TextStyle(
                                  color: purplePalette,
                                  decoration: TextDecoration.underline,
                                  decorationColor: purplePalette,
                                ),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _kCodeForm,
                          child: TextFormField(
                            // key: _kEmailForm,
                            onChanged: (text) {
                              _kCodeForm.currentState!.validate();
                              setState(() {
                                __code = text;
                              });
                            },
                            style: TextStyle(
                              color: textColor,
                            ),
                            validator: (text) {
                              if (text == null) {
                                return "Invalid type";
                              } else if (text.isEmpty) {
                                return "This field is required";
                              } else if (text.length < 8 || text.length > 8) {
                                return "Code only contains 8 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "1234567",
                              hintStyle: TextStyle(
                                color: textColor.withOpacity(.5),
                              ),
                              label: const Text(
                                "Verification Code",
                              ),
                              labelStyle: TextStyle(
                                color: textColor,
                              ),
                            ),
                            controller: _code,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "- Code will expire in an hour.",
                                style: TextStyle(
                                  color: textColor.withOpacity(.5),
                                ),
                              ),
                              Text(
                                "- Didn't receive a code? Check your spam section, if no email received click `Resend Code`",
                                style: TextStyle(
                                  color: textColor.withOpacity(.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // gradient: LinearGradient(
                            //   colors: [
                            //     _colors.bot,
                            //     _colors.top,
                            //   ],
                            //   begin: Alignment.bottomLeft,
                            //   end: Alignment.topRight,
                            // ),
                            // color: _colors.bot,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Consumer(
                            builder: ((context, ref, child) => MaterialButton(
                                  height: 60,
                                  color: purplePalette,
                                  onPressed: () async {
                                    if (_kCodeForm.currentState!.validate()) {
                                      final UserModel? c =
                                          ref.watch(currentUser);
                                      if (c == null) return;
                                      assert(__code != "");
                                      await validateEmailCode(c.email, __code!);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Verify",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            // child:,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading) ...{
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(.5),
                child: Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    gaplessPlayback: true,
                    isAntiAlias: true,
                    width: context.csize!.width * .4,
                    fit: BoxFit.fitWidth,
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .rotate(duration: 2000.ms),
                ),
              ),
            )
          }
        ],
      ),
    );
  }
}
