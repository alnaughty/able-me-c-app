import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LuggageController extends StatefulWidget {
  const LuggageController({super.key, required this.countCallback});
  final ValueChanged<int> countCallback;
  @override
  State<LuggageController> createState() => _LuggageControllerState();
}

class _LuggageControllerState extends State<LuggageController> {
  int luggageCount = 0;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Luggage",
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            MaterialButton(
              onPressed: () {
                if (luggageCount > 0) {
                  luggageCount -= 1;
                  if (mounted) setState(() {});
                  widget.countCallback(luggageCount);
                }
              },
              height: 30,
              minWidth: 30,
              color: bgColor.lighten(),
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //       horizontal: 10, vertical: 5),
            //   decoration: BoxDecoration(
            //       color: bgColor.lighten(),
            //       borderRadius: BorderRadius.circular(2)),
            //   child: InkWell(
            //     onTap: () {

            //     },
            //     child: Text(
            //       "-",

            //     ),
            //   ),
            // ),
            const Gap(20),
            Text(
              luggageCount.toString(),
              style: TextStyle(
                fontSize: 13,
                color: textColor,
              ),
            ),
            const Gap(20),
            MaterialButton(
              onPressed: () {
                // if (luggageCount < rider!.vehicle.seats) {
                luggageCount += 1;
                if (mounted) setState(() {});
                widget.countCallback(luggageCount);
                // }
              },
              height: 30,
              minWidth: 30,
              color: bgColor.lighten(),
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
