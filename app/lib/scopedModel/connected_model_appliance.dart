import 'package:scoped_model/scoped_model.dart';
import '../model/appliance.dart';

class ConnectedModelAppliance extends Model {}

class ApplianceModel extends ConnectedModelAppliance {
  List<Appliance> _fetchedAppliances = [];

  List<Appliance> get allFetch => List.from(_fetchedAppliances);

  void setAppliances(List<Appliance> appliances) {
    _fetchedAppliances = appliances;
    notifyListeners();
  }

  /// 🆕 **Get Appliance by ID**
  Appliance? getApplianceById(String id) {
    try {
      return _fetchedAppliances.firstWhere((appliance) => appliance.id == id);
    } catch (e) {
      print('Appliance with ID $id not found');
      return null;
    }
  }
}
