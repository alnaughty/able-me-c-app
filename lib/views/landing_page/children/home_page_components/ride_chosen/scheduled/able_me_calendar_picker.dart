import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AbleMeCalendarPicker extends StatefulWidget {
  const AbleMeCalendarPicker(
      {super.key, required this.dateCallback, required this.initDate});
  final ValueChanged<DateTime> dateCallback;
  final DateTime initDate;
  @override
  State<AbleMeCalendarPicker> createState() => _AbleMeCalendarPickerState();
}

class _AbleMeCalendarPickerState extends State<AbleMeCalendarPicker>
    with ColorPalette {
  final DateTime minDate = DateTime.now();
  late DateTime datePicked = widget.initDate;
  int get difference {
    // Get the last day of the current month
    DateTime lastDayOfMonth = DateTime(minDate.year, minDate.month + 1, 0);
    print("LAST DAY : $lastDayOfMonth");
    return minDate.subtract(1.days).difference(lastDayOfMonth).inDays;
  }

  late final daysDiff = difference;
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Size size = context.csize!;
    print(daysDiff);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  DateFormat("MMMM dd, yyyy").format(datePicked),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () async {
                    await showDatePicker(
                      context: context,
                      firstDate: widget.initDate,
                      lastDate: DateTime.now().add(30.days),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          datePicked = value;
                        });
                      }
                    });
                  },
                  child: Text(
                    "Open calendar",
                    style: TextStyle(
                      color: purplePalette,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        const Gap(10),
        Consumer(
          builder: (_, ref, c) {
            final bool isDarkMode = ref.watch(darkModeProvider);
            return SizedBox(
              width: double.infinity,
              height: 80,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final bool isActive =
                      datePicked.day == (minDate.day + (i + 1));
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        datePicked = DateTime(
                            minDate.year, minDate.month, minDate.day + (i + 1));
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        width: 75,
                        height: 80,
                        decoration: BoxDecoration(
                            color:
                                isActive ? purplePalette : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: isActive
                                    ? Colors.transparent
                                    : purplePalette)),
                        child: LayoutBuilder(builder: (context, c) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${minDate.day + (i + 1)}",
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                  color:
                                      textColor.withOpacity(isActive ? 1 : 0.5),
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(minDate).toUpperCase(),
                                style: TextStyle(
                                  letterSpacing: 2.5,
                                  color:
                                      textColor.withOpacity(isActive ? 1 : 0.5),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          );
                          // return Column(
                          //   children: [
                          // Container(
                          //   width: c.maxWidth,
                          //   padding:
                          //       const EdgeInsets.symmetric(vertical: 2),
                          //   color: isActive ? Colors.white : purplePalette,
                          //   child: Center(
                          //     child: Text(
                          //       DateFormat('MMMM').format(minDate),
                          //       style: TextStyle(
                          //           color: isActive
                          //               ? purplePalette
                          //               : textColor,
                          //           fontSize: 11,
                          //           fontWeight: FontWeight.w800),
                          //     ),
                          //   ),
                          // ),
                          //     Expanded(
                          //       child: Center(
                          //         child: Text(
                          //           "${minDate.day + (i + 1)}",
                          // style: TextStyle(
                          //   fontSize: 35,
                          //   fontWeight: FontWeight.w800,
                          //   color: textColor
                          //       .withOpacity(isActive ? 1 : 0.5),
                          // ),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // );
                        }),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, i) => const SizedBox(
                  width: 15,
                ),
                itemCount: daysDiff.abs(),
              ),
            );
          },
          // child: ,
        )
      ],
    );
  }
}
