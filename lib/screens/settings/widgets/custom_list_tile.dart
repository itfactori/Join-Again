import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final bool isSuffixIconRequired;

  const CustomListTile({
    super.key,
    this.title,
    this.onTap,
    this.isSuffixIconRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: isSuffixIconRequired
                    ? const Color(
                        0xff160F29,
                      )
                    : const Color(0xffff0000),
                fontSize: 16,
                fontFamily: "ProximaNova",
                fontWeight: FontWeight.w500,
              ),
            ),
            isSuffixIconRequired
                ? Image.asset(
                    "assets/arrow.png",
                    height: 20,
                    width: 20,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
