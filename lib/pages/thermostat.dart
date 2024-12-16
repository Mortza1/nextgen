import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class ThermostatScreen extends StatefulWidget {
  const ThermostatScreen({super.key});

  @override
  ThermostatScreenState createState() => ThermostatScreenState();
}

class ThermostatScreenState extends State<ThermostatScreen> {
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
                "Home",
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
          Text('Thermostat', style: TextStyle(fontSize: 20)),
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
                height: MediaQuery.of(context).size.height * 0.35,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('23', style: TextStyle(color: Colors.blue, fontSize: 35, fontWeight: FontWeight.w900),),
                      Text('in 15 minutes', style: TextStyle(color: Colors.black, fontSize: 13))
                    ],
                  )
                ),
              ),



            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 80,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0x664285F4)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.severe_cold, color: Colors.white,),
                    SizedBox(width: 10,),
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Mode", style: TextStyle(color: Color(0xff4285F4), fontWeight: FontWeight.w900),),
                        Text("Cool", style: TextStyle(fontWeight: FontWeight.w500),),
                      ],
                    )),
                  ],
                ),
              ),
              SizedBox(width: 10,),
              Container(
                height: 80,
                width: 130,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffd9d9d9)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wind_power, color: Colors.black,),
                    SizedBox(width: 10,),
                    Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Fan", style: TextStyle( fontWeight: FontWeight.w900),),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}
