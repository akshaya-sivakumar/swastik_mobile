import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swastik_mobile/screen_util/flutter_screenutil.dart';
import 'package:swastik_mobile/ui/widgets/text_widget.dart';

class CustomFormField extends StatelessWidget {
  final String headingText;
  final String? hintText;
  final bool obsecureText;
  final Widget suffixIcon;
  final Widget? prefixIcon;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;

  const CustomFormField(
      {Key? key,
      required this.headingText,
      this.hintText,
      this.prefixIcon,
      required this.obsecureText,
      required this.suffixIcon,
      required this.textInputType,
      required this.textInputAction,
      required this.controller,
      required this.maxLines,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 35.sp, right: 35.sp, bottom: 10.sp),
          child: TextWidget(
            headingText,
            color: Colors.black,
            size: 19.sp,
            fontweight: FontWeight.w500,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 35.sp, right: 35.sp, bottom: 10.sp),
          decoration: BoxDecoration(
            // color: HexColor("#2E2C5E"),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            maxLines: maxLines,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: textInputType,
            obscureText: obsecureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: HexColor("#135a92"),
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                hintText: hintText,
                //  hintStyle: KTextStyle.textFieldHintStyle,

                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon),
          ),
        )
      ],
    );
  }
}
