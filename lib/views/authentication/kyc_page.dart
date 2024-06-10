import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/kyc_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/helpers/widget/custom_scrollable_stepper.dart';
import 'package:able_me/models/custom_scrollable_step.dart';
import 'package:able_me/models/id_callback.dart';
import 'package:able_me/models/kyc_data_model.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/view_models/auth/kyc_provider.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/authentication/kyc_children/upload_id.dart';
import 'package:able_me/views/authentication/kyc_children/upload_selfie.dart';
import 'package:able_me/views/authentication/kyc_children/verify_email.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class KYCPage extends ConsumerStatefulWidget {
  const KYCPage({super.key});

  @override
  ConsumerState<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends ConsumerState<KYCPage>
    with ColorPalette, KYCHelper {
  final GlobalKey<CustomScrollableStepperState> _kStepperState =
      GlobalKey<CustomScrollableStepperState>();
  final GlobalKey<UploadIdPageState> _kUploadPage =
      GlobalKey<UploadIdPageState>();

  final DataCacher _cacher = DataCacher.instance;
  bool isLoading = false;
  IDCallback? idcard;
  String? selfie;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Consumer(
      builder: (context, ref, child) {
        final KYCDataModel? data = ref.watch(kycStatusProvider);
        if (data == null) {
          return Stack(
            children: [
              Positioned.fill(
                child: Scaffold(
                  body: SafeArea(
                    child: SizedBox(
                      width: context.csize!.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Gap(20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  Image.asset(
                                    "assets/images/logo.png",
                                    width: 100,
                                  ),
                                  const Gap(20),
                                  Text(
                                    "Know Your Customer (KYC)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    "Before you can use our application, we would like to get to know you more.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Gap(10),
                                  Text(
                                    "We conduct KYC to ensure our user’s safety and compliance with our terms of use.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: purplePalette,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(30),
                            CustomScrollableStepper(
                              key: _kStepperState,
                              steps: steps(textColor),
                              // uploadCallback: (b) {
                              //   // _kState.currentState!.
                              // },
                            ),
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
                    color: Colors.black.withOpacity(.8),
                    child: const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
              },
            ],
          );
        }
        if (!data.isEmailVerified) {
          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Gap(20),
                    Image.asset(
                      "assets/images/logo.png",
                      width: 100,
                    ),
                    const Gap(20),
                    Text(
                      "Know Your Customer (KYC)",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      "Before you can use our application, we would like to get to know you more.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: GoToVerifyEmailPage(
                        callback: (email) async {
                          print("asdasda");
                          await sendVerificationCode(email);
                          // _cacher.setUserToken(token);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          if (data.status == 0) {
            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 100,
                        ),
                      ),
                      const Gap(20),
                      Consumer(
                        builder: (context, ref1, _) {
                          final UserModel? model = ref1.watch(currentUser);
                          if (model == null) return Container();
                          return Text(
                            "Dear ${model.fullname.capitalizeWords()},",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "We appreciate your cooperation in submitting your KYC information. Please be informed that your verification is currently underway and will be completed within the next 24 hours. We kindly request your patience during this process, and we will promptly notify you of the outcome through email.",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Thank you for your understanding.",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Yours sincerely,",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Able Me Team",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(
                            text:
                                "Do you wanna check if your account is verified by now? ",
                            style: TextStyle(
                              color: textColor.withOpacity(.5),
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: "Restart",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    context.pushReplacement('/');
                                    // await Navigator.pushReplacementNamed(
                                    //   context,
                                    //   "/",
                                    // );
                                  },
                                style: TextStyle(
                                  color: purplePalette,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ]),
                      ),
                      // Text(
                      //   "Do you wanna check if your account have been verified?",

                      // ),
                      // MaterialButton(
                      //   onPressed: () async {
                      // await Navigator.pushReplacementNamed(
                      //   context,
                      //   "/",
                      // );
                      //   },
                      //   color: _colors.top,
                      //   disabledColor: Colors.grey,
                      //   height: 60,
                      //   child: const Center(
                      //     child: Text(
                      //       "Restart",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          } else if (data.status == 2) {
            return Scaffold(
              body: SafeArea(
                bottom: false,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 100,
                        ),
                      ),
                      const Gap(20),
                      Text(
                        "We regret to inform you that your Know Your Customer (KYC) verification has been declined. We kindly request you to upload a higher quality image or provide an alternate document for the verification process.",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 12,
                        ),
                      ),
                      if (data.reason != null) ...{
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          data.reason!,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
            );
          }
        }

        return Container();
      },
      // child: ,
    );
  }

  Future<void> upload() async {
    if (selfie != null && idcard != null) {
      final String? accessToken = _cacher.getUserToken();
      if (accessToken == null) return;
      setState(() {
        isLoading = true;
      });

      await api.validateKYCSelfie(accessToken, selfie!).then((value) {
        print("SELFIE UPLOADED : $value");
      });
      await api.validateKYCIDs(accessToken, idcard!);
      isLoading = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> sendVerificationCode(String email) async {
    final String? accessToken = _cacher.getUserToken();
    if (accessToken == null) return;
    final bool f = await kycApi.sendEmailVerificationCode(accessToken, email);
    if (f) {
      // go to code validation
      // ignore: use_build_context_synchronously
      context.pushReplacementNamed('code-validation', extra: email);
    }
    return;
  }

  List<ScrollableStep> steps(Color textColor) => [
        ScrollableStep(
          subtitle: Text(
            "Note: Before you can use our app, the KYC team needs to validate this ID.",
            style: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          title: Text(
            "Identification Card",
            style: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          // content: SelfieKYCPage(
          //   imageCallback: (String value) {
          //     print("b64 img : $value");
          //   },
          // ),
          content: UploadIdPage(
            key: _kUploadPage,
            callback: (IDCallback callback) async {
              _kStepperState.currentState!.validate(0);
              idcard = callback;
              if (mounted) setState(() {});
              await upload();
              // await upload();
            },
          ),
        ),
        ScrollableStep(
            subtitle: Text(
              "Note: Before you can use our app, the KYC team needs to validate your selfie.",
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
              ),
            ),
            title: Text(
              "Selfie",
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w500,
              ),
            ),
            // content: Container(),
            content: SelfieKYCPage(
              imageCallback: (String value) async {
                _kStepperState.currentState!.validate(1);
                selfie = value;
                if (mounted) setState(() {});
                await upload();
              },
            )
            // content: SelfieKYCPage(
            //   imageCallback: (String f) async {
            //     selfie = f;
            //     if (mounted) setState(() {});
            //     await upload();
            //   },
            // ),
            ),
        ScrollableStep(
          subtitle: Text(
            "Note: Before you can use our app, the KYC team needs to validate your email.",
            style: TextStyle(
              color: textColor,
              fontFamily: "Montserrat",
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          title: Text(
            "Email Verification",
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: "Montserrat",
            ),
          ),
          // content: Container(),
          content: Consumer(
            builder: ((context, ref, child) => GoToVerifyEmailPage(
                  callback: (email) async {
                    print("asdasda");
                    await sendVerificationCode(email);
                    // _cacher.setUserToken(token);
                  },
                )),
          ),
        ),
      ];
}
