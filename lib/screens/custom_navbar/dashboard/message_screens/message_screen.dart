import 'package:flutter/material.dart';
import 'package:join/screens/custom_navbar/dashboard/message_screens/tabs/event_schat.dart';

import '../../../chat/single_chat/user_chat_list.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Messages"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/chat_pic.png",
          ),
          fit: BoxFit.cover,
        )),
        child: Padding(
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
                            "Events",
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
                            "People",
                            style: TextStyle(color: currentIndex == 1 ? Colors.white : const Color(0xFF736F7F)),
                          )),
                    ),
                  ),
                ]),
              ),
              currentIndex == 0 ? const Expanded(child: EventChats()) : const Expanded(child: UserChatList()),
            ],
          ),
        ),
      ),
    );
  }
}
