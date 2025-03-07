import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "https://844a-91-74-78-5.ngrok-free.app";

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
      throw Exception('Failed to fetched user');
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

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

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

      print('Sending request to: $url');
      print('Headers: $headers');
      print('Body: $body');

      final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
