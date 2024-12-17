import 'package:scoped_model/scoped_model.dart';

import '../model/appliance.dart';

class  ConnectedModelAppliance extends Model{
  final List<Appliance> _applianceList = [
    Appliance(
        title : 'Tv',
        mainIconString: 'assets/images/tv.png',
        type: 'tv',
        state: TVState(lastViewed: 'Movie', timestamp: '2023-01-01', volume: 30),
        isEnable : true),
    Appliance(
        title : 'Speakers',
        mainIconString: 'assets/images/speaker.png',
        type: 'speaker',
        state: SpeakerState(volume: 60, currentTrack: 'Song Title'),
        isEnable : true),
    Appliance(
        title : 'Lights',
        type: 'light',
        mainIconString: 'assets/images/light.png',
        state: LightState(isOn: true, brightness: 80),
        isEnable : true),
    Appliance(
        title : 'Curtains',
        mainIconString: 'assets/images/curtain.png',
        type: 'curtain',
        state: CurtainState(opened: 50),
        isEnable : true),
    Appliance(
        title : 'Cameras',
        type: 'camera',
        mainIconString: 'assets/images/camera.png',
        state: CameraState(isRecording: true),
        isEnable : true),
    Appliance(
        title : 'Thermostat',
        mainIconString: 'assets/images/thermostat.png',
        type: 'thermostat',
        state: ThermostatState(currentTemperature: 24.5),
        isEnable : true),
  ];
}
class ApplianceModel extends ConnectedModelAppliance {
  List<Appliance> get allFetch {
    return List.from(_applianceList);
  }
}