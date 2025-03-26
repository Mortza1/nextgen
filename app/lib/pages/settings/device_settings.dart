import 'package:flutter/material.dart';
import '../../scopedModel/app_model.dart';

class DeviceSettingsScreen extends StatefulWidget {
  final AppModel model;
  final Map<String, dynamic>? device;
  const DeviceSettingsScreen({super.key, required this.model, this.device});

  @override
  DeviceSettingsScreenState createState() => DeviceSettingsScreenState();
}

class DeviceSettingsScreenState extends State<DeviceSettingsScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedRoom;
  List<String> _rooms = [];
  String _deviceType = 'Smart Light';
  bool _isSaving = false; // Track whether the save operation is in progress

  @override
  void initState() {
    super.initState(); // Always call super.initState() first

    // Extract room names from widget.model.homeData['rooms']
    var roomsData = widget.model.homeData['rooms'];
    if (roomsData != null && roomsData is List) {
      _rooms = roomsData.map<String>((room) => room['name'] as String).toList();
    }

    // Initialize _selectedRoom with the first room in the list (if available)
    if (_rooms.isNotEmpty) {
      _selectedRoom = _rooms.first;
    }

    // Initialize _deviceType based on the device data passed to the widget
    if (widget.device != null && widget.device!.containsKey('type')) {
      _deviceType = widget.device!['type'];
    }

    // Initialize _textController with the device name if available
    if (widget.device != null && widget.device!.containsKey('name')) {
      _textController.text = widget.device!['name'];
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: main(),
    );
  }

  Widget main() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xffF3F4FC)),
      child: Column(
        children: [
          SizedBox(height: 40),
          top(),
          SizedBox(height: 40),
          fields(),
        ],
      ),
    );
  }

  Widget top() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Setup your device!',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _isSaving ? null : _onSavePressed, // Disable button when saving
              child: _isSaving
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00AB5E)),
              )
                  : Text(
                'SAVE',
                style: TextStyle(
                    color: Color(0xff00AB5E), fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fields() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField for Device Name
            Text(
              "Give a name to your device!",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController, // Ensure _textController is defined in your state
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Bedroom light?',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Dropdown for Room Selection
            Text(
              "Select a room for the device",
              style: TextStyle(fontSize: 17),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedRoom, // Ensure _selectedRoom is defined in your state
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRoom = newValue;
                });
              },
              items: _rooms.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Text to Display Device Type
            Row(
              children: [
                Text(
                  "Device Type: ",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(width: 10),
                Text(
                  _deviceType, // Ensure _deviceType is defined in your state
                  style: TextStyle(fontSize: 17, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Handle Save Button Press
  void _onSavePressed() async {
    setState(() {
      _isSaving = true; // Show progress indicator
    });

    // Call the addDevice method
    widget.model.addDevice(widget.device?['_id'], _textController.text, _selectedRoom ?? '');
    widget.model.getDevices();
    setState(() {
      _isSaving = false; // Hide progress indicator
    });

    // Pop back two screens
    Navigator.of(context).pop(); // Pop current screen
    Navigator.of(context).pop(); // Pop previous screen
  }
}