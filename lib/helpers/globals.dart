import 'package:flutter/material.dart';

Widget logo(width) => Image.asset(
      "assets/images/logo.png",
      gaplessPlayback: true,
      isAntiAlias: true,
      width: width,
      fit: BoxFit.fitWidth,
    );
