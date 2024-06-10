import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/widget/image_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageAsMarker extends StatefulWidget {
  const ImageAsMarker({
    super.key,
    required this.fullname,
    required this.networkImage,
  });
  final String? networkImage;
  final String fullname;
  @override
  State<ImageAsMarker> createState() => _ImageAsMarkerState();
}

class _ImageAsMarkerState extends State<ImageAsMarker> with ColorPalette {
  @override
  Widget build(BuildContext context) {
    print("IMAGE: ${widget.networkImage}");
    return Container(
      height: 65,
      width: 65,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            child: SvgPicture.asset(
              "assets/icons/location.svg",
              color: purplePalette,
              height: 65,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 11,
            child: CustomImageBuilder(
              avatar: widget.networkImage,
              placeHolderName: widget.fullname[0],
              size: 40,
            ),
          ),
        ],
      ),
    );
    // return Container(
    //   padding: const EdgeInsets.all(10),
    //   color: purplePalette,
    // child: CustomImageBuilder(
    //   avatar: widget.networkImage,
    //   placeHolderName: widget.fullname,
    //   size: 30,
    // ),
    // );
  }
}
