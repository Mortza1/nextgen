import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Api/api_service.dart';
import '../model/appliance.dart';
import '../model/mode.dart';
import 'connected_mode.dart';
import 'connected_model_appliance.dart';


class AppModel extends Model {
  bool _isLoggedIn = false;
  Map<String, dynamic> userData = {};
  Map<String, dynamic> homeData = {};
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
  Future<void> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? homeId = prefs.getString('home_id');

    if (userId != null && homeId != null) {
      try {
        final result = await _apiService.getUser(userId, homeId);

        if (result['statusCode'] == 200) {  // Assuming API response contains a success field
          // Extract user details from API response
          userData = result['data']['user'];
          homeData = result['data']['home'];


          print("User Data: $userData"); // Debugging output
        } else {
          print("Failed to fetch user data: ${result['message']}");
        }
      } catch (e) {
        print("Error fetching user: $e");
      }
    } else {
      print("No user ID found in SharedPreferences.");
    }

    notifyListeners();  // Update UI
  }
  Future<void> register(String name, String token, String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final result = await _apiService.register(name, email, token, password);
    _isLoggedIn = true;
    print(result['data']['user_id'] + 'klklll');
    await prefs.setString('user_id', result['data']['user_id']);
    await prefs.setString('home_id', result['data']['home_id']);
    notifyListeners();
  }
  Future<void> setCommand(String id, String command) async {
    try{
      final result = await _apiService.setCommand(id, command);
      notifyListeners();
    } catch (e){
      print('Error while toggling light: $e'); // Print the error
    }

  }
  Future<void> addMode(Map<String, dynamic> mode) async {
    print(homeData);
    var homeId = homeData['_id'];
    final result = await _apiService.addMode(homeId, mode);
    print(result);
    notifyListeners();
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
    String? hubId = prefs.getString('hub_id');
    hubId ??= '';

    if (userId != null) {
      try {
        final result = await _apiService.getDevices(userId, hubId);
        if (hubId == '') {
          await prefs.setString('hub_id', result['data']['hub_id']);
        }

        // Handle devices
        List<dynamic> devicesData = result['data']['devices'] ?? [];
        List<Appliance> appliances = devicesData.map((device) {
          return Appliance(
            id: device['_id'] ?? '',
            title: device['name'] ?? 'Unknown Device',
            type: device['type'] ?? 'unknown',
            mainIconString: _getIconPath(device['type']),
            state: _mapState(device),
          );
        }).toList();
        applianceModel.setAppliances(appliances);
        // Handle modes
        if (homeData != null && homeData.containsKey('modes')) {
          List<Mode> modes = (homeData['modes'] ?? []).map<Mode>((mode) {
            var devices = (mode['devices'] as List<dynamic>)
                .map((e) => e.toString()) // Convert each element to String
                .toList();
            var appliances = devices
                .map((id) => applianceModel.getApplianceById(id))
                .where((appliance) => appliance != null)
                .cast<Appliance>()
                .toList();
            return Mode(
                title: mode['name'] ?? '',
                startTime: DateTime.now(),
                endTime: DateTime.now(),
                backImg: mode['bgImage'],
                bgColor: mode['bgColor'],
                appliances: appliances
            );
          }).toList();
          modeModel.setModes(modes);
        } else {
          print('homeData or modes is null');
        }

      } catch (e) {
        print('Error while fetching devices: $e');
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
      case 'security lock':
        return 'assets/images/lock.png';
      case 'socket':
        return 'assets/images/plug.png';
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
          isOn: device['current_data']['metric']['is_on'] ?? false,
          brightness: device['current_data']['metric']['brightness'] ?? 50,
        );
      case 'curtain':
        return CurtainState(opened: device['state']['opened'] ?? 50);
      case 'camera':
        return CameraState(isRecording: device['state']['isRecording'] ?? false);
      case 'thermostat':
        return ThermostatState(
          isOn: device['current_data']['metric']['is_on'] ?? false,
          currentTemperature: device['current_data']['metric']['current_temperature'] ?? 21,
          setTemperature: device['current_data']['metric']['target_temperature'] ?? 18
        );
      case 'security lock':
        return SmartLockState(
          isOn: device['current_data']['is_on'] ?? false,
        );
      case 'socket':
        return SocketState(
          isOn: device['current_data']['metric']['is_plugged_in'] ?? false
        );
      default:
        return null;
    }
  }
  Future<Appliance?> getDeviceById(String deviceId) async {
    try {
      // Get all devices
      await getDevices();

      // Filter the list to find the device by ID
      List<Appliance> matchingDevices = applianceModel.allFetch.where(
            (appliance) => appliance.id == deviceId,
      ).toList();

      // Return the first match or null if not found
      return matchingDevices.isNotEmpty ? matchingDevices.first : null;
    } catch (e) {
      print('Error fetching device by ID: $e');
      return null;
    }
  }


  void notifyAll() {
    applianceModel.notifyListeners();
    modeModel.notifyListeners();
    notifyListeners();
  }
}

