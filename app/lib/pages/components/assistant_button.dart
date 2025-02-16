import 'package:flutter/material.dart';
import 'package:record/record.dart';

class AssistantButton extends StatefulWidget {
  const AssistantButton({super.key});

  @override
  _AssistantButtonState createState() => _AssistantButtonState();
}

class _AssistantButtonState extends State<AssistantButton> {
  Color _buttonColor = const Color(0xffFEDC97);
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;

  // Start recording audio
  void _startRecording() async {
    // Check and request permission if needed
    if (await _audioRecorder.hasPermission()) {
      try {
        await _audioRecorder.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
        setState(() {
          _isRecording = true;
          _buttonColor = const Color(0xffFB4242); // Change color while recording
        });
      } catch (e) {
        print('Error starting recorder: $e');
      }
    } else {
      print('Permission not granted');
    }
  }

  // Stop recording audio
  void _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
        _buttonColor = const Color(0xffFEDC97); // Revert color when stopped
      });

      print("Audio recorded at: $path");
      // Here, you can send the audio file to your device control logic
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  Widget _assistantButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width,
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTapDown: (_) => _startRecording(),
            onTapUp: (_) => _stopRecording(),
            onTapCancel: () => _stopRecording(),
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffD1D2DA), width: 2.0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/mic.png',
                  height: 30,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _assistantButton();
  }

  @override
  void dispose() {
    super.dispose();
    _audioRecorder.dispose(); // Don't forget to dispose the recorder
  }
}
