import 'package:flutter/material.dart';

class DetailPageActivityHeader extends StatelessWidget {
  final dynamic data;

  const DetailPageActivityHeader({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['title'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 18,
                  width: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF7E87).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      data['isActivityPrivate'] == false ? "Public" : "Private",
                      style: const TextStyle(
                        color: Color(0xffFF7E87),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "${data['acceptedUser'].length} Going",
              style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Image.asset(
                  "assets/timer.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  data['date'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(width: 3),
                const Text("|"),
                const SizedBox(width: 3),
                Text(
                  data['startTime'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const Text("-"),
                Text(
                  data['endTime'],
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
