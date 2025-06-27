library com.pogo_check_list_ota_labs.app.navigator;

import 'package:flutter/material.dart';

class CustomNavigator {
  void push(BuildContext context, Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) => view),
    );
  }
}
