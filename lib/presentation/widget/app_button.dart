import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final double? height;
  final double? width;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final Color? borderColor;
  final bool? border;
  final double? fs;
  final double? radius;
  final bool loader;

  const AppButton(
      {Key? key,
      this.onPressed,
      this.text,
      this.height,
      this.width,
      this.color,
      this.border = false,
      this.borderColor,
      this.textColor,
      this.iconColor,
      this.fs,
      this.radius,
      this.loader = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(radius ?? 10),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 10),
          color: color ?? Colors.blue,
          border: border == false
              ? null
              : Border.all(
                  color: borderColor ?? Colors.black.withOpacity(.3),
                ),
        ),
        child: SizedBox(
          height: height ?? 50,
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loader
                  ? const CircularProgressIndicator.adaptive()
                  : Text(
                      text!,
                      style: TextStyle(
                        fontSize: fs ?? 16,
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
