import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class ChatTextInput extends StatelessWidget {
  final TextEditingController? chatController;
  final Function()? onPressed;
  final Function()? onLinkClicked;
  const ChatTextInput({Key? key, this.chatController, this.onPressed, this.onLinkClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 52,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: chatController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type message ...",
                  suffixIcon: InkWell(
                    onTap: onLinkClicked,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/link.png', height: 10, width: 18),
                    ),
                  )),
            ),
          ),
        ),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.mainColor,
            ),
            child: Center(
              child: Image.asset("assets/send.png", height: 24, width: 24),
            ),
          ),
        )
      ],
    );
  }
}

class SearchTextInput extends StatelessWidget {
  const SearchTextInput({
    super.key,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.onChanged,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool? readOnly;
  final Function(String v)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextFormField(
        onChanged: onChanged!,
        readOnly: readOnly!,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          filled: true,
          contentPadding: const EdgeInsets.only(top: 10),
          fillColor: Colors.white,
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Colors.grey)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
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
