import 'package:flutter/material.dart';

class TextCard extends StatelessWidget {
  final String? title;

  const TextCard({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xff368F8B).withOpacity(.10)),
      child: Center(
        child: Text(
          title!,
          style: const TextStyle(
            color: Color(0xff246A73),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
