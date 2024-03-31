import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(this.name,
      {Key? key,
      this.color,
      this.size,
      this.fontweight,
      this.textalign = TextAlign.start,
      this.style})
      : super(key: key);

  final String name;
  final Color? color;
  final double? size;
  final FontWeight? fontweight;
  final TextAlign textalign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: 5,
      style: style ??
          TextStyle(
            color: color ?? Colors.black,
            fontSize: size ?? 15,
            fontWeight: fontweight ?? FontWeight.normal,
          ),
      softWrap: true,
      textAlign: textalign,
    );
  }
}
