import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget(
      {super.key,
      this.height = 200,
      required this.images,
      this.fromAsset = false});
  final double height;
  final List<String> images;
  final bool fromAsset;
  static final CarouselController _controller = CarouselController();

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late final List<String> _images = widget.images;
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: widget.height,
      child: FlutterCarousel(
        items: [
          for (int i = 0; i < _images.length; i++) ...{
            Builder(
              builder: (context) => Container(
                width: size.width,
                height: widget.height,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: widget.fromAsset
                    ? Image.asset(
                        _images[i],
                        height: widget.height,
                        width: size.width,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: _images[i],
                        height: widget.height,
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
              ),
            )
            // Align(
            //   alignment: Alignment.center,
            //   child: AnimatedContainer(
            //     alignment: Alignment.center,
            //     duration: 600.ms,
            //     padding: EdgeInsets.symmetric(
            //         horizontal: i == currentIndex ? 20 : 0,
            //         vertical: i != currentIndex ? 30 : 0),
            //     child:
            //   ),
            // ),
          },
        ],
        // items: CarouselWidget._images
        //     .map(
        // (e) => AnimatedContainer(
        //   duration: 100.ms,
        //   padding: const EdgeInsets.symmetric(horizontal: 10),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(10),
        //     child: CachedNetworkImage(
        //       imageUrl: e,
        //       fit: BoxFit.cover,
        //       width: size.width * .95,
        //       alignment: Alignment.topCenter,
        //       height: widget.height,
        //     ),
        //   ),
        // ),
        //     )
        //     .toList(),
        options: CarouselOptions(
          onPageChanged: (i, f) {
            setState(() {
              currentIndex = i;
            });
          },
          initialPage: 0,
          aspectRatio: .9,
          enableInfiniteScroll: false,
          viewportFraction: 1.1,
          autoPlay: true,
          // height: widget.height,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 1200),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          disableCenter: true,
          indicatorMargin: 5,
          showIndicator: false,
          pageSnapping: true,
          scrollDirection: Axis.horizontal,
          pauseAutoPlayOnTouch: true,
          pauseAutoPlayOnManualNavigate: true,
          pauseAutoPlayInFiniteScroll: false,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          controller: CarouselWidget._controller,
          physics: const NeverScrollableScrollPhysics(),
          slideIndicator: CircularWaveSlideIndicator(),
        ),
      ),
      // child: InfiniteCarousel.builder(
      //   itemCount: _images.length,
      //   physics: const PageScrollPhysics(),
      //   itemExtent: size.width,
      //   loop: true,
      //   itemBuilder: (_, i, n) => CachedNetworkImage(
      //     imageUrl: _images[i],
      //     // width: size.width * .95,
      //     fit: BoxFit.cover,
      //   ),
      // ),
      // child: InfiniteCarousel.builder(
      //   itemCount: _images.length,
      //   axisDirection: Axis.horizontal,
      //   itemExtent: size.width * .95,
      //   loop: true,
      //   itemBuilder: (_, i, index) {
      // return CachedNetworkImage(
      //   imageUrl: _images[i],
      //   // width: size.width * .95,
      //   fit: BoxFit.cover,
      // );
      //   },
      // ),
    );
  }
}
