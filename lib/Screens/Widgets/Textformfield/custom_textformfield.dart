import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final double? width;
  final double? height;
  final bool? fill;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final Color? hintTextColor;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType? textInputType;
  final double? borderRadius;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final bool obscureText;

  MyTextFormField({
    Key? key,
    this.textInputType,
    this.prefixIcon,
    this.fill,
    this.onTap,
    this.width,
    this.height,
    this.controller,
    this.fillColor,
    this.suffixIcon,
    this.isPassword = false,
    this.validator,
    required this.hintText,
    this.hintTextColor,
    this.hintStyle,
    this.contentPadding,
    this.borderRadius,
    this.obscureText = false,
    required Null Function(dynamic value) onSaved,
  }) : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.textInputType,
      onTap: widget.onTap,
      validator: widget.validator,
      controller: widget.controller,
      cursorColor: const Color(0xFF92929292),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 6.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        prefixIcon: widget.prefixIcon,
        hintStyle: widget.hintStyle,
        hintText: widget.hintText,
        contentPadding:
            widget.contentPadding ?? EdgeInsets.fromLTRB(15, 13, 0, 13),
        filled: widget.fill ?? true,
        fillColor: widget.fillColor ?? Color(0xFFF2F2F7),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 6.r),
          borderSide: BorderSide(color: Colors.transparent, width: 0.5.w),
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 19.29.w),
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              )
            : widget.suffixIcon,
      ),
    );
  }
}
