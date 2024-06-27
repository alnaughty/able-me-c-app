import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/blogs/blog_details.dart';
import 'package:able_me/services/api/blogs/blog_api.dart';
import 'package:able_me/utils/url_launcher.dart';
import 'package:able_me/views/widget_components/carousel_widget.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class BlogDetailsPage extends ConsumerStatefulWidget {
  const BlogDetailsPage({super.key, required this.id});
  final int id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends ConsumerState<BlogDetailsPage>
    with ColorPalette, Launcher {
  static final BlogApi _api = BlogApi();
  // final  _apiProvider = Provider<BlogApi>((ref) => BlogApi());
  BlogDetails? _details;

  initPlatform() async {
    await _api.getDetails(widget.id).then((value) {
      if (value == null) {
        context.pop();
        return;
      }
      _details = value;
      if (mounted) setState(() {});
    });
  }

  @override
  void initState() {
    initPlatform();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = context.theme.scaffoldBackgroundColor;
    final Color textColor = context.theme.secondaryHeaderColor;
    final Size size = context.csize!;
    return Scaffold(
      body: _details == null
          ? const Center(
              child: FullScreenLoader(
                size: 120,
                showText: false,
              ),
            )
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: _details!.images.isEmpty
                        ? purplePalette
                        : Colors.transparent,
                    width: size.width,
                    height: _details!.images.isEmpty ? 135 : size.height * .55,
                    child: Stack(
                      children: [
                        if (_details!.images.isNotEmpty) ...{
                          Positioned.fill(
                            child: CarouselWidget(
                              images: _details!.images,
                              height: size.height * .55,
                            ),
                          ),
                        },
                        if (context.canPop() &&
                            _details!.images.isNotEmpty) ...{
                          Positioned(
                              left: 20,
                              child: SafeArea(
                                child: BackButton(
                                  style: ButtonStyle(
                                      minimumSize:
                                          WidgetStateProperty.resolveWith(
                                              (states) => const Size(60, 60)),
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith(
                                              (states) => purplePalette
                                                  .withOpacity(.8)),
                                      shape: WidgetStateProperty.resolveWith(
                                          (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)))),
                                  color: Colors.white,
                                  onPressed: () {
                                    if (context.canPop()) {
                                      context.pop();
                                    }
                                  },
                                ),
                              ))
                        },
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: purplePalette,
                            child: ListTile(
                              leading: _details!.images.isEmpty
                                  ? const BackButton(
                                      color: Colors.white,
                                    )
                                  : null,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: _details!.images.isEmpty ? 0 : 20,
                                  vertical: 10),
                              subtitle: Text(
                                  "Posted ${_details!.publishedOn.formatTimeAgo}"),
                              subtitleTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  fontFamily: "Montserrat"),
                              title: Text(
                                "Author: ${_details!.author.capitalizeWords()}",
                              ),
                              titleTextStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  fontFamily: "Montserrat"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _details?.title ?? "Untitle",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const Gap(10),
                        HtmlWidget(
                          _details!.body,
                          onTapUrl: (url) async {
                            await launchMyUrl(url);
                            return isLaunchable(url);
                          },
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: textColor,
                          ),
                          renderMode: RenderMode.column,
                        ),
                        const Gap(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${_details!.comments == 0 ? "No" : ""} Comments",
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            if (_details!.comments > 0) ...{
                              InkWell(
                                onTap: () {},
                                child: Text("See all ${_details!.comments}"),
                              )
                            }
                          ],
                        )
                      ],
                    ),
                  ),
                  const SafeArea(
                      child: SizedBox(
                    height: 0,
                  ))
                  // SizedBox(
                  //   height: size.height,
                  // )
                ],
              ),
            ),
    );
  }
}
