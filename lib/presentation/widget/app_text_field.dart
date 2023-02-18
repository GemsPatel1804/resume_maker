import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChange;
  final TextInputType keyboardType;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final RxString? errorMessage;

  const AppTextField({
    Key? key,
    this.hintText,
    this.onChange,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.inputFormatters,
    this.controller,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ]),
          child: TextFormField(
            keyboardType: keyboardType,
            controller: controller,
            onChanged: onChange,
            inputFormatters: inputFormatters,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 15.0,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black.withOpacity(.2), width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Obx(
          () => (errorMessage!.value.isNotEmpty)
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 25,
                    color: Colors.transparent,
                    child: Text(
                      errorMessage!.value,
                      style: const TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
                )
              : Container(),
        )
      ],
    );
  }
}
