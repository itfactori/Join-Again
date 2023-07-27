import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;

  const PrimaryButton({Key? key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Center(
        child: Container(
          height: 48,
          width: 343,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 30, color: const Color(0xff8377C6).withOpacity(.11))],
            borderRadius: BorderRadius.circular(8),
            gradient: const LinearGradient(
              colors: [Color(0xff246A73), Color(0xff246A73)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$title",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: "ProximaNova"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
