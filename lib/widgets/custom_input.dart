import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.onPressed,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool? readOnly;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        readOnly: readOnly!,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.only(top: 10),
          fillColor: Colors.white,
          prefixIcon: InkWell(onTap: onPressed ?? () {}, child: Icon(prefixIcon, color: Colors.grey)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          hintText: hintText,
          helperStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w200,
            color: Colors.grey,
          ),
        ),
        focusNode: FocusNode(),
      ),
    );
  }
}
