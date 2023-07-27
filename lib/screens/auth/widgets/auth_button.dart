import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

class AuthButton extends StatelessWidget {
  final Function()? onPressed;
  final String? title;
  final String? image;
  const AuthButton({Key? key, this.onPressed, this.title, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Center(
        child: Container(
          height: 53,
          width: 343,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 30, color: const Color(0xff8377C6).withOpacity(.11))],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.mainColor.withOpacity(0.17)),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "$image",
                height: 23,
                width: 23,
              ),
              const SizedBox(width: 15),
              Text(
                "$title",
                style: const TextStyle(color: Color(0xff160F29), fontWeight: FontWeight.w600, fontSize: 18, fontFamily: "ProximaNova"),
              )
            ],
          ),
        ),
      ),
    );
  }
}