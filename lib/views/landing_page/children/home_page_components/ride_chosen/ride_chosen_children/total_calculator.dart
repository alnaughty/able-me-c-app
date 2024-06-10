import 'package:able_me/helpers/context_ext.dart';
import 'package:flutter/material.dart';

class TotalCalculatorQuickRide extends StatefulWidget {
  const TotalCalculatorQuickRide({
    super.key,
    required this.distance,
    required this.farePerLuggage,
    required this.farePerPassenger,
    required this.luggages,
    required this.passengers,
  });
  final int luggages;
  final double distance;
  final int passengers;
  final double farePerPassenger;
  final double farePerLuggage;
  @override
  State<TotalCalculatorQuickRide> createState() =>
      _TotalCalculatorQuickRideState();
}

class _TotalCalculatorQuickRideState extends State<TotalCalculatorQuickRide> {
  Widget printer({required String title, required String content}) {
    final Color textColor = context.theme.secondaryHeaderColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    late final double fare = widget.distance * (widget.farePerPassenger);
    late final double luggageFee = widget.farePerLuggage * widget.luggages;
    late final double convenienceFee = ((fare + luggageFee) * .07);
    final Color textColor = context.theme.secondaryHeaderColor;

    return Column(
      children: [
        printer(
          title: "Fare",
          content: "\$${fare.toStringAsFixed(2)}",
        ),
        printer(
          title: "Luggage Fee",
          content: "\$${luggageFee.toStringAsFixed(2)}",
        ),
        printer(
          title: "Convenience Fee",
          content: "\$${convenienceFee.toStringAsFixed(2)}",
        ),
        printer(
          title: "Total",
          content:
              "\$${(fare + luggageFee + convenienceFee).toStringAsFixed(2)}",
        )
      ],
    );
  }
}
