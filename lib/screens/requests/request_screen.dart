import 'package:flutter/material.dart';
import 'package:join/screens/requests/widgets/receive_request.dart';
import 'package:join/screens/requests/widgets/sending_requests.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({Key? key}) : super(key: key);

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  int _selectedTab = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Requests",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
                        _selectedTab = 0;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _selectedTab == 0 ? const Color(0xFF246A73) : Colors.transparent,
                        ),
                        child: Text(
                          "Send Requests",
                          style: TextStyle(color: _selectedTab == 0 ? Colors.white : const Color(0xFF736F7F)),
                        )),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTab = 1;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: _selectedTab == 1 ? const Color(0xFF246A73) : Colors.transparent,
                        ),
                        child: Text(
                          "Receive Request",
                          style: TextStyle(color: _selectedTab == 1 ? Colors.white : const Color(0xFF736F7F)),
                        )),
                  ),
                ),
              ]),
            ),
            _selectedTab == 0 ? const SendingRequest() : const ReceivedRequest(),
          ],
        ),
      ),
    );
  }
}
