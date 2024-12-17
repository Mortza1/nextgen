import 'package:scoped_model/scoped_model.dart';

import 'connected_mode.dart';
import 'connected_model_appliance.dart';


class AppModel extends Model {
  final ApplianceModel applianceModel = ApplianceModel();
  final ModeModel modeModel = ModeModel();

  void notifyAll() {
    applianceModel.notifyListeners();
    modeModel.notifyListeners();
    notifyListeners();
  }
}
