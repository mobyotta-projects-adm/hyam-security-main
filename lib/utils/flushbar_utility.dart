import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarUtility {
  FlushbarUtility(this.context);

  final BuildContext context;

  showFlusbar(String message) {
    Flushbar(
      title: 'Hyam Security',
      message: message,
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }
}
