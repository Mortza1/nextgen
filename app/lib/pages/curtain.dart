import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

import '../model/appliance.dart';

class CurtainScreen extends StatefulWidget {
  final Appliance device;
  const CurtainScreen({super.key, required this.device});


  @override
  CurtainScreenState createState() => CurtainScreenState();
}

class CurtainScreenState extends State<CurtainScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  late double progress;
  @override
  void initState() {
    super.initState();

    // Initialize the progress value from the appliance state
    progress = widget.device.state.toMap()['opened'].toDouble();

    // Set the initial value of the ValueNotifier
    _valueNotifier.value = progress;

    // Listen to ValueNotifier changes
    _valueNotifier.addListener(() {
      if (mounted) {
        // Use WidgetsBinding.instance.addPostFrameCallback to schedule the update after the build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            // Update the appliance state when ValueNotifier changes
            if (widget.device.state is CurtainState) {
              (widget.device.state as CurtainState).opened = _valueNotifier.value;
            }
          });
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
              Navigator.pop(context, widget.device);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Bedroom",
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
          Text('Smart curtains', style: TextStyle(fontSize: 20)),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 20,),
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
            innerThumbColor: Color(0xff8247FF),
            progressColor: Color(0xff8247FF),
            trackColor: const Color(0xffDDDDDD),
            outerThumbRadius: 5,
            outerThumbStrokeWidth: 5,
            outerThumbColor: Color(0xff8247FF),
            valueNotifier: valueNotifier,
            animation: false,
            interactive: true,
            onEnd: (){
              setState(() {
                widget.device.state.toMap()['opened'] = progress;
              });

            },
            child: Center(
              child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (_, double value, __) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${value.round()}%', style: TextStyle(color: Color(0xff8247FF), fontSize: 35, fontWeight: FontWeight.w900),),
                      Text('opened', style: TextStyle(color: Colors.black, fontSize: 13))
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
