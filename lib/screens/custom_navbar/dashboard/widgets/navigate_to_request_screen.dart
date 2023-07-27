import 'package:flutter/material.dart';

import '../../../requests/request_screen.dart';

void navigateToRequestScreen(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (_) => const RequestScreen()));
}
