import 'package:flutter/material.dart';
import 'package:flutter_advanced_seekbar/flutter_advanced_seekbar.dart';
import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:nextgen_software/model/appliance.dart';

class TVScreen extends StatefulWidget {
  final Appliance device;
  const TVScreen({super.key, required this.device});

  @override
  TVScreenState createState() => TVScreenState();
}

class TVScreenState extends State<TVScreen> {
  // bool _isTvOn = widget;
  String state1 = "";
  int progress1 = 0;
  String audioState = '';
  int audioProgress = 0;
  Timer? _timer;
  bool _isPlaying = false;
  final Duration totalDuration = Duration(minutes: 15); // Total video duration


  @override
  Widget build(BuildContext context) {
    var isTvOn = widget.device.isEnable;
    return Scaffold(
      body: Column(
        children: [
          _screenHeader(),
          _settingOptions(isTvOn),
          SizedBox(height: 20),
          isTvOn?
          _videoPlayer():SizedBox(),
        ],
      ),
    );
  }

  Widget _screenHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            onPressed: () {
              Navigator.pop(context, true); // Pass a value indicating that a change happened
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Living Room",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _settingOptions(isTvOn) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Smart Tv', style: TextStyle(fontSize: 20)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              !isTvOn?
              IconButton(
                icon: Icon(Icons.toggle_off, size: 40, color: Colors.black),
                onPressed: () {setState(() {
                  widget.device.isEnable = !widget.device.isEnable;
                });},
                tooltip: "Toggle Power",
              ):
              IconButton(
                icon: Icon(Icons.toggle_on, size: 40, color: Colors.green),
                onPressed: () {
                  setState(() {
                    widget.device.isEnable = !widget.device.isEnable;
                  });
                },
                tooltip: "Toggle Power",
              ),
              IconButton(
                icon: Icon(Icons.settings, size: 30, color: Colors.black),
                onPressed: () {},
                tooltip: "Settings",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _videoPlayer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/movie.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Batman - The Movie',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
              child: ProgressBar(
                barHeight: 3,
                baseBarColor: Color(0xffeeeff3),
                progressBarColor: Colors.red,
                thumbRadius: 5,
                thumbColor: Colors.red,
                thumbGlowRadius: 15,
                bufferedBarColor: Color(0xffFFCCCC),
                progress: Duration(milliseconds: (progress1 / 100 * totalDuration.inMilliseconds).round()),
                buffered: Duration(milliseconds: 2000),
                total: totalDuration,
                onSeek: (duration) {
                  setState(() {
                    progress1 = (duration.inMilliseconds / totalDuration.inMilliseconds * 100).round();
                  });
                },
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous, size: 30, color: Colors.black),
                    onPressed: () {},
                    tooltip: "Previous",
                  ),
                  _isPlaying
                      ? IconButton(
                    icon: Icon(Icons.pause, size: 30, color: Colors.black),
                    onPressed: _stopTimer,
                    tooltip: "Pause",
                  )
                      : IconButton(
                    icon: Icon(Icons.play_arrow, size: 30, color: Colors.black),
                    onPressed: _startTimer,
                    tooltip: "Play",
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 30, color: Colors.black),
                    onPressed: () {},
                    tooltip: "Next",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/speaker.png', height: 20),
              SizedBox(width: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AdvancedSeekBar(
                  Color(0xffeeeff3),
                  10,
                  Colors.deepPurple,
                  fillProgress: true,
                  seekBarStarted: () {
                    setState(() {
                      audioState = "starting";
                    });
                  },
                  seekBarProgress: (v) {
                    setState(() {
                      audioState = "seeking";
                      audioProgress = v;
                    });
                  },
                  seekBarFinished: (v) {
                    setState(() {
                      audioState = "finished";
                      audioProgress = v;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _startTimer() {
    if (_isPlaying) return;
    _isPlaying = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (progress1 < 100) {
          progress1++;
        } else {
          _timer?.cancel();
          _isPlaying = false;
        }
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _timer?.cancel();
      _isPlaying = false;
    });

  }
}
