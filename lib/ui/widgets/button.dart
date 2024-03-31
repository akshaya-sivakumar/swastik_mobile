import 'package:flutter/material.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';

button(label, func, colortheme, {textcolor, size}) {
  return ElevatedButton(
    style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 0)),
        backgroundColor: MaterialStateProperty.all<Color>(colortheme),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ))),
    onPressed: func,
    child: Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Text(
        label,
        style: TextStyle(
          color: textcolor ?? Colors.white,
          fontSize: size ?? 15.sp,
        ),
      ),
    ),
  );
}
