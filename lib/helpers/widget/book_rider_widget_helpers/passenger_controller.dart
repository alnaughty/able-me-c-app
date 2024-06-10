import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PassengerController extends StatefulWidget {
  const PassengerController({super.key, required this.countCallback});
  final ValueChanged<int> countCallback;
  @override
  State<PassengerController> createState() => _PassengerControllerState();
}

class _PassengerControllerState extends State<PassengerController> {
  int passengerCount = 1;
  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Passenger",
          style: TextStyle(
            color: textColor,
            fontSize: 12,
          ),
        ),
        Row(
          children: [
            MaterialButton(
              onPressed: () {
                if (passengerCount > 1) {
                  passengerCount -= 1;
                  if (mounted) setState(() {});

                  widget.countCallback(passengerCount);
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
              passengerCount.toString(),
              style: TextStyle(
                fontSize: 13,
                color: textColor,
              ),
            ),
            const Gap(20),
            MaterialButton(
              onPressed: () {
                passengerCount += 1;
                if (mounted) setState(() {});
                widget.countCallback(passengerCount);
                // if (passengerCount < rider!.vehicle.seats) {

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
            //       "+",
            //       style: TextStyle(
            //         fontSize: 13,
            //         color: textColor,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
