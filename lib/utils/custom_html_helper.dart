import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

mixin class HtmlHelper {
  Map<String, Style> htmlStyle(context,
      {required Color textColor, required Color purplePalette}) {
    final Style style = Style(
      backgroundColor: Colors.transparent,
      color: textColor,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      fontWeight: FontWeight.w500,
      // maxLines: maxLines,
      // textAlign: textAlign,
      // fontSize: FontSize(14 * fontMultiplier),
      fontFamily: "Montserrat",
      fontFeatureSettings: [
        const FontFeature.caseSensitiveForms(),
      ],
    );
    return {
      "a": style.copyWith(
        margin: const EdgeInsets.all(0),
        fontWeight: FontWeight.w700,
        padding: const EdgeInsets.all(0),
        textDecoration: TextDecoration.underline,
        fontStyle: FontStyle.italic,
        color: purplePalette,
      ),
      "body": style,
      "strong": style.copyWith(
        fontWeight: FontWeight.bold,
      ),
      "em": style.copyWith(
        fontStyle: FontStyle.italic,
      ),
      "b": style.copyWith(
        fontSize: const FontSize(1),
      ),
      "p": style,
      "h1": style.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: const FontSize(34),
      ),
      "h2": style.copyWith(
          fontSize: const FontSize((30)), fontWeight: FontWeight.w700),
      "h3": style.copyWith(
          fontSize: const FontSize(21), fontWeight: FontWeight.w700),
      "h4": style.copyWith(
          fontSize: const FontSize(18), fontWeight: FontWeight.w700),
      "h5": style.copyWith(
          fontSize: const FontSize(16), fontWeight: FontWeight.w700),
      "h6": style.copyWith(
          fontSize: const FontSize(14.5), fontWeight: FontWeight.w700),
      "span": style,
    };
  }
}
