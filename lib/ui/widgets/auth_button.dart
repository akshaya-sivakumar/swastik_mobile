import 'package:flutter/material.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width, height, fontsize;
  final Color? color, bordercolor, fontColor;
  final FontWeight? fontweight;
  const AuthButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.fontsize,
      this.width,
      this.fontweight,
      this.color,
      this.bordercolor,
      this.height,
      this.fontColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        width: width ?? MediaQuery.of(context).size.width * 0.8,
        height: height ?? MediaQuery.of(context).size.height * 0.06,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: 0.8,
                color: bordercolor ?? Colors.transparent,
              ),
              backgroundColor: color ?? Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.zero // background
              ),
          onPressed: onTap,
          child: TextWidget(
            text,
            color: fontColor ?? Colors.white,
            fontweight: fontweight ?? FontWeight.normal,
            size: fontsize,
          ),
        ) /* Container(
        width: width ?? MediaQuery.of(context).size.width * 0.7,
        height: height ?? MediaQuery.of(context).size.height * 0.06,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: TextWidget(
          text,
          textAlign: TextAlign.center,
          color: Colors.white,
        ),
      ), */
        );
  }
}
