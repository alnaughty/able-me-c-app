import 'package:able_me/app_config/palette.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class PinForm extends StatefulWidget {
  const PinForm(
      {super.key,
      required this.length,
      this.fieldWidth = 30,
      this.keyboardType = TextInputType.number,
      required this.onCompleted,
      this.onChanged,
      this.spaceBetween = 0})
      : assert(length <= 6,
            "PinForm's MAX length is 6, greater value will cause overflow");
  static final GlobalKey<FormState> _kForm = GlobalKey<FormState>();
  final int length;
  final double fieldWidth;
  final double spaceBetween;
  final TextInputType keyboardType;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  @override
  State<PinForm> createState() => _PinFormState();
}

class _PinFormState extends State<PinForm> with ColorPalette {
  late final List<FocusNode?> _focusNodes;
  late final List<TextEditingController?> _textControllers;
  late final List<String> _pin;

  @override
  void initState() {
    super.initState();

    // if (widget.controller != null) {
    //   widget.controller!.setOtpTextFieldState(this);
    // }

    // if (widget.otpFieldStyle == null) {
    //   _otpFieldStyle = OtpFieldStyle();
    // } else {
    //   _otpFieldStyle = widget.otpFieldStyle!;
    // }

    setState(() {
      _focusNodes =
          List<FocusNode?>.filled(widget.length, null, growable: false);
      _textControllers = List<TextEditingController?>.filled(
          widget.length, null,
          growable: false);

      _pin = List.generate(widget.length, (int i) {
        return '';
      });
    });
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  Widget _buildTextField(BuildContext contex, int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? textEditingController = _textControllers[index];

    if (focusNode == null) {
      _focusNodes[index] = FocusNode();
      focusNode = _focusNodes[index];
      focusNode?.addListener((() => handleFocusChange(index)));
    }
    if (textEditingController == null) {
      _textControllers[index] = TextEditingController();
      textEditingController = _textControllers[index];
    }
    final isLast = index == widget.length - 1;
    InputBorder getBorder({Color color = Colors.grey}) => OutlineInputBorder(
          borderSide: BorderSide(color: color),
          borderRadius: BorderRadius.circular(5),
        );
    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0 : widget.spaceBetween,
      ),
      child: TextFormField(
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textCapitalization: TextCapitalization.none,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        autovalidateMode: AutovalidateMode.always,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        style: const TextStyle(
          fontSize: 30,
        ),
        decoration: InputDecoration(
          isDense: false,
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: getBorder(),
          focusedBorder: getBorder(color: greenPalette),
          enabledBorder: getBorder(),
          disabledBorder: getBorder(),
          errorBorder: getBorder(color: Colors.red),
          focusedErrorBorder: getBorder(color: Colors.red),
          errorText: null,
          // to hide the error text
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (String str) {
          if (str.length > 1) {
            _handlePaste(str);
            return;
          }
          // Check if the current value at this position is empty
          // If it is move focus to previous text field.
          if (str.isEmpty) {
            if (index == 0) return;
            _focusNodes[index]!.unfocus();
            _focusNodes[index - 1]!.requestFocus();
          }
          // Update the current pin
          setState(() {
            _pin[index] = str;
          });
          // Remove focus
          if (str.isNotEmpty) _focusNodes[index]!.unfocus();
          // Set focus to the next field if available
          if (index + 1 != widget.length && str.isNotEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }

          String currentPin = _getCurrentPin();
          // if there are no null values that means otp is completed
          // Call the `onCompleted` callback function provided
          if (!_pin.contains(null) &&
              !_pin.contains('') &&
              currentPin.length == widget.length) {
            widget.onCompleted.call(currentPin);
          }
          if (widget.onChanged != null) {
            widget.onChanged!(currentPin);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // _pin = List.generate(widget.length, (int i) {
    //   return '';
    // });
    // _textControllers = List<TextEditingController?>.filled(
    //   widget.length,
    //   null,
    //   growable: false,
    // );
    // _focusNodes = List<FocusNode?>.filled(
    //   widget.length,
    //   null,
    //   growable: false,
    // );
    return Form(
      key: PinForm._kForm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
            widget.length, (index) => _buildTextField(context, index)),
      ),
    );
  }

  void handleFocusChange(int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? controller = _textControllers[index];

    if (focusNode == null || controller == null) return;

    if (focusNode.hasFocus) {
      controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length));
    }
  }

  String _getCurrentPin() {
    String currentPin = "";
    for (var value in _pin) {
      currentPin += value;
    }
    return currentPin;
  }

  void _handlePaste(String str) {
    if (str.length > widget.length) {
      str = str.substring(0, widget.length);
    }

    for (int i = 0; i < str.length; i++) {
      String digit = str.substring(i, i + 1);
      _textControllers[i]!.text = digit;
      _pin[i] = digit;
    }

    FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);

    String currentPin = _getCurrentPin();

    // if there are no null values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains(null) &&
        !_pin.contains('') &&
        currentPin.length == widget.length) {
      widget.onCompleted.call(currentPin);
    }
    if (widget.onChanged != null) {
      widget.onChanged!(currentPin);
    }
    // Call the `onChanged` callback function
    // widget.onChanged!(currentPin);
  }
}
