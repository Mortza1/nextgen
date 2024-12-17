import 'appliance.dart';  // Import the Appliance model

class Mode {
  String id;
  String title;
  DateTime startTime;  // Start time as a DateTime object
  DateTime endTime;    // End time as a DateTime object
  List<Appliance> appliances;  // List of appliances associated with this mode

  Mode({
    this.id = '',  // Default value or nullable
    required this.title,
    required this.startTime,
    required this.endTime,
    this.appliances = const [],  // List of appliances, defaults to an empty list
  });

  // Function to add a new appliance to the mode
  void addAppliance(Appliance appliance) {
    appliances.add(appliance);
  }

  // Function to remove an appliance from the mode
  void removeAppliance(String applianceId) {
    appliances.removeWhere((appliance) => appliance.id == applianceId);
  }

  // Function to check if current time is within this mode's time range
  bool isActive() {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }
}
