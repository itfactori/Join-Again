import 'package:flutter/material.dart';



//Join Button Class
// class JoinButton extends StatelessWidget {
//   final Function()? onPressed;
//   final String? title;
//   const JoinButton({
//     Key? key,
//     this.onPressed,
//     this.title,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed ?? () {},
//       child: Center(
//         child: Container(
//           height: 48,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             boxShadow: [BoxShadow(blurRadius: 30, color: const Color(0xff8377C6).withOpacity(.11))],
//             borderRadius: BorderRadius.circular(8),
//             gradient: const LinearGradient(
//               colors: [Color(0xff246A73), Color(0xff246A73)],
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "$title",
//                 style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18, fontFamily: "ProximaNova"),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class SuggestionButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final Color? borderColor;
  const SuggestionButton({Key? key, this.title, this.onPressed, this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 30,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(08),
          border: Border.all(color: borderColor!),
        ),
        child: Center(
          child: Text(title!),
        ),
      ),
    );
  }
}
