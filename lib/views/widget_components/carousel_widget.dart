import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key, this.height = 200});
  final double height;

  static final CarouselController _controller = CarouselController();

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  static final List<String> _images = [
    "https://i0.wp.com/theablehub.com/wp-content/uploads/2023/03/The-Able-Hub-Alice-Springs-NT-0870-Australia-19.jpg?fit=5344%2C3289&ssl=1",
    "https://i0.wp.com/theablehub.com/wp-content/uploads/2023/07/disability-support-services-australia.jpg?fit=5363%2C3287&ssl=1"
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      // height: widget.height,
      child: Center(
        child: FlutterCarousel(
          items: [
            for (int i = 0; i < _images.length; i++) ...{
              Builder(
                builder: (context) => Container(
                  width: size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: _images[i],
                      fit: BoxFit.cover,
                      // width: size.width * .95,
                      alignment: Alignment.topCenter,
                    ),
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
            aspectRatio: 2,
            enableInfiniteScroll: false,
            viewportFraction: .9,
            autoPlay: true,
            // height: widget.height,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            disableCenter: false,
            indicatorMargin: 5,
            showIndicator: true,
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
