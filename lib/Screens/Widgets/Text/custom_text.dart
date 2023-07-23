import 'package:flutter/material.dart';

class ReusableText extends StatelessWidget {
  final String? text;
  final TextStyle? style;
  final int? maxlines;
  final double? letterSpacing;
  final TextOverflow? textOverflow;

  const ReusableText({
    super.key,
    required this.text,
    required this.style,
    this.maxlines,
    this.textOverflow,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      maxLines: maxlines,
      style: style!,
      //  overflow: textOverflow!,
    );
  }
}
