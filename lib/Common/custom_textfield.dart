import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../utils/color_file.dart';
import '../utils/constant_file.dart';
import 'custom_text.dart';

class TextFieldNotifier extends ChangeNotifier {
  String _errorText = '';
  bool _isFocused = false;
  bool _obscureText = false;

  String get errorText => _errorText;

  bool get isFocused => _isFocused;

  bool get obscureText => _obscureText;

  void setErrorText(String error) {
    _errorText = error;
    notifyListeners();
  }

  void setFocus(bool focus) {
    _isFocused = focus;
    notifyListeners();
  }

  void toggleObscureText() {
    _obscureText = !_obscureText;
    notifyListeners();
  }

  void setInitialObscureText(bool value) {
    _obscureText = value;
    notifyListeners();
  }
}

class CustomTextField extends StatelessWidget {
  final double height;
  final TextEditingController tEController;
  final TextInputType textInputType;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Widget? preIcon;
  final Function()? onTap;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatter;
  final bool isReadOnly;
  final EdgeInsetsGeometry? contentPadding;
  final String hintText, title;
  final int? minLines, maxLines, maxLength;
  final bool isMandatory, isEnabled, isBorderLess, isExpand;
  final String? Function(String)? validator;
  final Color? borderColor, textFieldColor;
  final String? externalErrorText;

  const CustomTextField(
    this.hintText,
    this.tEController, {
    this.textInputType = TextInputType.text,
    this.isMandatory = false,
    this.isEnabled = true,
    this.isBorderLess = false,
    this.title = '',
    this.height = 40.0,
    this.labelText,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.preIcon,
    this.onTap,
    this.onChange,
    this.isReadOnly = false,
    this.isExpand = false,
    this.contentPadding,
    this.inputFormatter,
    this.validator,
    this.borderColor,
    this.textFieldColor,
    this.obscureText,
    this.externalErrorText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TextFieldNotifier>(
      create: (_) => TextFieldNotifier(),
      child: _CustomTextFieldInternal(
        hintText,
        tEController,
        textInputType: textInputType,
        isMandatory: isMandatory,
        isEnabled: isEnabled,
        isBorderLess: isBorderLess,
        title: title,
        height: height,
        labelText: labelText,
        minLines: minLines,
        maxLines: maxLines,
        maxLength: maxLength,
        suffixIcon: suffixIcon,
        preIcon: preIcon,
        onTap: onTap,
        onChange: onChange,
        isReadOnly: isReadOnly,
        isExpand: isExpand,
        contentPadding: contentPadding,
        inputFormatter: inputFormatter,
        validator: validator,
        borderColor: borderColor,
        textFieldColor: textFieldColor,
        obscureText: obscureText,
        externalErrorText: externalErrorText,
      ),
    );
  }
}

class _CustomTextFieldInternal extends StatefulWidget {
  final double height;
  final TextEditingController tEController;
  final TextInputType textInputType;
  final String? labelText;
  final Widget? suffixIcon;
  final bool? obscureText;
  final Widget? preIcon;
  final Function()? onTap;
  final Function(String)? onChange;
  final List<TextInputFormatter>? inputFormatter;
  final bool isReadOnly;
  final EdgeInsetsGeometry? contentPadding;
  final String hintText, title;
  final int? minLines, maxLines, maxLength;
  final bool isMandatory, isEnabled, isBorderLess, isExpand;
  final String? Function(String)? validator;
  final Color? borderColor, textFieldColor;
  final String? externalErrorText;

  const _CustomTextFieldInternal(
    this.hintText,
    this.tEController, {
    this.textInputType = TextInputType.text,
    this.isMandatory = false,
    this.isEnabled = true,
    this.isBorderLess = false,
    this.title = '',
    this.height = 40.0,
    this.labelText,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.suffixIcon,
    this.preIcon,
    this.onTap,
    this.onChange,
    this.isReadOnly = false,
    this.isExpand = false,
    this.contentPadding,
    this.inputFormatter,
    this.validator,
    this.borderColor,
    this.textFieldColor,
    this.obscureText,
    this.externalErrorText,
  });

  @override
  State<_CustomTextFieldInternal> createState() => _CustomTextFieldInternalState();
}

class _CustomTextFieldInternalState extends State<_CustomTextFieldInternal> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.obscureText != null) {
        Provider.of<TextFieldNotifier>(context, listen: false).setInitialObscureText(widget.obscureText!);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _handleTextChange(String value, TextFieldNotifier notifier) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onChange?.call(value);
      // Don't override externalErrorText; it's already controlled externally
      if (widget.externalErrorText == null) {
        final error = widget.validator?.call(value);
        notifier.setErrorText(error ?? '');
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    return Consumer<TextFieldNotifier>(
      builder: (context, notifier, _) {
        final String effectiveErrorText = widget.externalErrorText != null
            ? widget.externalErrorText!
            : notifier.errorText;

        return Semantics(
          label: widget.hintText,
          tooltip: widget.hintText,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.title.isNotEmpty)
                Row(
                  children: [
                    CustomText(widget.title, fontSize: 14, color: ColorFile.blackColor, fontFamily: ConstantsFile.regularFont),
                    if (widget.isMandatory) _mandatoryIndicator(),
                  ],
                ),
              if (widget.title.isNotEmpty) SizedBox(height: 4.0),
              Focus(
                onFocusChange: (focused) {
                  notifier.setFocus(focused);
                  if (!focused && widget.externalErrorText == null) {
                    final error = widget.validator?.call(widget.tEController.text);
                    notifier.setErrorText(error ?? '');
                  }
                },
                child: Container(
                  decoration: _getBoxDecoration(notifier.isFocused, effectiveErrorText, widget.isBorderLess),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: widget.height,
                        child: TextField(
                          cursorColor: ColorFile.primaryColor,
                          expands: widget.isExpand,
                          onChanged: (value) => _handleTextChange(value, notifier),
                          controller: widget.tEController,
                          keyboardType: widget.textInputType,
                          enabled: widget.isEnabled,
                          obscureText: notifier.obscureText,
                          inputFormatters: widget.inputFormatter,
                          minLines: widget.minLines,
                          maxLines: widget.isExpand ? null : widget.maxLines,
                          onTap: widget.onTap,
                          readOnly: widget.isReadOnly,
                          autocorrect: false,
                          style: TextStyle(fontSize: 14, color: widget.isEnabled ? ColorFile.blackColor : ColorFile.greyColor),
                          decoration: InputDecoration(
                            fillColor: ColorFile.whiteColor,
                            border: InputBorder.none,
                            icon: widget.preIcon,
                            suffixIcon:
                                widget.obscureText == true
                                    ? IconButton(
                                      onPressed: notifier.toggleObscureText,
                                      icon: Icon(notifier.obscureText ? Icons.visibility_off : Icons.visibility),
                                    )
                                    : widget.suffixIcon,
                            counterText: '',
                            hintText: widget.hintText,
                            labelStyle: TextStyle(fontSize: 14, color: ColorFile.blackColor),
                            hintStyle: TextStyle(fontSize: 14, color: ColorFile.greyColor),
                            contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            isDense: true,
                          ),
                          maxLength: widget.maxLength,
                        ),
                      ),
                      if (effectiveErrorText.isNotEmpty) _errorTextWidget(effectiveErrorText),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _mandatoryIndicator() {
    return Text(' *', style: TextStyle(fontSize: 14, color: ColorFile.redColor));
  }

  Widget _errorTextWidget(String errorText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      width: double.infinity,
      color: ColorFile.redColor,
      child: Text(errorText, style: TextStyle(fontSize: 12, color: ColorFile.whiteColor)),
    );
  }

  BoxDecoration _getBoxDecoration(bool isFocused, String effectiveErrorText, bool isBorderLess) {
    final BorderSide outlineBorderSide = BorderSide(
      color: widget.borderColor ?? (isFocused ? ColorFile.primaryColor : ColorFile.greyColor),
    );
    final BorderSide errorBorderSide = BorderSide(color: ColorFile.redColor);

    final double borderWidth = effectiveErrorText.isNotEmpty ? 2.0 : (isFocused ? 1.5 : 1.0);
    final BoxBorder border = Border.all(
      color: effectiveErrorText.isNotEmpty ? errorBorderSide.color : outlineBorderSide.color,
      width: borderWidth,
    );

    return isBorderLess
        ? const BoxDecoration()
        : BoxDecoration(
          color: widget.textFieldColor ?? ColorFile.whiteColor,
          border: border,
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
        );
  }
}
