import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String ? title;
  final VoidCallback ? onTap;
  const CustomListTile({
    super.key, this.title, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (){},
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(offset: Offset(0.0, 0.0), color: Colors.grey, blurRadius: 0.1)]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Color(
                    0xff160F29,
                  ),
                  fontSize: 16,
                  fontFamily: "ProximaNova",
                  fontWeight: FontWeight.w400),
            ),
            Image.asset(
              "assets/arrow.png",
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}