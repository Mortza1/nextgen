import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model/appliance.dart';

class  ConnectedModel extends Model{
  final List<Appliance> _applianceList = [
    Appliance(
        title : 'Tv',
        mainIcon: Icons.tv,
        isEnable : true),
    Appliance(
        title : 'Tv',
        mainIcon: Icons.tv,
        isEnable : true),
    Appliance(
        title : 'Tv',
        mainIcon: Icons.tv,
        isEnable : true),
    Appliance(
        title : 'Tv',
        mainIcon: Icons.tv,
        isEnable : true),
    Appliance(
        title : 'Tv',
        mainIcon: Icons.tv,
        isEnable : true),
  ];
}
class ApplianceModel extends ConnectedModel {
  List<Appliance> get allFetch {
    return List.from(_applianceList);
  }
}