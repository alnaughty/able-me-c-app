import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

class LoginWithSocMed extends StatelessWidget {
  const LoginWithSocMed({super.key, required this.loadingCallback});
  final ValueChanged<bool> loadingCallback;
  Future<void> login() async {
    loadingCallback(true);
    await Future.delayed(3000.ms);
    loadingCallback(false);
  }

  Widget container({required Function() onPressed, required String name}) =>
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color: Colors.black.withOpacity(.3),
          ),
        ),
        child: MaterialButton(
          height: 60,
          onPressed: onPressed,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/${name.toLowerCase()}.png",
                height: 35,
              ),
              const Gap(10),
              Text(
                "Login with $name".toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        container(onPressed: () {}, name: "Facebook")
            .animate()
            .fade(duration: 1000.ms)
            .slideY(duration: 1000.ms, begin: 1, end: 0),
        const Gap(10),
        container(onPressed: () {}, name: "Google")
            .animate()
            .fade(duration: 1500.ms)
            .slideY(duration: 1500.ms, begin: 1, end: 0),
      ],
    );
  }
}
