import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/auth/kyc_helper.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/custom_scrollable_stepper.dart';
import 'package:able_me/models/custom_scrollable_step.dart';
import 'package:able_me/models/id_callback.dart';
import 'package:able_me/views/authentication/kyc_children/upload_id.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class KYCPage extends StatefulWidget {
  const KYCPage({super.key});

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> with ColorPalette, KYCHelper {
  final GlobalKey<CustomScrollableStepperState> _kStepperState =
      GlobalKey<CustomScrollableStepperState>();
  final GlobalKey<UploadIdPageState> _kUploadPage =
      GlobalKey<UploadIdPageState>();
  IDCallback? idcard;
  String? selfie;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: context.csize!.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            color: purplePalette, fontWeight: FontWeight.w700),
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
    );
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
          content: UploadIdPage(
            key: _kUploadPage,
            callback: (IDCallback callback) async {
              _kStepperState.currentState!.validate(0);
              idcard = callback;
              if (mounted) setState(() {});
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
          content: Container(),
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
          content: Container(),
          // content: GoToVerifyEmailPage(
          //   callback: () async {
          //     // _cacher.seUserToken();
          //   },
          // ),
        ),
      ];
}
