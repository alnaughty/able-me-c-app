import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

@immutable
class GoToVerifyEmailPage extends StatelessWidget with ColorPalette {
  GoToVerifyEmailPage({super.key, required this.callback});
  final ValueChanged<String> callback;
  // static final AppColors _colors = AppColors.instance;

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "To ensure the safety of our users we would like to validate your email first before using our app.",
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
        ),
        const SizedBox(
          height: 30,
        ),
        Consumer(
          builder: (context, ref, child) {
            final UserModel? loggedUser = ref.watch(currentUser);

            return MaterialButton(
              onPressed: () {
                if (loggedUser == null) return;
                callback(loggedUser.email);
              },
              height: 60,
              color: purplePalette,
              child: const Center(
                child: Text(
                  "Verify Email",
                  // loggedUser!.isEmailVerified ? "Continue" : "Verify Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        )
        // MaterialButton(
        //   onPressed: () async {
        //     // if (loggedUser!.hasVerifiedEmail) {
        //     //   callback();
        //     //   Fluttertoast.showToast(
        //     //       msg: "Please wait for the team to verify your data");
        //     // } else {
        //     //   await Navigator.push(
        //     //     context,
        //     //     PageTransition(
        //     //       child: const VerifyEmailPage(
        //     //         reload: true,
        //     //       ),
        //     //       type: PageTransitionType.rightToLeft,
        //     //     ),
        //     //   );
        //     // }
        //   },
        // height: 60,
        // color: purplePalette,
        //   child: Consumer(
        //     builder: (context, ref, child) {
        //       final UserModel? loggedUser = ref.watch(currentUser);
        //       if (loggedUser == null || child == null) {
        //         return child!;
        //       }
        //       return const Center(
        //         child: Text(
        //           "Continue",
        //           // loggedUser!.hasVerifiedEmail ? "Continue" : "Verify Email",
        //           style: TextStyle(
        //             color: Colors.white,
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),
        //       );
        //     },
        // child: const Center(
        //   child: Text(
        //     "Verify Email",
        //     // loggedUser!.hasVerifiedEmail ? "Continue" : "Verify Email",
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: 16,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        // ),
        //   ),
        // )
      ],
    );
  }
}
