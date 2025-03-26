

import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/processing.dart';
import 'package:nextgen_software/pages/components/recorder.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lottie/lottie.dart'; // Import Lottie

class AssistantButton extends StatefulWidget {
  final AppModel model;
  const AssistantButton({super.key, required this.model});

  @override
  _AssistantButtonState createState() => _AssistantButtonState();
}

class _AssistantButtonState extends State<AssistantButton> {
  Color _buttonColor = const Color(0xffFEDC97);
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;
  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (await Permission.microphone.request().isGranted) {
      return true;
    } else {
      final status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
  }

  Future<void> _startRecording() async {
    if (await _checkAndRequestPermissions()) {
      try {
        final tempDir = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${tempDir.path}/audio_$timestamp.wav';

        if (await _audioRecorder.hasPermission()) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: path,
          );

          setState(() {
            _isRecording = true;
            _buttonColor = const Color(0xffFB4242);
          });

          _showRecordingDialog(); // Show the recording dialog
        }
      } catch (e) {
        print('Error starting recorder: $e');
      }
    } else {
      print('Microphone permission not granted.');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      if (path != null) {
        Navigator.of(context).pop();
        _showProcessingDialog();
        setState(() {
          _isRecording = false;
          _buttonColor = const Color(0xffFEDC97);
          _audioPath = path;
        });
        print("Audio recorded at: $path");
        await _sendAudioToServer(path); // Await the sendAudioToServer method
      } else {
        print("Error: Audio recording path is null.");
      }
    } catch (e) {
      print('Error stopping recorder: $e');
    } finally {
      Navigator.of(context).pop(); // Close the dialog
      widget.model.getDevices();
    }
  }

  void _showRecordingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return RecordingDialog(onStop: _stopRecording, isLoading: _isLoading); // Pass isLoading state
      },
    );
  }
  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return ProcessingDialog(); // Pass isLoading state
      },
    );
  }

  Future<void> _sendAudioToServer(String filePath) async {
    try {
      final response = await widget.model.uploadAudio(filePath);
      print('Audio sent successfully: $response');
    } catch (e) {
      print('Error sending audio: $e');
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
            onTap: _startRecording, // Start recording on tap
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffD1D2DA), width: 2.0),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
              ),
              child: Center(
                child: Icon(Icons.mic),
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
}