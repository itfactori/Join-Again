import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PhotoUploadingWidget extends StatefulWidget {
  final Function()? onPressed;
  final Uint8List? image;
  const PhotoUploadingWidget({Key? key, this.onPressed, required this.image}) : super(key: key);

  @override
  State<PhotoUploadingWidget> createState() => _PhotoUploadingWidgetState();
}

class _PhotoUploadingWidgetState extends State<PhotoUploadingWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: 374,
        height: 157,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xffD2D2D2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.image!.isEmpty
                ? CircleAvatar(radius: 59, backgroundImage: MemoryImage(widget.image!))
                : Image.asset(
                    "assets/phone.png",
                    width: 51,
                    height: 39,
                  ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                text: 'Upload Profile Photo',
                style: TextStyle(
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        fontFamily: 'ProximaNova',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
