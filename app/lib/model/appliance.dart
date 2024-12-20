import 'package:flutter/material.dart';

class Appliance {
  String id;
  String title;
  String type;
  IconData mainIcon;
  String mainIconString;
  ApplianceState state;
  bool isEnable;

  Appliance({
    this.id = '', // Default value or nullable
    this.title = '',
    required this.type,
    this.mainIcon = Icons.tv,
    this.mainIconString = '',
    required this.state,
    this.isEnable = false,  // Default value for boolean
  });
}
abstract class ApplianceState {
  // Method to return the state as a map
  Map<String, dynamic> toMap();
}

class TVState extends ApplianceState {
  String lastViewed;
  String timestamp;
  int volume;

  TVState({
    this.lastViewed = '',
    this.timestamp = '',
    this.volume = 50,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'lastViewed': lastViewed,
      'timestamp': timestamp,
      'volume': volume,
    };
  }
}

class CurtainState extends ApplianceState {
  double opened; // Percentage open

  CurtainState({this.opened = 0});

  @override
  Map<String, dynamic> toMap() {
    return {
      'opened': opened,
    };
  }
}

class SpeakerState extends ApplianceState {
  int volume;
  String trackTitle;
  String trackAuthor;
  String trackCover;
  Duration currentTimestamp;
  Duration trackTime;

  SpeakerState({
    this.volume = 50,
    this.trackTitle = '',
    this.trackAuthor = '',
    this.trackCover = '',
    this.currentTimestamp = const Duration(milliseconds: 0),
    this.trackTime = const Duration(minutes: 3)

  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'volume': volume,
      'trackTitle': trackTitle,
      'trackCover': trackCover,
      'trackAuthor': trackAuthor,
      'currentTimestamp': currentTimestamp,
      'trackTime': trackTime
    };
  }
}

class LightState extends ApplianceState {
  bool isOn;
  int brightness;

  LightState({
    this.isOn = false,
    this.brightness = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'isOn': isOn,
      'brightness': brightness,
    };
  }
}

class CameraState extends ApplianceState {
  bool isRecording;

  CameraState({this.isRecording = false});

  @override
  Map<String, dynamic> toMap() {
    return {
      'isRecording': isRecording,
    };
  }
}

class ThermostatState extends ApplianceState {
  double currentTemperature;
  double setTemperature;
  String mode;
  int fanSpeed;

  ThermostatState(
      {
        this.currentTemperature = 22.0,
        this.setTemperature = 0.0,
        this.mode = 'cool',
        this.fanSpeed = 0

      });

  @override
  Map<String, dynamic> toMap() {
    return {
      'currentTemperature': currentTemperature,
      'setTemperature': setTemperature,
      'mode' : mode,
      'fanSpeed' : fanSpeed
    };
  }
}