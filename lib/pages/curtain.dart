import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class CurtainScreen extends StatefulWidget {
  const CurtainScreen({super.key});

  @override
  CurtainScreenState createState() => CurtainScreenState();
}

class CurtainScreenState extends State<CurtainScreen> {
  final double _progress = 0;
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
                height: 280,
                progress: _progress,
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
                animation: false,
                interactive: true,
                valueNotifier: _valueNotifier,
                onEnd: () {
                  // Optional: Handle end of seek
                },
              ),
              // Widget in the center of the circular seek bar
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('80%', style: TextStyle(color: Color(0xff8247FF), fontSize: 35, fontWeight: FontWeight.w900),),
                        Text('opened', style: TextStyle(color: Colors.black, fontSize: 13))
                      ],
                    )
                ),
              ),



            ],
          ),
        ],
      ),
    );
  }
}
