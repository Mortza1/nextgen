import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/components/toggle.dart';

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
  late bool isOn;

  @override
  void initState() {
    super.initState();

    // Initialize the progress value from the appliance state
    var state = widget.device.state as LightState;
    isOn = state.isOn;
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
          SizedBox(height: 35,),
          _screenHeader(),
          _seekerControls(_valueNotifier, progress),
        ],
      ),
    );
  }

  Widget _screenHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);  // Goes back one screen
              },
              child: Image.asset(
                'assets/images/cross.png',
                height: 15,
              ),
            ),
            Text(widget.device.title, style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
            ToggleMain(appModel: widget.appModel, device: widget.device)
          ],
        ),
      ),
    );
  }
  Widget deviceOff(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.tag_faces_outlined, color: Color(0xffBBBCC7),)
          ],
        ),
      ),
    );
  }
  Widget _seekerControls(valueNotifier, progress) {
    Timer? seekTimer;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 50,),
          Stack(
            // alignment: Alignment.center, // Aligns children to the center of the stack
            children: [
              CircularSeekBar(
                width: double.infinity,
                height: 300,
                progress: progress,
                minProgress: 0,
                maxProgress: 100,
                barWidth: 2,
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
                      seekTimer?.cancel(); // Cancel previous timer
                      seekTimer = Timer(Duration(milliseconds: 500), () {
                        widget.appModel.setCommand(widget.device.id, 'set_brightness');

                      });
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${value.round()}%',
                                style: TextStyle(
                                    color: Color(0xffCA8A2A),
                                    fontSize: 40,
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
          GestureDetector(
            onTap: (){
              widget.appModel.setCommand(widget.device.id, 'set_rgb');
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD1D1D8), width: 3),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Color(0xffFF4747),
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffD1D1D8), width: 3),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(0xff8247FF),
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffD1D1D8), width: 3),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Color(0xff4BFF47),
                            borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}
