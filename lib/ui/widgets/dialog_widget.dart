import 'package:flutter/material.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

import '../../route_generator.dart';
import 'button.dart';

class DialogWidget {
  Future<dynamic> dialogWidget(BuildContext cxt, String title,
      Function()? cancelPress, Function()? okPress,
      {Widget? notefield, String? okText}) {
    return showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            title,
            fontweight: FontWeight.bold,
            size: 20.sp,
          ),
          content: notefield,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            button(
              "Cancel",
              cancelPress,
              Colors.red.shade900,
            ),
            button(
              okText ?? "OK",
              okPress,
              Colors.green.shade800,
            )
          ],
        );
      },
    );
  }
}
