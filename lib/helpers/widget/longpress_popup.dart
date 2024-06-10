import 'package:flutter/material.dart';

class LongPressPopupWidget extends StatefulWidget {
  @override
  _LongPressPopupWidgetState createState() => _LongPressPopupWidgetState();
}

class _LongPressPopupWidgetState extends State<LongPressPopupWidget> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showPopup(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Image.network(
              'https://via.placeholder.com/150',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
