import 'package:flutter/material.dart';
import '../Text/custom_text.dart';

class MyButton extends StatelessWidget {
  final OutlinedBorder? outlineBorder;
  final double? height;
  final double? width;
  final double? elevation;
  final double? border;
  final String? text;
  final Color? color;
  final TextStyle? mystyle;
  final Color? textColor;
  final Color? backgroundcolor;
  final BoxDecoration? boxDecoration;

  final int? maxLines;
  final void Function()? onPressed;

  MyButton({
    super.key,
    this.outlineBorder,
    this.elevation,
    this.textColor,
    this.height,
    this.width,
    this.border,
    required this.text,
    this.color,
    this.maxLines,
    this.onPressed,
    this.backgroundcolor,
    this.boxDecoration,
    this.mystyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: boxDecoration,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: elevation ?? 5,
            shape: outlineBorder ??
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(border ?? 14.0)),
            backgroundColor: backgroundcolor ??Color(0xffFF9900)),
        child: ReusableText(
          text: text,
          style: mystyle,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
