import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/components/toggle.dart';

import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';


class ThermostatScreen extends StatefulWidget {
  final Appliance device;
  final AppModel appModel;
  const ThermostatScreen({super.key, required this.device, required this.appModel});

  @override
  ThermostatScreenState createState() => ThermostatScreenState();
}

class ThermostatScreenState extends State<ThermostatScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();

    // Initialize ValueNotifier with the initial volume
    double currentTemperature = widget.device.state.toMap()['setTemperature'].toDouble();
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
          SizedBox(height: 35,),
          _screenHeader(),
          SizedBox(height: 50,),
          Text('Living Room', style: TextStyle(color: Color(0xff8247FF), fontWeight: FontWeight.bold, fontSize: 18),),
          _seekerControls(_valueNotifier),
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

  Widget _seekerControls(valueNotifier) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      // height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        children: [
          SizedBox(height: 20,),
          Stack(
            children: [
              CircularSeekBar(
                width: double.infinity,
                height: 300,
                progress: valueNotifier.value,
                minProgress: 0,
                maxProgress: 100,
                barWidth: 2,
                startAngle: 30,
                sweepAngle: 300,
                strokeCap: StrokeCap.round,
                innerThumbRadius: 0,
                innerThumbStrokeWidth: 3,
                innerThumbColor: Color(0xff8247FF),
                progressColor: Color(0xff8247FF),
                trackColor: const Color(0xffDDDDDD),
                outerThumbRadius: 0,
                outerThumbStrokeWidth: 0,
                outerThumbColor: Color(0xff8247FF),
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
                  Text('Changing to', style: TextStyle(color: Colors.black, fontSize: 13)),
                  Text('${(((valueNotifier.value/100) * 14) + 16).round()}°C', style: TextStyle(color: valueNotifier.value > 60? Colors.red : Color(0xff8247FF), fontSize: 35, fontWeight: FontWeight.w900),),

                ],
              ),),
                  ),
              ),
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (valueNotifier.value > 0) {
                            valueNotifier.value -= (100 / 14); // Decrease by 1°C (100% / 14 = ~7.14%)
                            if (valueNotifier.value < 0) valueNotifier.value = 0; // Ensure value doesn't go below 0
                          }
                          setState(() async {
                            await widget.appModel.setCommand(widget.device.id, 'decrease_temp');
                            await widget.appModel.getDevices();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: Color(0x99C2C3CD), width: 3)
                          ),
                          child: Center(
                            child: Text('-', style: TextStyle(color: Color(0xff8247FF), fontSize: 22, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      SizedBox(width: 25,),
                      GestureDetector(
                        onTap: () {
                          if (valueNotifier.value < 100) {
                            valueNotifier.value += (100 / 14); // Increase by 1°C (100% / 14 = ~7.14%)
                            if (valueNotifier.value > 100) valueNotifier.value = 100; // Ensure value doesn't go above 100
                          }
                          setState(() async {
                            await widget.appModel.setCommand(widget.device.id, 'increase_temp');
                            await widget.appModel.getDevices();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Color(0x99C2C3CD), width: 3)
                          ),
                          child: Center(
                            child: Text('+', style: TextStyle(color: Color(0xff8247FF), fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  color: Color(0x52D9D9D9),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Text('Indoor ${(widget.device.state as ThermostatState).currentTemperature}°C', style: TextStyle(color: Color(0xffABACB8), fontWeight: FontWeight.bold, fontSize: 17),)),
              ),
              SizedBox(width: 15,),
              GestureDetector(
                onTap: (){
                  setState(() async {
                    await widget.appModel.setCommand(widget.device.id, 'set_fan_speed');
                    await widget.appModel.getDevices();
                  });
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Color(0x52D9D9D9),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Center(child: Text('Fan Speed 49%', style: TextStyle(color: Color(0xffABACB8), fontWeight: FontWeight.bold, fontSize: 17),)),
                ),
              )
            ],
          )

        ],
      ),
    );
  }
}
