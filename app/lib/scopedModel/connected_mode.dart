import 'package:scoped_model/scoped_model.dart';

import '../model/appliance.dart';
import '../model/mode.dart';

class ConnectedMode extends Model {
  final List<Mode> _modeList = [
    Mode(
      title: 'Morning Mode',
      startTime: DateTime(2024, 12, 17, 6, 0),  // 06:00 AM
      endTime: DateTime(2024, 12, 17, 9, 0),    // 09:00 AM
      appliances: [
        Appliance(
          title: 'Tv',
          mainIconString: 'assets/images/tv.png',
          type: 'tv',
          isEnable: true,
          state: TVState(lastViewed: 'Movie', timestamp: '2023-01-01', volume: 30),
        ),
        Appliance(
          title: 'Speakers',
          mainIconString: 'assets/images/speaker.png',
          type: 'speaker',
          isEnable: true,
          state: SpeakerState(volume: 60, trackAuthor: 'Juice WRLD', trackCover: 'assets/images/music.jpg', trackTitle: 'All eyes on me', currentTimestamp: Duration(minutes: 1)),
        ),
      ],
    ),
    Mode(
      title: 'Night Mode',
      startTime: DateTime(2024, 12, 17, 20, 0),  // 08:00 PM
      endTime: DateTime(2024, 12, 17, 22, 0),    // 10:00 PM
      appliances: [
        Appliance(
          title: 'Lights',
          mainIconString: 'assets/images/light.png',
          type: 'light',
          isEnable: true,
          state: LightState(isOn: true, brightness: 80),
        ),
        Appliance(
          title: 'Curtains',
          mainIconString: 'assets/images/curtain.png',
          type: 'curtain',
          isEnable: true,
          state: CurtainState(opened: 50),
        ),
      ],
    ),
  ];

  // Fetch all modes
  List<Mode> get allModes {
    return List.from(_modeList);
  }

  // Add a mode
  void addMode(Mode mode) {
    _modeList.add(mode);
    notifyListeners();  // Notify listeners to update the UI
  }

  // Delete a mode by its ID or title
  void deleteMode(String modeId) {
    _modeList.removeWhere((mode) => mode.id == modeId);
    notifyListeners();  // Notify listeners to update the UI
  }

  // Add an appliance to a specific mode
  void addApplianceToMode(String modeId, Appliance appliance) {
    Mode mode = _modeList.firstWhere((mode) => mode.id == modeId);
    mode.addAppliance(appliance);
    notifyListeners();
  }

  // Remove an appliance from a specific mode
  void removeApplianceFromMode(String modeId, String applianceId) {
    Mode mode = _modeList.firstWhere((mode) => mode.id == modeId);
    mode.removeAppliance(applianceId);
    notifyListeners();
  }
}

class ModeModel extends ConnectedMode {
  List<Mode> get allFetch {
    return List.from(_modeList);
  }
}

