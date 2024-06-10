import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';

class WheelChairFriendly extends StatefulWidget {
  const WheelChairFriendly(
      {super.key, required this.onChange, this.initState = true});
  final bool initState;
  final ValueChanged<bool> onChange;
  @override
  State<WheelChairFriendly> createState() => _WheelChairFriendlyState();
}

class _WheelChairFriendlyState extends State<WheelChairFriendly>
    with ColorPalette {
  late bool wheelChairFriendly = widget.initState;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Wheelchair Friendly",
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
        Switch.adaptive(
            activeTrackColor: purplePalette,
            value: wheelChairFriendly,
            // trackColor: purplePalette,
            // activeColor: purplePalette,
            onChanged: (o) {
              setState(() {
                wheelChairFriendly = o;
              });
            })
      ],
    );
  }
}
