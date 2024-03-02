import 'package:able_me/models/custom_scrollable_step.dart';
import 'package:able_me/views/authentication/kyc_children/upload_id.dart';
import 'package:flutter/material.dart';

mixin class KYCHelper {
  // List<ScrollableStep> steps(Color textColor,
  //         {required ValueChanged<Map<int, dynamic>> dataCallback}) =>
  //     [
  //       ScrollableStep(
  //         subtitle: Text(
  //           "Note: Before you can use our app, the KYC team needs to validate this ID.",
  //           style: TextStyle(
  //             color: textColor,
  //             fontSize: 12,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         title: Text(
  //           "Identification Card",
  //           style: TextStyle(
  //             color: textColor,
  //             fontSize: 12,
  //             fontFamily: "Montserrat",
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         content: UploadIdPage(
  //           key: _kUploadPage,
  //           callback: (FullIDCallback callback) async {
  //             _kStepperState.currentState!.validate(0);
  //             idcard = callback;
  //             if (mounted) setState(() {});
  //             await upload();
  //           },
  //         ),
  //       ),
  //       ScrollableStep(
  //           subtitle: Text(
  //             "Note: Before you can use our app, the KYC team needs to validate your selfie.",
  //             style: TextStyle(
  //               color: textColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           title: Text(
  //             "Selfie",
  //             style: TextStyle(
  //               color: textColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           content: Container()),
  //       ScrollableStep(
  //           subtitle: Text(
  //             "Note: Before you can use our app, the KYC team needs to validate your email.",
  //             style: TextStyle(
  //               color: textColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           title: Text(
  //             "Email Verification",
  //             style: TextStyle(
  //               color: textColor,
  //               fontSize: 12,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           content: Container()),
  //     ];
}
