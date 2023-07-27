import 'package:flutter/material.dart';

import '../../../themes/app_colors.dart';

class GenderSelectingWidget extends StatefulWidget {
  int groupVal;
  GenderSelectingWidget({Key? key, required this.groupVal}) : super(key: key);

  @override
  State<GenderSelectingWidget> createState() => _GenderSelectingWidgetState();
}

class _GenderSelectingWidgetState extends State<GenderSelectingWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          activeColor: AppColors.mainColor,
          value: 0,
          groupValue: widget.groupVal,
          onChanged: (v) {
            setState(() {
              widget.groupVal = v!;
            });
          },
          title: const Text("Male"),
        ),
        RadioListTile(
          activeColor: AppColors.mainColor,
          value: 1,
          groupValue: widget.groupVal,
          onChanged: (v) {
            setState(() {
              widget.groupVal = v!;
            });
          },
          title: const Text("Female"),
        ),
        RadioListTile(
          activeColor: AppColors.mainColor,
          value: 2,
          groupValue: widget.groupVal,
          onChanged: (v) {
            setState(() {
              widget.groupVal = v!;
            });
          },
          title: const Text("Other"),
        ),
      ],
    );
  }
}
