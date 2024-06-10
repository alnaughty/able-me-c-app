import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class CountController extends ConsumerStatefulWidget {
  const CountController({
    super.key,
    required this.onCount,
    this.initCount = 1,
  });
  final ValueChanged<int> onCount;
  final int initCount;
  @override
  ConsumerState<CountController> createState() => _CountControllerState();
}

class _CountControllerState extends ConsumerState<CountController> {
  late int count = widget.initCount;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final bool isDarkMode = ref.watch(darkModeProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isDarkMode ? bgColor.lighten() : bgColor.darken(),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              elevation: 0,
              onPressed: () {
                if (count > 1) {
                  setState(() {
                    count--;
                  });
                  widget.onCount(count);
                }
              },
              child: Center(
                child: Text(
                  "-",
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
          const Gap(5),
          Text(count.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 15,
              )),
          const Gap(5),
          SizedBox(
            width: 30,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              color: Colors.transparent,
              elevation: 0,
              onPressed: () {
                setState(() {
                  count++;
                });
                widget.onCount(count);
              },
              child: Center(
                child: Text(
                  "+",
                  style: TextStyle(
                    fontSize: 17,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
