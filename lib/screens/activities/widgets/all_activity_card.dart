import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../activities_details/detail.page.dart';

class AllActivityCard extends StatelessWidget {
  final dynamic data;
  const AllActivityCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        //   boxShadow: const [
        //     BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 0.5),
        //   ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                    color: const Color(0xffff7e87).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 63,
                        width: 63,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(data['photo']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xffff7e87),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 190,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title'],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        data['description'],
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/timer.png",
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 5),
                            Text(
                              data['date'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff160F29).withOpacity(.6), fontSize: 10),
                            ),
                            const SizedBox(width: 2),
                            const Text("|"),
                            const SizedBox(width: 2),
                            Text(
                              "${data['startTime']} - ${data['endTime']}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black.withOpacity(.6), fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: 18,
                      width: 51,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF7E87).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          data['isActivityPrivate'] ? "Private" : "Public",
                          style: const TextStyle(
                            color: Color(0xffFF7E87),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${data['acceptedUser'].length}  Going',
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            const DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.grey,
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xffff7e87).withOpacity(0.1),
                  ),
                  child: Image.asset("assets/location_doc.png"),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    data['address'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 15),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(data: data)));
                  },
                  child: Container(
                    width: 61,
                    height: 25,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xff246A73),
                        Color(0xff368F8B),
                      ]),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
