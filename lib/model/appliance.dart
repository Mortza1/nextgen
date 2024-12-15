import 'package:flutter/cupertino.dart';

class Appliance {
  String id;
  String title;
  String subtitle;
  IconData leftIcon;
  IconData topRightIcon;
  IconData bottomRightIcon;
  bool isEnable;

  Appliance({
    this.id = '', // Default value or nullable
    this.title = '',
    this.subtitle = '',
    required this.leftIcon,
    required this.topRightIcon,
    required this.bottomRightIcon,
    this.isEnable = true,  // Default value for boolean
  });
}
