import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';

class LightScreen extends StatefulWidget {
  final AppModel appModel;
  final Appliance device;
  const LightScreen({super.key, required this.appModel, required this.device});

  @override
  LightScreenState createState() => LightScreenState();
}

class LightScreenState extends State<LightScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  late double progress;

  @override
  void initState() {
    super.initState();

    // Initialize the progress value from the appliance state
    var state = widget.device.state as LightState;
    progress = state.brightness.toDouble();

    // Set the initial value of the ValueNotifier
    _valueNotifier.value = progress;

    // Listen to ValueNotifier changes
    _valueNotifier.addListener(() {
      if (mounted) {
        // Use WidgetsBinding.instance.addPostFrameCallback to schedule the update after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // setState(() {
          //   // Update the appliance state when ValueNotifier changes
          //   if (widget.device.state is CurtainState) {
          //     (widget.device.state as CurtainState).opened = _valueNotifier.value;
          //   }
          // });
        });
      }
    });
  }

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
          _seekerControls(_valueNotifier, progress),
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
          Text('Lights', style: TextStyle(fontSize: 20)),
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
  Widget _seekerControls(valueNotifier, progress) {
    Timer? _seekTimer;
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
                height: 280,
                progress: progress,
                minProgress: 0,
                maxProgress: 100,
                barWidth: 3,
                startAngle: 45,
                sweepAngle: 270,
                strokeCap: StrokeCap.round,
                innerThumbRadius: 5,
                innerThumbStrokeWidth: 3,
                innerThumbColor: const Color(0xffCA8A2A),
                progressColor: const Color(0xffCA8A2A),
                trackColor: const Color(0xffDDDDDD),
                outerThumbRadius: 5,
                outerThumbStrokeWidth: 5,
                outerThumbColor: const Color(0xffCA8A2A),
                animation: false,
                interactive: true,
                valueNotifier: _valueNotifier,
                child: ValueListenableBuilder(
                    valueListenable: valueNotifier,
                    builder: (_, double value, __)
                    {
                      _seekTimer?.cancel(); // Cancel previous timer
                      _seekTimer = Timer(Duration(milliseconds: 500), () {
                        widget.appModel.setCommand(widget.device.id, 'set_brightness');

                      });
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${value.round()}%',
                                style: TextStyle(
                                    color: Color(0xffCA8A2A),
                                    fontSize: 35,
                                    fontWeight: FontWeight.w900),
                              ),
                              Text('brightness',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13))
                            ],
                          );
                        }),
          ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xffFEDC97)
                ),
                child: Center(child: Text("Hue", style: TextStyle(color: Color(0xffCA8A2A)),)),
              ),
              SizedBox(width: 10,),
              Container(
                height: 40,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffC4EDD2)
                ),
                child: Center(child: Text("Hue", style: TextStyle(color: Color(0xff008914)),)),
              )
            ],
          )
          
        ],
      ),
    );
  }
}
