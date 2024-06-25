import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/views/landing_page/children/blogs_page_components/blogs_lisitng.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class MainBlogPage extends ConsumerStatefulWidget {
  const MainBlogPage({super.key});

  @override
  ConsumerState<MainBlogPage> createState() => _MainBlogPageState();
}

class _MainBlogPageState extends ConsumerState<MainBlogPage> {
  final String date = DateFormat('EEEE, dd MMMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              title: Text(date),
              titleTextStyle: TextStyle(
                color: textColor,
                fontSize: 13,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w400,
              ),
              subtitle: const Text("Blogs/News"),
              subtitleTextStyle: TextStyle(
                color: textColor,
                fontSize: 22,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
              ),
              trailing: _udata == null
                  ? Container()
                  : GestureDetector(
                      onTap: () => context.push('/profile-page'),
                      child: CustomImageBuilder(
                        avatar: _udata.avatar,
                        placeHolderName: _udata.name[0].toUpperCase(),
                      ),
                    ),
            ),
          ),
          const BlogsListing(),
        ],
      ),
    );
  }
}
