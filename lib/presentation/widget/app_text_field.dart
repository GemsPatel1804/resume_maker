import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? prefixIcon;
  final bool? icon;
  final String? keyValue;
  final String? hintText;
  final String? initialValue;
  final Widget? suffixIcon;
  final String? Function(String?)? validate;
  final Function(String)? onChange;
  final Function(String)? onFieldSubmitted;
  final bool obsecureText;
  final bool border;
  final bool shadow;
  final TextInputType keyboardType;
  final int maxLines;
  final Color? color;
  final List<TextInputFormatter>? inputFormatters;
  final RxString? errorMessage;
  final bool readonly;
  final Function()? ontap;
  final double? radius;

  const AppTextField({
    Key? key,
    this.keyValue = "1",
    this.hintText,
    this.initialValue,
    this.validate,
    this.onChange,
    this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.color,
    this.border = false,
    this.shadow = false,
    this.prefixIcon,
    this.inputFormatters,
    this.controller,
    this.errorMessage,
    this.readonly = false,
    this.ontap,
    this.radius,
    this.icon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            // border:
            //     border == true ? Border.all(color: AppColors.appColor) : null,
            color: color ?? Colors.white,
            borderRadius: BorderRadius.circular(radius ?? 10),
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ]
                : [],
          ),

          child: TextFormField(
            onTap: ontap,
            readOnly: readonly,
            controller: controller,
            onChanged: onChange,
            inputFormatters: inputFormatters,
            obscureText: obsecureText,
            maxLines: maxLines,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: const TextStyle(
                fontSize: 15.0,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(radius ?? 10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(radius ?? 10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(radius ?? 10),
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
