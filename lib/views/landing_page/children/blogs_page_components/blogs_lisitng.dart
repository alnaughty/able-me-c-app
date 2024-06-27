import 'package:able_me/helpers/color_ext.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/blogs/blog_model.dart';
import 'package:able_me/view_models/notifiers/blogs_notifier.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlogsListing extends ConsumerStatefulWidget {
  const BlogsListing({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogsListingState();
}

class _BlogsListingState extends ConsumerState<BlogsListing> {
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final data = ref.watch(blogListingProvider);
    final bool isDarkMode = ref.watch(darkModeProvider);
    return data.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Text(
                "NO DATA",
                style: TextStyle(color: textColor),
              ),
            );
          }
          return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, i) {
                final BlogModel blog = data[i];
                return InkWell(
                  onTap: () {
                    context.push('/blog/${blog.id}');
                  },
                  child: SizedBox(
                    width: context.csize!.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (blog.featuredPhoto != null) ...{
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20)),
                            child: CachedNetworkImage(
                              imageUrl: blog.featuredPhoto!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // const Gap(20),
                        },
                        Container(
                          padding: blog.featuredPhoto == null
                              ? null
                              : const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: blog.featuredPhoto == null
                                  ? null
                                  : !isDarkMode
                                      ? bgColor.darken().withOpacity(.5)
                                      : bgColor.lighten(),
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(20))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                blog.title.capitalizeWords(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  height: 1.1,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Gap(10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined,
                                            size: 15,
                                            color: textColor.withOpacity(.5)),
                                        const Gap(5),
                                        Text(
                                          blog.publishedOn.formatTimeAgo,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: textColor.withOpacity(.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          ImageIcon(
                                            const AssetImage(
                                                'assets/icons/like.png'),
                                            color: textColor.withOpacity(.5),
                                            size: 15,
                                          ),
                                          const Gap(5),
                                          Text(
                                            blog.likes.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: textColor.withOpacity(.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Gap(10),
                                      Row(
                                        children: [
                                          ImageIcon(
                                            const AssetImage(
                                                'assets/icons/chat.png'),
                                            color: textColor.withOpacity(.5),
                                            size: 15,
                                          ),
                                          const Gap(5),
                                          Text(
                                            blog.comments.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: textColor.withOpacity(.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, i) => Divider(
                    color: textColor.withOpacity(.3),
                  ),
              itemCount: data.length);
        },
        error: (err, s) => Container(),
        loading: () => SizedBox(
              width: context.csize!.width,
              height: context.csize!.height,
              child: const FullScreenLoader(
                showText: false,
                size: 60,
              ),
            ));
  }
}
