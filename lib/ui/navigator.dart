library com.pogo_check_list_ota_labs.app.navigator;

import 'package:flutter/material.dart';

import 'widgets/widgets.dart';

class CustomNavigator {
  void push(BuildContext context, Widget view) {
    Navigator.push(
      context,
      MaterialPageRoute<Widget>(builder: (BuildContext context) => view),
    );
  }

  void pop(BuildContext context, Widget view) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      if (context.mounted) {
        showErrorSnackBar(context, 'No hay mas páginas');
      }
    }
  }

  bool canPop(BuildContext context) => Navigator.canPop(context);
}
