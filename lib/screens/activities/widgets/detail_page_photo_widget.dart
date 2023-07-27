import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailPagePhotoWidget extends StatefulWidget {
  final dynamic data;
  const DetailPagePhotoWidget({Key? key, this.data}) : super(key: key);

  @override
  State<DetailPagePhotoWidget> createState() => _DetailPagePhotoWidgetState();
}

class _DetailPagePhotoWidgetState extends State<DetailPagePhotoWidget> {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          width: double.infinity,
          child: PageView(
            controller: pageController,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(widget.data['photo'], fit: BoxFit.cover, width: double.infinity),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share),
                          color: Colors.white,
                          onPressed: () {
                            Share.share(
                              "👋 Join this event on Join ! It's an app for spontaneous,events, and more.",
                              subject: "",
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 15),
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: 3,
            axisDirection: Axis.horizontal,
            effect: const ExpandingDotsEffect(
              spacing: 8.0,
              radius: 10.0,
              dotWidth: 12.0,
              dotHeight: 12.0,
              paintStyle: PaintingStyle.fill,
              dotColor: Color(0x50736F7F),
              activeDotColor: Color(0xFFFF7E87),
            ),
          ),
        ),
      ],
    );
  }
}
