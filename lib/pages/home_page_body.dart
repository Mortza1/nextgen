import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/curtain.dart';
import 'package:nextgen_software/pages/light.dart';
import 'package:nextgen_software/pages/speaker.dart';
import 'package:nextgen_software/pages/thermostat.dart';
import 'package:nextgen_software/pages/tv.dart';

import '../scopedModel/connectedModel.dart';
import 'camera.dart';
import 'morning.dart';

class HomePageBody extends StatefulWidget {
  final ApplianceModel model;
  const HomePageBody({super.key, required this.model});

  // HomePageBody(this.model);



  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  Color _buttonColor = const Color(0xffFEDC97);
  Widget _topMyHomeSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Home',
            style: TextStyle(
              fontSize: 20.0, // Increase font size
              fontWeight: FontWeight.w900, // Make text bold
              fontFamily: 'Roboto', // Optional: change the font family (default is 'Roboto')
            ),
          ),
          Image.asset('assets/images/add.png',
            width: 25,  // Set the width
            height: 25, // Set the height
            )
        ],
      ),
    );
  }
  Widget _topWidgetSection() {
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
            String text = (index == 0 || index == 1) ? 'active' : 'not active';

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
                  Image.asset('assets/images/tv.png', height: 20,),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("TV",
                        style: TextStyle(
                          fontSize: 10
                        ),),
                      Text(text,
                        style: TextStyle(
                            fontSize: 10
                        ),)
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _modeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        height: MediaQuery.of(context).size.height * 0.255,
        child: Column(
          children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Modes',
              style: TextStyle(
                fontSize: 23.0, // Increase font size
                fontWeight: FontWeight.w600, // Make text bold
                fontFamily: 'Roboto', // Optional: change the font family (default is 'Roboto')
              ),
            ),
            Image.asset('assets/images/add.png',
              width: 25,  // Set the width
              height: 25, // Set the height
            )
          ],
        ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MorningScreen(title: 'Morning Scene',)),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        width: MediaQuery.of(context).size.width * 0.95,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Morning scene", style: TextStyle(fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w800),),
                            Image.asset('assets/images/switch.png', height:35,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MorningScreen(title: 'Night Scene',)),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        width: MediaQuery.of(context).size.width * 0.95,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Night scene", style: TextStyle(fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w800),),
                            Image.asset('assets/images/switch.png', height:35,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
  Widget _mainWidgetsSection() {
    return Padding(
        padding: const EdgeInsets.symmetric( horizontal: 5),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.335,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Frequently used devices",
                    style: TextStyle(
                      fontSize: 18.0, // Increase font size
                      fontWeight: FontWeight.w600, // Make text bold
                      fontFamily: 'Roboto', // Optional: change the font family (default is 'Roboto')
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5), // Add spacing between title and grid
              Expanded(
                child: GridView.builder(
                  physics: AlwaysScrollableScrollPhysics(), // Allow vertical scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 boxes per row
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio: 1.7, // Adjust box proportions
                  ),
                  itemCount: 8, // Total number of boxes
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        if (index == 0) { // Check if it's the first tile
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TVScreen()),
                          );
                        }
                        if (index == 1) { // Check if it's the first tile
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LightScreen()),
                          );
                        }
                        if (index == 2) { // Check if it's the first tile
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SpeakerScreen()),
                          );
                        }
                        if (index == 3) { // Check if it's the first tile
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ThermostatScreen()),
                          );
                        }
                        if (index == 4) { // Check if it's the first tile
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CurtainScreen()),
                        );
                        }
                        if (index == 5) { // Check if it's the first tile
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraScreen()),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xffd9d9d9), // Background color for the boxes
                          borderRadius: BorderRadius.circular(10.0), // Rounded corners
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/tv.png', height: 15),
                                Text("Smart Tv"),
                                Text("1 device")
                              ],
                            ),
                            Image.asset('assets/images/switch.png', height: 30),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )

        )
    );
  }

  Widget _assistantButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.11,
        child: Center(
          child: GestureDetector(
            onTapDown: (_) {
              // Change the color when the button is pressed
              setState(() {
                _buttonColor = Color(0xffFB4242); // Change to your desired color
              });
            },
            onTapUp: (_) {
              // Revert the color when the button is released
              setState(() {
                _buttonColor = const Color(0xffFEDC97); // Revert to the original color
              });
            },
            onTapCancel: () {
              // Revert the color if the tap is canceled
              setState(() {
                _buttonColor = const Color(0xffFEDC97);
              });
            },
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                color: _buttonColor, // Use the state variable for color
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/mic.png',
                  height: 25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          _topMyHomeSection(),
          _topWidgetSection(),
          _modeSection(),
          _mainWidgetsSection(),
          _assistantButton()

    ])));
  }
}