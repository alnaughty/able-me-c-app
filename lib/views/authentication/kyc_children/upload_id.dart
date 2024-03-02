import 'dart:convert';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/image_processor.dart';
import 'package:able_me/models/id_callback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class UploadIdPage extends StatefulWidget {
  const UploadIdPage({super.key, required this.callback});
  final ValueChanged<IDCallback> callback;
  @override
  State<UploadIdPage> createState() => UploadIdPageState();
}

class UploadIdPageState extends State<UploadIdPage> with ColorPalette {
  final ImageProcessor _image = ImageProcessor.instance;
  final List<String> validIds = [
    "Driver's License",
    "Passport",
    "Professional Regulation Commission (PRC) ID",
    "Disability Card",
    "SSS ID",
    "Postal ID",
  ];
  String? type;
  String? frontIdImage;
  Widget? frontChosenImage;

  String? backIdImage;
  Widget? backChosenImage;

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;

    return LayoutBuilder(builder: (context, c) {
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            width: c.maxWidth,
            padding:
                const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color:
                    (context.isDarkMode ? bgColor.lighten() : bgColor.darken())
                        .withOpacity(.5),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: textColor,
                )),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                dropdownColor: bgColor.darken(),
                focusColor: textColor,
                isExpanded: true,
                onChanged: (String? f) {
                  setState(() {
                    type = f;
                  });
                },
                hint: Text(
                  "Choose ID Type",
                  style: TextStyle(color: textColor.withOpacity(.5)),
                ),
                // selectedItemBuilder: (_) => [Text("ASDASD")],
                items: validIds
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    )
                    .toList(),
                value: type,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MaterialButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                barrierColor: Colors.black.withOpacity(.5),
                isDismissible: true,
                useSafeArea: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),
                // ),
                // constraints: const BoxConstraints(
                //   maxHeight: 180,
                // ),
                builder: (_) => SafeArea(
                  top: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: bgColor),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            onTap: () async {
                              await _image
                                  .pickImage(ImageSource.gallery)
                                  .then((value) async {
                                if (value == null) return;
                                Navigator.of(context).pop(null);
                                frontIdImage = value;
                                frontChosenImage = ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(frontIdImage!),
                                  ),
                                );
                                if (mounted) setState(() {});
                              });
                            },
                            leading: Icon(
                              CupertinoIcons.photo,
                              color: textColor,
                            ),
                            title: const Text("Gallery"),
                            titleTextStyle: TextStyle(
                              fontFamily: "Montserrat",
                              color: textColor,
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              await _image
                                  .pickImage(ImageSource.camera)
                                  .then((value) async {
                                if (value == null) return;
                                Navigator.of(context).pop(null);
                                frontIdImage = value;
                                frontChosenImage = ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    base64Decode(frontIdImage!),
                                  ),
                                );
                                if (mounted) setState(() {});
                              });
                            },
                            leading: Icon(
                              CupertinoIcons.camera,
                              color: textColor,
                            ),
                            titleTextStyle: TextStyle(
                              color: textColor,
                              fontFamily: "Montserrat",
                            ),
                            title: const Text("Camera"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            color: context.isDarkMode ? bgColor.lighten() : bgColor.darken(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // width: c.maxWidth,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(5),
            // ),
            padding: frontChosenImage == null
                ? const EdgeInsets.symmetric(vertical: 35, horizontal: 0)
                : EdgeInsets.zero,
            child: Center(
              child: frontChosenImage ??
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/id.svg",
                        width: 80,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFB5AEAE),
                          BlendMode.srcATop,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Upload a picture of your ID (Front)",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          MaterialButton(
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                barrierColor: Colors.black.withOpacity(.5),
                isDismissible: true,
                useSafeArea: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(20),
                // ),
                // constraints: const BoxConstraints(
                //   maxHeight: 180,
                // ),
                builder: (_) => SafeArea(
                  top: false,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: bgColor),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ListTile(
                            onTap: () async {
                              await _image
                                  .pickImage(ImageSource.gallery)
                                  .then((value) async {
                                if (value == null) return;
                                Navigator.of(context).pop(null);
                                setState(() {
                                  backIdImage = value;
                                  backChosenImage = ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      base64Decode(backIdImage!),
                                    ),
                                  );
                                });
                              });
                            },
                            titleTextStyle: TextStyle(
                              color: textColor,
                              fontFamily: "Montserrat",
                            ),
                            leading: Icon(
                              CupertinoIcons.photo,
                              color: textColor,
                            ),
                            title: const Text("Gallery"),
                          ),
                          ListTile(
                            onTap: () async {
                              await _image
                                  .pickImage(ImageSource.camera)
                                  .then((value) async {
                                if (value == null) return;
                                Navigator.of(context).pop(null);
                                setState(() {
                                  backIdImage = value;
                                  backChosenImage = ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      base64Decode(backIdImage!),
                                    ),
                                  );
                                });
                              });
                            },
                            titleTextStyle: TextStyle(
                              color: textColor,
                              fontFamily: "Montserrat",
                            ),
                            leading: Icon(
                              CupertinoIcons.camera,
                              color: textColor,
                            ),
                            title: const Text("Camera"),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            color: context.isDarkMode ? bgColor.lighten() : bgColor.darken(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            // width: c.maxWidth,
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(5),
            // ),
            padding: backChosenImage == null
                ? const EdgeInsets.symmetric(vertical: 35, horizontal: 0)
                : EdgeInsets.zero,
            child: Center(
              child: backChosenImage ??
                  Column(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/id.svg",
                        width: 80,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFB5AEAE),
                          BlendMode.srcATop,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Upload a picture of your ID (Back)",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: (type == null ||
                    frontChosenImage == null ||
                    backChosenImage == null)
                ? null
                : () {
                    widget.callback(IDCallback(
                      type: type!,
                      front: frontIdImage!,
                      back: backIdImage!,
                    ));
                  },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: purplePalette,
            disabledColor:
                context.isDarkMode ? bgColor.lighten() : bgColor.darken(),
            height: 60,
            child: Center(
              child: Text(
                "Continue",
                style: TextStyle(
                  color: (!context.isDarkMode
                          ? frontChosenImage == null ||
                                  backChosenImage == null ||
                                  type == null
                              ? textColor
                              : Colors.white
                          : textColor)
                      .withOpacity(frontChosenImage != null &&
                              backChosenImage != null &&
                              type != null
                          ? 1
                          : .5),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SafeArea(
            top: false,
            child: SizedBox(
              height: 10,
            ),
          )
        ],
      );
    });
  }
}
