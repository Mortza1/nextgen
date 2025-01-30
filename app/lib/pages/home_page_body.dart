import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/curtain.dart';
import 'package:nextgen_software/pages/light.dart';
import 'package:nextgen_software/pages/speaker.dart';
import 'package:nextgen_software/pages/thermostat.dart';
import 'package:nextgen_software/pages/tv.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';
import 'package:nextgen_software/scopedModel/connected_mode.dart';

import '../scopedModel/connected_model_appliance.dart';
import 'add_mode.dart';
import 'camera.dart';
import 'morning.dart';

class HomePageBody extends StatefulWidget {
  final AppModel appModel;
  const HomePageBody({super.key, required this.appModel});

  @override
  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  bool _needsRebuild = false;
  Color _buttonColor = const Color(0xffFEDC97);

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      await widget.appModel.getDevices();
      setState(() {}); // Update UI after fetching devices
    } catch (e) {
      print('Error in fetchDevices: $e');
    }
  }
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
  Widget _topWidgetSection(ApplianceModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07, // Parent container height
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemCount: model.allFetch.length, // Use the dynamic model list count
          itemBuilder: (context, index) {
            // Sort the list so enabled devices come first
            var sortedList = List.from(model.allFetch)
              ..sort((a, b) => (b.isEnable ? 1 : 0).compareTo(a.isEnable ? 1 : 0));
            bool isEnabled = sortedList[index].isEnable;
            Color boxColor = isEnabled ? Color(0xff32E1A1) : Color(0xffefefef);
            String text = isEnabled ? 'active' : 'not active';

            return GestureDetector(
              onTap: () async {
                String cmd = isEnabled? 'turn_off' : 'turn_on';
                await widget.appModel.setCommand(cmd); // Wait for the async operation
                setState(() {
                  sortedList[index].isEnable = !isEnabled; // Then update the state
                });
              },

              child: Container(
                height: MediaQuery.of(context).size.height * 0.1, // Set box height
                width: 120, // Box width
                margin: EdgeInsets.symmetric(horizontal: 4.0), // Space between boxes
                decoration: BoxDecoration(
                  color: boxColor, // Use dynamic color
                  borderRadius: BorderRadius.circular(5), // Rounded corners
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      blurRadius: 10,
                      offset: Offset(0, 10),
                      color: Colors.grey.shade300,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(sortedList[index].mainIconString, height: 20),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          sortedList[index].title, // Dynamic title
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          text, // Dynamic status
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _modeSection(ModeModel model, ApplianceModel deviceModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        height: MediaQuery.of(context).size.height * 0.255,
        child: Column(
          children: [
            // Header Row with "Modes" text and Add button
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modes',
                  style: TextStyle(
                    fontSize: 23.0, // Increase font size
                    fontWeight: FontWeight.w600, // Make text bold
                    fontFamily: 'Roboto', // Optional: change the font family
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddModeScreen(
                        model: deviceModel,
                        modeModel: model,
                      )),
                    );

                    // Check if TVScreen passed back the result to trigger rebuild
                    if (result == true) {
                      setState(() {
                        _needsRebuild = true;
                      });
                    }
                  },
                  child: Image.asset(
                    'assets/images/add.png',
                    width: 25, // Set the width
                    height: 25, // Set the height
                  ),
                ),
              ],
            ),
            // Scrollable List of Modes
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: SingleChildScrollView(
                  child: Column(
                    children: model.allFetch.map((mode) {
                      // Use dynamic modes from the model
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            // Dynamic navigation based on mode title
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MorningScreen(mode: mode),
                              ),
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffd9d9d9), // Background based on isEnabled
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mode.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                mode.isActive()
                                    ? const Icon(Icons.toggle_on,
                                    color: Colors.green, size: 40)
                                    : const Icon(Icons.toggle_off,
                                    color: Colors.black, size: 40),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _mainWidgetsSection(ApplianceModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.335,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently used devices",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.7,
                ),
                itemCount: model.allFetch.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildDeviceTile(model.allFetch[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDeviceTile(device) {
    return GestureDetector(
      onTap: () => _navigateToDeviceScreen(device),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: const Offset(0, 5),
              color: device.isEnable ? Colors.grey.shade300 : const Color(0xfff1f0f2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(device.mainIconString, height: 15),
                Text(device.title),
              ],
            ),
            IconButton(
              onPressed: () => setState(() {
                device.isEnable = !device.isEnable;
              }),
              icon: Icon(
                device.isEnable ? Icons.toggle_on : Icons.toggle_off,
                color: device.isEnable ? Colors.green : Colors.black,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _navigateToDeviceScreen(device) async {
    Widget? screen;

    switch (device.type) {
      case "tv":
        screen = TVScreen(device: device);
        break;
      case "light":
        screen = LightScreen();
        break;
      case "speaker":
        screen = SpeakerScreen(device: device);
        break;
      case "thermostat":
        screen = ThermostatScreen(device: device);
        break;
      case "curtain":
        screen = CurtainScreen(device: device);
        break;
      case "camera":
        screen = CameraScreen();
        break;
    }

    if (screen != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen!),
      );

      if (result == true) {
        setState(() {
          _needsRebuild = true;
        });
      }
    }
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
    ApplianceModel model = widget.appModel.applianceModel;
    ModeModel modeModel = widget.appModel.modeModel;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          _topMyHomeSection(),
          _topWidgetSection(model),
          _modeSection(modeModel, model),
          _mainWidgetsSection(model),
          _assistantButton()

    ])));
  }
}