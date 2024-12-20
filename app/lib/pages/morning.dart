import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/mode.dart';
import 'curtain.dart';

class MorningScreen extends StatefulWidget {
  final Mode mode;
  const MorningScreen({super.key, required this.mode});

  @override
  MorningScreenState createState() => MorningScreenState();
}

class MorningScreenState extends State<MorningScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _screenHeader(),
            _modeBasicCard(),
            _modeDevices(widget.mode),
          ],
        ),
      ),
    );
  }

  Widget _screenHeader() {
    var title = widget.mode.title;
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
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 48,
            child: IconButton(
              icon: Icon(Icons.settings, size: 30, color: Colors.black),
              onPressed: () {},
              tooltip: "Settings",
            ),),
        ],
      ),
    );
  }

  Widget _modeBasicCard(){
    var startTime = widget.mode.startTime;
    var endTime = widget.mode.endTime;
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff32E1A1),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: Icon(Icons.sunny, color: Colors.black,),
                  ),
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From ${DateFormat('h:mm a').format(startTime)}'),
                    Text('To ${DateFormat('h:mm a').format(endTime)}'),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.toggle_off, size: 50, color: Colors.black),
                  onPressed: () {},
                  tooltip: "On",
                ),
                Container(
                  height: 40,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Change timings", style: TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center,),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _modeDevices(Mode model) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Device routine',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 boxes per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 1.7, // Adjust box proportions
              ),
              itemCount: model.appliances.length, // Total number of appliances
              itemBuilder: (BuildContext context, int index) {
                final appliance = model.appliances[index];
                return GestureDetector(
                  onTap: () {
                    if (appliance.type == 'curtain'){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CurtainScreen(device: appliance)),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9), // Inactive appliance color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                appliance.mainIconString, // Dynamic icon path
                                height: 15,
                              ),
                              Text(
                                appliance.title,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.settings,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              // onTap: model.onManageDevices, // Trigger manage devices action
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: const Center(
                  child: Text(
                    'Manage devices',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



}
