import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  SpeakerScreenState createState() => SpeakerScreenState();
}

class SpeakerScreenState extends State<SpeakerScreen> {
  final double _progress = 0;
  bool _isPlaying = false;
  String state1 = "";
  int progress1 = 0;
  String audioState = '';
  int audioProgress = 0;
  Timer? _timer;
  final Duration totalDuration = Duration(minutes: 3); // Total video duration
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screenHeader(),
          _settingOptions(),
          _seekerControls(),
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
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Bed Room",
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

  Widget _settingOptions() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Speakers', style: TextStyle(fontSize: 20)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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


  Widget _seekerControls() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 20,),
          Stack(
            // alignment: Alignment.center, // Aligns children to the center of the stack
            children: [
              CircularSeekBar(
                width: double.infinity,
                height: 250,
                progress: _progress,
                minProgress: 0,
                maxProgress: 100,
                barWidth: 3,
                startAngle: 45,
                sweepAngle: 270,
                strokeCap: StrokeCap.round,
                innerThumbRadius: 5,
                innerThumbStrokeWidth: 3,
                innerThumbColor: Colors.blue,
                progressColor: Colors.blue,
                trackColor: const Color(0xffDDDDDD),
                outerThumbRadius: 5,
                outerThumbStrokeWidth: 5,
                outerThumbColor: Colors.blue,
                animation: false,
                interactive: true,
                valueNotifier: _valueNotifier,
                onEnd: () {
                  // Optional: Handle end of seek
                },
              ),
              // Widget in the center of the circular seek bar
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75),  // Half of the width/height
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(75),  // Match the container's borderRadius
                      child: Image.asset(
                        'assets/images/music.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )

                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("All eyes on me", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                    Text("By someone", style: TextStyle(fontSize: 15))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
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
