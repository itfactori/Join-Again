import 'package:flutter/material.dart';

class AttachmentWidget extends StatelessWidget {
  final Function()? onFileClicked;
  const AttachmentWidget({Key? key, this.onFileClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 84,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AttachmentTypeWidget(
              onTap: () {},
              image: "assets/gallery.png",
            ),
            AttachmentTypeWidget(
              onTap: () {},
              image: "assets/location.png",
            ),
            AttachmentTypeWidget(
              onTap: () {},
              image: "assets/camera.png",
            ),
            AttachmentTypeWidget(
              onTap: onFileClicked,
              image: "assets/file.png",
            ),
          ],
        ),
      ),
    );
  }
}

class AttachmentTypeWidget extends StatelessWidget {
  final String? image;
  final Function()? onTap;
  const AttachmentTypeWidget({Key? key, this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffFF7E87),
        ),
        child: Center(
          child: Image.asset(image!, height: 16, width: 13),
        ),
      ),
    );
  }
}
