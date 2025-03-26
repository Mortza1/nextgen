import 'package:flutter/material.dart';
import '../../scopedModel/app_model.dart';

class AddRoomScreen extends StatefulWidget {
  final AppModel model;
  final Map<String, dynamic>? device;
  const AddRoomScreen({super.key, required this.model, this.device});

  @override
  AddRoomScreenState createState() => AddRoomScreenState();
}

class AddRoomScreenState extends State<AddRoomScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isSaving = false;

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
                    'Setup your room!',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _onSavePressed,
              child: _isSaving
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff00AB5E)),
              )
                  : Text(
                _textController.text.isEmpty ? 'BACK' : 'SAVE',
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
              "Give a name to your room!",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textController, // Ensure _textController is defined in your state
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Bedroom',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle Save Button Press
  void _onSavePressed() async {
    print('hi');
    setState(() {
      _isSaving = true; // Show progress indicator
    });
    widget.model.addRoom(_textController.text);
    setState(() {
      _isSaving = false; // Hide progress indicator
    });

    // Pop back two screens
    Navigator.of(context).pop(); // Pop current screen
    Navigator.of(context).pop(); // Pop previous screen
  }
}