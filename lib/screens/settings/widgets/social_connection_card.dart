import 'package:flutter/material.dart';
import 'package:join/themes/app_colors.dart';

class SocialConnectionCard extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Color? color;
  final String? image;
  final bool isSubTitleReq;
  final bool isCircularShapeReq;
  const SocialConnectionCard(
      {Key? key, this.title, this.subTitle, this.color, this.image, this.isSubTitleReq = false, this.isCircularShapeReq = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration:  BoxDecoration(
        color: Color(0xFFEDF3F4),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            isCircularShapeReq
                ? Image.asset(
                    image!,
                    height: 26,
                    width: 26,
                  )
                : Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff246a73).withOpacity(0.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset(
                        image!,
                        height: 22,
                        width: 22,
                      ),
                    )),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title!,
                  style: TextStyle(fontFamily: "ProximaNova", fontSize: 16, color: color, fontWeight: FontWeight.w400),
                ),
                isSubTitleReq
                    ? Text(
                        subTitle!,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
            const Spacer(),
            isCircularShapeReq ? const Icon(Icons.keyboard_arrow_down) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
