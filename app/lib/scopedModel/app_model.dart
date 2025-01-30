import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_service.dart';
import '../model/appliance.dart';
import 'connected_mode.dart';
import 'connected_model_appliance.dart';


class AppModel extends Model {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  final ApplianceModel applianceModel = ApplianceModel();
  final ApiService _apiService = ApiService();
  final ModeModel modeModel = ModeModel();

  Future<void> checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getString('user_id') == null ? false : true;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await _apiService.login(email, password);
    _isLoggedIn = true;
    print(result['data']['user_id'] + 'klklll');
    await prefs.setString('user_id', result['data']['user_id']);
    notifyListeners();
  }

  Future<void> register(String name, String token, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await _apiService.register(name, email, token, password);
    _isLoggedIn = true;
    print(result['data']['user_id'] + 'klklll');
    await prefs.setString('user_id', result['data']['user_id']);
    notifyListeners();
  }

  Future<void> setCommand(String command) async {
    try{
      final result = await _apiService.setCommand('677ff0c3dc28041eb6f226eb', command);
      notifyListeners();
    } catch (e){
      print('Error while toggling light: $e'); // Print the error
    }

  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    await prefs.remove('user_id');

    notifyListeners();
  }

  Future<void> getDevices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId != null) {
      try {
        final result = await _apiService.getDevices(userId);
        List<dynamic> devicesData = result['data']['devices'];
        List<Appliance> appliances = devicesData.map((device){
          return Appliance(
            id: device['_id'] ?? '',
            title: device['name'] ?? 'Unknown Device',
            type: device['type'] ?? 'unknown',
            mainIconString: _getIconPath(device['type']),
            // state: ThermostatState()
            state: _mapState(device),
            // isEnable: device['isEnable'] ?? true,
          );
        }).toList();
        applianceModel.setAppliances(appliances);


        // print('${result['data']}, Devices fetched successfully!');
      } catch (e) {
        print('Error while fetching devices: $e'); // Print the error
      }
    } else {
      print('User ID is null');
    }
  }

  String _getIconPath(String? type) {
    switch (type) {
      case 'tv':
        return 'assets/images/tv.png';
      case 'speaker':
        return 'assets/images/speaker.png';
      case 'light':
        return 'assets/images/light.png';
      case 'curtain':
        return 'assets/images/curtain.png';
      case 'camera':
        return 'assets/images/camera.png';
      case 'thermostat':
        return 'assets/images/thermostat.png';
      default:
        return 'assets/images/default.png';
    }
  }

  dynamic _mapState(Map<String, dynamic> device) {
    switch (device['type']) {
      case 'tv':
        return TVState(
          lastViewed: device['state']['lastViewed'] ?? 'Unknown',
          timestamp: device['state']['timestamp'] ?? '2023-01-01',
          volume: device['state']['volume'] ?? 30,
        );
      case 'speaker':
        return SpeakerState(
          volume: device['state']['volume'] ?? 50,
          trackAuthor: device['state']['trackAuthor'] ?? 'Unknown',
          trackCover: device['state']['trackCover'] ?? 'assets/images/music.jpg',
          trackTitle: device['state']['trackTitle'] ?? 'Unknown Track',
          currentTimestamp: Duration(seconds: device['state']['currentTimestamp'] ?? 0),
          trackTime: Duration(seconds: device['state']['trackTime'] ?? 240),
        );
      case 'light':
        return LightState(
          isOn: device['current_data']['isOn'] ?? false,
          brightness: device['current_data']['brightness'] ?? 100,
        );
      case 'curtain':
        return CurtainState(opened: device['state']['opened'] ?? 50);
      case 'camera':
        return CameraState(isRecording: device['state']['isRecording'] ?? false);
      case 'thermostat':
        return ThermostatState();
      default:
        return null;
    }
  }


  void notifyAll() {
    applianceModel.notifyListeners();
    modeModel.notifyListeners();
    notifyListeners();
  }
}

