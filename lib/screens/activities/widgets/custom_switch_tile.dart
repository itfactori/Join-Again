import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  final String ? title;
  final String ? subTitle;
  final Widget ? child;
  const CustomSwitchTile({Key? key, this.title, this.subTitle,  this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
              title!,
              style: const TextStyle(
                  color: Color(
                    0xff160F29,
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
        ),
             child!
           ],
         ),
        Text(
          subTitle!,
          maxLines: null,
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xff736F7F)),
        ),
      ],
    );
  }
}
