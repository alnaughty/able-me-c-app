import 'package:able_me/app_config/palette.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class SuggestedDriverPage extends StatelessWidget with ColorPalette {
  SuggestedDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Row(children: [
              const Gap(15),
              Text(
                "Driver(s) Near You",
                style: fontTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ]),
            TextButton(onPressed: () {}, child: const Text("View All")),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) => Card(
                    child: ListTile(
                      onTap: () {},
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      subtitle: const Text(
                        "6 Bexley Place,Canberra, 4212, Australia",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitleTextStyle: fontTheme.bodySmall,
                      title: const Text("John F. Doe"),
                      titleTextStyle: fontTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.black.withOpacity(.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (_, i) => const Gap(5),
              itemCount: 4),
          // child: Column(
          //   children: List.generate(5, (index) => Li),
          // ),
        ),
      ],
    );
  }
}
