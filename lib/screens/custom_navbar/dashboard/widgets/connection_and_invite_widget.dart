import 'package:flutter/material.dart';

class ConnectionAndInviteWidget extends StatelessWidget {
  const ConnectionAndInviteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
            height: 119,
            width: 343,
            // padding: EdgeInsets.only(top: 16, left: 16, right: 16),
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  "assets/errors.png",
                  height: 58,
                  width: 58,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 210,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Connection Yet!",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Meet other users and scan their QR Codes to connect.",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 20),
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "",
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
              height: 119,
              width: 343,
              // padding: EdgeInsets.only(top: 16, left: 16, right: 16),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "assets/phone.png",
                    height: 58,
                    width: 58,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 210,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No invite yet!",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Invite your friend and experience the events in your area together.",
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "assets/greenshare.png",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
