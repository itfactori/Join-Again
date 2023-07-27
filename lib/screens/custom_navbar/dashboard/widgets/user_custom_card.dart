import 'package:flutter/material.dart';
import 'package:join/services/db_services.dart';

class UserCustomCard extends StatefulWidget {
  final dynamic data;
  const UserCustomCard({Key? key, this.data}) : super(key: key);

  @override
  State<UserCustomCard> createState() => _UserCustomCardState();
}

class _UserCustomCardState extends State<UserCustomCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(widget.data['photo']),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        widget.data['name'],
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(widget.data['email'].substring(0, 4) + "......."),
      trailing: InkWell(
        onTap: () async {
          await DatabaseServices.sendFriendRequestToUser(
            toUserId: widget.data['uid'],
          );
        },
        child: const Icon(
          Icons.email,
          color: Color(0xffff7e87),
        ),
      ),
    );
  }
}
