import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swastik_mobile/route_generator.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/button.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        "Logout",
                        fontweight: FontWeight.bold,
                        size: 22.sp,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      )
                    ],
                  ),
                  actionsAlignment: MainAxisAlignment.center,
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget("Are you sure you want to logout?"),
                    ],
                  ),
                  actions: [
                    button(
                      "Cancel",
                      () async {
                        Navigator.pop(context);
                      },
                      Colors.grey,
                    ),
                    button("Ok", () async {
                      Navigator.pop(navigatorKey.currentContext!);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      navigatorKey.currentState?.pushNamedAndRemoveUntil(
                        "/",
                        (route) {
                          return false;
                        },
                      );
                    }, HexColor("#135a92"))
                  ],
                );
              },
            );
          },
          child: const Icon(
            Icons.logout,
            color: Colors.black,
          )),
    );
  }
}
