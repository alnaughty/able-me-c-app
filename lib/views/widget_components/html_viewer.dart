import 'dart:convert';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/utils/custom_html_helper.dart';
import 'package:able_me/utils/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomHtmlViewer extends StatefulWidget {
  const CustomHtmlViewer({
    super.key,
    required this.html,
  });
  final String html;
  @override
  State<CustomHtmlViewer> createState() => CustomHtmlViewerState();
}

class CustomHtmlViewerState extends State<CustomHtmlViewer>
    with Launcher, HtmlHelper, ColorPalette {
  // ignore: unnecessary_string_interpolations
  late String htmlData = widget.html;
  // void changeMultiplier(double ff) {
  //   multiplier = ff;

  //   if (mounted) setState(() {});
  // }

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.fromDetails) {
    //     // changeMultiplier(.6);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Size size = MediaQuery.of(context).size;
    // late final stringHtml =
    //     "&lt;body style=&quot;color:#${accent.toHex()};&quot;&gt;${widget.html}&lt;/body&gt;";
    return Html(
      shrinkWrap: true,
      data: htmlData,
      onLinkTap: (s, rc, m, e) async {
        if (s != null) {
          await launch(s);
        }
      },
      // customRenders: {
      //   (node) {
      //     return false;
      //   }: CustomRender.widget(widget: widget)
      // },
      // onImageTap: (s, rc, m, e) async {
      //   if (s != null) {
      //     await showGeneralDialog(
      //       context: context,
      //       transitionBuilder: (_, a1, a2, widget) {
      //         return Transform.scale(
      //           scale: a1.value,
      //           child: Opacity(
      //             opacity: a1.value,
      //             child: SizedBox(
      //               width: size.width,
      //               height: size.height,
      //               child: GestureDetector(
      //                 onTap: () {
      //                   Navigator.of(context).pop();
      //                 },
      //                 child: Image.memory(
      //                   base64.decode(s),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         );
      //       },
      //       transitionDuration: const Duration(milliseconds: 200),
      //       barrierDismissible: true,
      //       barrierLabel: '',
      //       pageBuilder: (context, animation1, animation2) => Container(),
      //     );
      //   }
      // },
      style: htmlStyle(context,
          textColor: textColor, purplePalette: purplePalette),
      onCssParseError: (String f, message) {
        Fluttertoast.showToast(msg: "Erreur sur le CSS");
        return "";
      },
    );
  }
}
