import 'dart:ui';

import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/rider_booking/instruction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class AdditionalInstructions extends StatefulWidget {
  const AdditionalInstructions({super.key});
  @override
  State<AdditionalInstructions> createState() => AdditionalInstructionsState();
}

class AdditionalInstructionsState extends State<AdditionalInstructions>
    with ColorPalette {
  List<Instruction> _instructions = [];
  List<Instruction> get instructions => _instructions;
  late final TextEditingController _title;
  late final TextEditingController _descr;
  @override
  void initState() {
    // TODO: implement initState
    _title = TextEditingController();
    _descr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _title.dispose();
    _descr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.theme.secondaryHeaderColor;
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: textColor.withOpacity(.3),
        ),
        const Gap(10),
        Text(
          "Additional Instructions",
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "Only provide if necessary, this is only optional",
          style: TextStyle(
            fontSize: 12,
            color: purplePalette,
          ),
        ),
        if (_instructions.isNotEmpty) ...{
          const Gap(10),
          ListView.separated(
              padding: const EdgeInsets.all(0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    trailing: InkWell(
                        onTap: () {
                          _instructions.removeAt(i);
                          if (mounted) setState(() {});
                        },
                        child: Icon(
                          Icons.close,
                          color: purplePalette,
                        )),
                    tileColor: bgColor.lighten().withOpacity(.5),
                    // contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.info_outline,
                      color: textColor,
                    ),
                    title: Text(
                      _instructions[i].title.capitalizeWords(),
                    ),
                    titleTextStyle: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    subtitle: Text(instructions[i].description),
                    subtitleTextStyle: TextStyle(
                      color: textColor.withOpacity(.5),
                    ),
                  ),
              separatorBuilder: (_, i) => const Gap(10),
              itemCount: _instructions.length),
          // ignore: equal_elements_in_set
          const Gap(10)
        },
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 45),
              child: TextField(
                controller: _title,
                cursorHeight: 20,
                cursorOpacityAnimates: true,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
                decoration: InputDecoration(
                  fillColor: bgColor.lighten(),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  alignLabelWithHint: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: purplePalette,
                    ),
                  ),
                  hintText: "Enter title",
                  labelText: "Title",
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(.5),
                    fontSize: 13,
                  ),
                  labelStyle:
                      TextStyle(color: textColor.withOpacity(.5), fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: textColor,
                  )),
                ),
              ),
            ),
            const Gap(10),
            TextField(
              controller: _descr,
              cursorHeight: 20,
              cursorOpacityAnimates: true,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                fillColor: bgColor.lighten(),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                alignLabelWithHint: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: purplePalette,
                  ),
                ),
                hintText: "Enter description",
                hintStyle: TextStyle(
                  color: textColor.withOpacity(.5),
                  fontSize: 13,
                ),
                labelText: "Description",
                labelStyle:
                    TextStyle(color: textColor.withOpacity(.5), fontSize: 12),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: textColor,
                )),
              ),
            ),
            const Gap(10),
            MaterialButton(
              onPressed: _descr.text.isEmpty || _title.text.isEmpty
                  ? null
                  : () {
                      if (_descr.text.isEmpty || _title.text.isEmpty) return;
                      _instructions.add(
                        Instruction(
                            description: _descr.text, title: _title.text),
                      );
                      _descr.clear();
                      _title.clear();
                      if (mounted) setState(() {});
                    },
              disabledColor: Colors.grey,
              height: 40,
              color: purplePalette,
              child: const Center(
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          ],
        ),
        const Gap(10),
        Divider(
          color: textColor.withOpacity(.3),
        ),
      ],
    );
  }
}
