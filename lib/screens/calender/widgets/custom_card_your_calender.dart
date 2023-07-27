import 'package:flutter/material.dart';

import '../../activities/activities_details/detail.page.dart';

class CustomYourCalenderCard extends StatefulWidget {
  final dynamic data;
  const CustomYourCalenderCard({Key? key, this.data}) : super(key: key);

  @override
  State<CustomYourCalenderCard> createState() => _CustomYourCalenderCardState();
}

class _CustomYourCalenderCardState extends State<CustomYourCalenderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5, top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.grey, offset: Offset(0, 0), blurRadius: 0.5),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => DetailPage(data: widget.data),
                    ),
                  );
                },
                child: SizedBox(
                  height: 140,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.data['photo'],
                          height: 140,
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Image.asset(
                            "assets/whiteshare.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.data['title'],
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  widget.data['description'],
                  style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff736F7F),),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/timer.png",
                      width: 14,
                      height: 15,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.data['date'],
                      style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff160F29).withOpacity(.6), fontSize: 12),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.data['startTime'],
                      style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0x60000000), fontSize: 12),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "to",
                      style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0x60000000), fontSize: 12),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.data['endTime'],
                      style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0x60000000), fontSize: 12),
                    ),
                    const Spacer(),
                    Container(
                      width: 64,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xff246A73).withOpacity(.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Text(
                            '${widget.data['acceptedUser'].length}  Going',
                            style: const TextStyle(fontWeight: FontWeight.w400, color: Color(0xff246A73), fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
