import 'package:flutter/material.dart';

class AppText extends StatelessWidget{
  final String text;
  final TextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AppText(this.text,{super.key, required this.style, this.color, this.textAlign, this.overflow, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text( text, style: style.copyWith(color: color), textAlign: textAlign, );
  }
}