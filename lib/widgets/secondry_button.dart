import 'package:flutter/material.dart';
class SecondaryButton extends StatelessWidget {
  final VoidCallback ? onTap;
  final String ? title;
  const SecondaryButton({Key? key, this.onTap, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (){},
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(left: 12, right: 12, top: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 30,
                color: const Color(0xff8377C6).withOpacity(.11))
          ],
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(
            colors: [Color(0xffEDF3F4), Color(0xff246A73)],
          ),
        ),
        child:  Center(
          child: Text(
            title!,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
                fontFamily: "ProximaNova"),
          ),
        ),
      ),
    );
  }
}
