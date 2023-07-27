import 'package:flutter/material.dart';
import 'package:join/screens/events/send_request_for_event_joing.dart';

import 'accepted_request.dart';

class EventRequestTab extends StatefulWidget {
  const EventRequestTab({super.key});

  @override
  State<EventRequestTab> createState() => _EventRequestTabState();
}

class _EventRequestTabState extends State<EventRequestTab> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Event Requests"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              height: 45,
              padding: const EdgeInsets.all(2),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0x22736F7F),
                ),
                color: Colors.white,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: currentIndex == 0 ? const Color(0xFF246A73) : Colors.transparent,
                        ),
                        child: Text(
                          "Send",
                          style: TextStyle(color: currentIndex == 0 ? Colors.white : const Color(0xFF736F7F)),
                        )),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: currentIndex == 1 ? const Color(0xFF246A73) : Colors.transparent,
                        ),
                        child: Text(
                          "Receive",
                          style: TextStyle(color: currentIndex == 1 ? Colors.white : const Color(0xFF736F7F)),
                        )),
                  ),
                ),
              ]),
            ),
            currentIndex == 0
                ? const Expanded(child: SendRequestForActivityJoining())
                : const Expanded(child: ReceivedRequestForActivityJoininig()),
          ],
        ),
      ),
    );
  }
}
