import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/assistant_button.dart';
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
import 'components/toggle.dart';
import 'morning.dart';
import 'package:intl/intl.dart';

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
    getUser();
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

  Future<void> getUser() async {
    try {
      await widget.appModel.getUser();
      setState(() {}); // Update UI after fetching devices
    } catch (e) {
      print('Error in fetchDevices: $e');
    }
  }

  Widget _topMyHomeSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.21,
      padding: EdgeInsets.only(top: 50, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/images/profile_female.png', width: 75, height: 75,),
              SizedBox(height: 5,),
              Text(
                "Hello, ${widget.appModel.userData['name']?.split(' ')[0] ?? ''} ☀",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),
              )
            ],
          ),
          Image.asset('assets/images/bell.png',
            width: 45,  // Set the width
            height: 45, // Set the height
            )
        ],
      ),
    );
  }
  Widget _consumptionBox(){
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.18, // Parent container height
          decoration: BoxDecoration(
            color: Color(0xffF9E07F),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffFFEA96)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Energy Consumption', style: TextStyle(color: Color(0xffD3B84F), fontSize: 14, fontWeight: FontWeight.w600),),
                    SizedBox(width: 5,),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: 40,
                      // width: 100,
                      decoration: BoxDecoration(
                        color: Color(0xffE8CA52),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/calender.png'),
                          Text(DateFormat('dd MMM, yyyy').format(DateTime.now()), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xffFFEA96)
                        ),
                        child: Center(
                          child: Image.asset('assets/images/energy.png', height: 25,),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.appModel.homeData['used_today'].toString()}kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900),),
                          Text('Today', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Color(0xffFFEA96)
                        ),
                        child: Center(
                          child: Image.asset('assets/images/plug.png', height: 20,),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.appModel.homeData['used_this_week'].toString()}kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900),),
                          Text('This Week', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900, fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ],
              )

            ],
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
                    fontSize: 19.0, // Increase font size
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
                              image: DecorationImage(image: AssetImage(mode.backImg), fit: BoxFit.cover,),
                              color: const Color(0xffd9d9d9), // Background based on isEnabled
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mode.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w300,
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My room",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                fontFamily: 'Roboto',
              ),
            ),
            Expanded(
              child: GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 2.5,
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
          border: Border.all(color: Color(0x3f000017)),
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
            ['thermostat'].contains(device.type) ? SizedBox():
            ToggleMain(deviceId: device.id, appModel: widget.appModel), // Pass only ID
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
        screen = LightScreen(appModel: widget.appModel, device: device);
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
          _consumptionBox(),
          // _topWidgetSection(model),
          _modeSection(modeModel, model),
          _mainWidgetsSection(model),
          // _assistantButton()
          // AssistantButton()
    ])));
  }
}