import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://orange-friends-hope.loca.lt";

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = '$baseUrl/auth/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> addRoom(String hubId, String name ) async {
    final url = '$baseUrl/device/add_room';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'hub_id' : hubId, 'name' : name});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add room');
    }
  }

  Future<Map<String, dynamic>> updateSettings(String userId, bool value, List<String> path) async {
    final url = '$baseUrl/auth/update-settings';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id' : userId, 'value' : value, 'path' : path});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update settings');
    }
  }

  Future<Map<String, dynamic>> updateUser(String userId, String key, String value) async {
    final url = '$baseUrl/auth/update-user';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id' : userId, 'key' : key, 'value' : value});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<Map<String, dynamic>> getUser(String userId, String homeId) async {
    final url = '$baseUrl/auth/user';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id' : userId, 'home_id' : homeId});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetched user');
    }
  }

  Future<Map<String, dynamic>> addMode(String homeId, Map<String, dynamic> mode) async {
    final url = '$baseUrl/device/add_mode';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'home_id' : homeId, 'mode' : mode});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add mode');
    }
  }

  Future<Map<String, dynamic>> uploadAudio(String filePath) async {
    final url = '$baseUrl/auth/upload-audio';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to upload audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading audio: $e');
    }
  }

  Future<Map<String, dynamic>> addDevice(String hubId, String deviceId, String name, String room) async {
    final url = '$baseUrl/device/register_device';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'hub_id' : hubId, 'device_id' : deviceId, 'device_name': name, 'device_room' : room});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add device`');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String token, String password) async {
    final url = '$baseUrl/auth/register-dweller';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password, 'name': name, 'token': token});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<Map<String, dynamic>> getDevice(String deviceId) async {
    final url = '$baseUrl/device/get_device';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'device_id': deviceId});

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );


    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch device');
    }
  }


  Future<Map<String, dynamic>> getDevices(String userId, [String hubId = ""]) async {
    final url = '$baseUrl/device/get_devices';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'user_id': userId, 'hub_id': hubId});

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get devices: ${response.body}');
      }
    } catch (e) {
      print('Error in getDevices: $e');
      rethrow; // Re-throw the exception to propagate it
    }
  }



  Future<Map<String, dynamic>> setCommand(String deviceId, String command) async {
    try {
      final url = '$baseUrl/device/update_device';
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'device_id': deviceId, 'command': command});

      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to toggle light: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error in toggleLight: $e');
      rethrow;
    }
  }



}
