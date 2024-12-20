import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  LightScreenState createState() => LightScreenState();
}

class LightScreenState extends State<LightScreen> {
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
          _lightSection(),
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

  Widget _lightSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07, // Parent container height
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemCount: 5, // Set the number of items in the list
          itemBuilder: (context, index) {
            // Check if it's the first two boxes
            Color boxColor = (index == 0 || index == 1) ? Color(0xff32E1A1) : Color(0xffefefef);
            // String text = (index == 0 || index == 1) ? 'active' : 'not active';

            return Container(
              width: 120, // Width of each box
              height: MediaQuery.of(context).size.height * 0.1, // Set the box height to match parent container
              margin: EdgeInsets.symmetric(horizontal: 4.0), // Space between boxes
              decoration: BoxDecoration(
                color: boxColor, // Use the appropriate color
                borderRadius: BorderRadius.circular(5), // Rounded corners for boxes
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Light ${index + 1}")
                ],
              ),
            );
          },
        ),
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
                innerThumbColor: const Color(0xffCA8A2A),
                progressColor: const Color(0xffCA8A2A),
                trackColor: const Color(0xffDDDDDD),
                outerThumbRadius: 5,
                outerThumbStrokeWidth: 5,
                outerThumbColor: const Color(0xffCA8A2A),
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
                  child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xffCA8A2A),
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("93%", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
                    Text("Philips hue", style: TextStyle(fontSize: 15))
                  ],
                ),
              )

              
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
