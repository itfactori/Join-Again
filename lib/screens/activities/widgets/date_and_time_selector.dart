import 'package:flutter/material.dart';

class DateAndTimeSelector extends StatelessWidget {
  final VoidCallback ? onTap;
  final String ? hintText;
  final TextEditingController  controller;
  const DateAndTimeSelector({
    super.key, this.onTap, this.hintText, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (){
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
        ),
        child:  TextField(
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
              hintText: hintText,
              enabled: false,
              suffixIcon: Icon(Icons.keyboard_arrow_down)
          ),
        ),
      ),
    );
  }
}