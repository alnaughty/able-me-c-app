import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/helpers/date_ext.dart';
import 'package:able_me/helpers/string_ext.dart';
import 'package:able_me/models/blogs/blog_details.dart';
import 'package:able_me/services/api/blogs/blog_api.dart';
import 'package:able_me/views/widget_components/carousel_widget.dart';
import 'package:able_me/views/widget_components/full_screen_loader.dart';
import 'package:able_me/views/widget_components/html_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart';

class BlogDetailsPage extends ConsumerStatefulWidget {
  const BlogDetailsPage({super.key, required this.id});
  final int id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends ConsumerState<BlogDetailsPage>
    with ColorPalette {
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
                  SizedBox(
                    width: size.width,
                    height: size.height * .55,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CarouselWidget(
                            images: _details!.images,
                            height: size.height * .55,
                          ),
                        ),
                        if (context.canPop()) ...{
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
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
                    child: CustomHtmlViewer(
                      html: _details!.body,
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
