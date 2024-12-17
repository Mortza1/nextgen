import 'package:flutter/material.dart';

class Appliance {
  String id;
  String title;
  IconData mainIcon;
  String mainIconString;
  Map<String, dynamic> state;
  bool isEnable;

  Appliance({
    this.id = '', // Default value or nullable
    this.title = '',
    this.mainIcon = Icons.tv,
    this.mainIconString = '',
    this.state = const {'state': 'off'},
    this.isEnable = false,  // Default value for boolean
  });
}
