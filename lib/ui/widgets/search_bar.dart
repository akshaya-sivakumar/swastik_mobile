import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

var showPassword = true;
TextField searchBox(controller, label, hint, function) {
  return TextField(
    textAlign: TextAlign.start,
    onChanged: (v) {
      function();
    },
    controller: controller,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
      isDense: true,
      suffixIcon: InkWell(
          onTap: () {
            if (controller.text.toString().isNotEmpty) {
              controller.text = "";
            }
            function();
          },
          child: controller.text == ""
              ? const Icon(
                  Icons.search,
                  color: Colors.grey,
                )
              : const Icon(
                  Icons.cancel,
                  color: Colors.black,
                )),
      floatingLabelStyle: TextStyle(color: HexColor("#135a92")),
      label: Text(
        label,
        // style: TextStyle(color: HexColor("#135a92")),
      ),
      focusColor: HexColor("#135a92"),
      hintText: hint == "" ? 'Enter here' : hint,
      hintStyle: const TextStyle(fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: const BorderSide(
          width: 0,
          style: BorderStyle.solid,
        ),
      ),
      enabledBorder: OutlineInputBorder(
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
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
    ),
  );
}
