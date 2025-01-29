import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

import '../model/appliance.dart';

class ThermostatScreen extends StatefulWidget {
  final Appliance device;
  const ThermostatScreen({super.key, required this.device});

  @override
  ThermostatScreenState createState() => ThermostatScreenState();
}

class ThermostatScreenState extends State<ThermostatScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    // Initialize ValueNotifier with the initial volume
    double currentTemperature = widget.device.state.toMap()['currentTemperature'].toDouble();
    _valueNotifier.value = ((currentTemperature - 16)/14)*100;

    // Listener to sync appliance state with ValueNotifier
    _valueNotifier.addListener(() {
      if (widget.device.state is ThermostatState) {
        (widget.device.state as ThermostatState).currentTemperature = (((_valueNotifier.value/100) * 14) + 16);
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
          _seekerControls(_valueNotifier),
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

  Widget _seekerControls(valueNotifier) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 20,),
          CircularSeekBar(
            width: double.infinity,
            height: 280,
            progress: valueNotifier.value,
            minProgress: 0,
            maxProgress: 100,
            barWidth: 3,
            startAngle: 45,
            sweepAngle: 270,
            strokeCap: StrokeCap.round,
            innerThumbRadius: 5,
            innerThumbStrokeWidth: 3,
            innerThumbColor: Colors.red,
            progressGradientColors: const [Colors.blue, Colors.red],
            progressColor: Colors.blue,
            trackColor: const Color(0xffDDDDDD),
            outerThumbRadius: 5,
            outerThumbStrokeWidth: 5,
            outerThumbColor: Colors.red,
            animation: false,
            interactive: true,
            valueNotifier: valueNotifier,
            onEnd: () {
              // Ensure appliance state updates when interaction ends
              setState(() {
                widget.device.state.toMap()['setTemperature'] = valueNotifier.value.round();
              });
            },
            child: Center(
          child: ValueListenableBuilder(
          valueListenable: valueNotifier,
          builder: (_, double value, __) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${(((valueNotifier.value/100) * 14) + 16).round()}°C', style: TextStyle(color: valueNotifier.value > 60? Colors.red : Colors.blue, fontSize: 35, fontWeight: FontWeight.w900),),
              Text('in 15 minutes', style: TextStyle(color: Colors.black, fontSize: 13))
            ],
          ),),
              ),
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
