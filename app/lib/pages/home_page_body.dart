import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/assistant_button.dart';
import 'package:nextgen_software/pages/components/consumption_dialog.dart';
import 'package:nextgen_software/pages/devices/curtain.dart';
import 'package:nextgen_software/pages/devices/light.dart';
import 'package:nextgen_software/pages/modes/add_mode_in_home.dart';
import 'package:nextgen_software/pages/notifications.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';
import 'package:nextgen_software/scopedModel/connected_mode.dart';
import '../model/appliance.dart';
import '../model/mode.dart';
import '../scopedModel/connected_model_appliance.dart';
import 'devices/lock.dart';
import 'devices/speaker.dart';
import 'devices/thermostat.dart';
import 'devices/tv.dart';
import 'modes/add_mode.dart';
import 'devices/camera.dart';
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
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsScreen()),
              );
            },
            child: Image.asset('assets/images/bell.png',
              width: 45,  // Set the width
              height: 45, // Set the height
              ),
          )
        ],
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
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Roboto',
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddModeInHome(model: widget.appModel,)
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/add.png',
                    width: 25,
                    height: 25,
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
                            // Show Dialog with Mode Details
                            _showModeDetailsDialog(context, mode);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.075,
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              image: mode.backImg != null
                                  ? DecorationImage(
                                image: NetworkImage(mode.backImg!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              color: Color(int.parse('0x${mode.bgColor}')),
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
  void _showModeDetailsDialog(BuildContext context, Mode mode) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0.8),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: mode.backImg != null
                  ? DecorationImage(
                image: NetworkImage(mode.backImg!),
                fit: BoxFit.cover,
              )
                  : null,
              color: Color(int.parse('0x${mode.bgColor}')),
              border: Border.all(width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(mode.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Icon(Icons.toggle_off, color: Colors.black, size: 35,)
                  ],
                ),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1),
                    color: Colors.white
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_time_rounded, color: Colors.grey, size: 20,),
                      SizedBox(width: 5,),
                      Text('Scheduled : 6:00 - 20:00', style: TextStyle(color: Color(0xff7E7979), fontSize: 13, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Align(alignment: Alignment.centerLeft, child: Text('Device routine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
                SizedBox(height: 5,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Expanded(
                    child: GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 boxes per row
                        crossAxisSpacing: 8.0, // Spacing between columns
                        mainAxisSpacing: 8.0, // Spacing between rows
                        childAspectRatio: 1.7, // Adjust box proportions
                      ),
                      itemCount: mode.appliances.length, // Total number of appliances
                      itemBuilder: (BuildContext context, int index) {
                        final appliance = mode.appliances[index];
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
                              color: const Color(0xffEFEFEF), // Inactive appliance color
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(width: 1)
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
                                      SizedBox(height: 5,),
                                      Text(
                                        appliance.title,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _mainWidgetsSection(ApplianceModel model) {
    var rooms = (widget.appModel.homeData['rooms'] as List<dynamic>?) ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.335,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: rooms.isNotEmpty
            ? ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (BuildContext context, int roomIndex) {
            var room = rooms[roomIndex];
            String roomName = room['name'] ?? 'Unnamed Room';
            List<String> deviceIds = List<String>.from(room['devices'] ?? []);

            // Fetch appliances by IDs, safely handle nulls
            List<Appliance> appliances = deviceIds
                .map((deviceId) => model.getApplianceById(deviceId))
                .where((appliance) => appliance != null)
                .cast<Appliance>()
                .toList();

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roomName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: appliances.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildDeviceTile(appliances[index]);
                    },
                  ),
                ],
              ),
            );
          },
        )
            : const Center(
          child: Text(
            'No rooms available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
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
            ToggleMain(device: device, appModel: widget.appModel), // Pass only ID
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
      case "security lock":
        screen = LockScreen(appModel: widget.appModel, device: device);
        break;
      case "speaker":
        screen = SpeakerScreen(device: device);
        break;
      case "thermostat":
        screen = ThermostatScreen(device: device, appModel: widget.appModel,);
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
          // _consumptionBox(),
          ConsumptionWidget(homeData: widget.appModel.homeData),
          // _topWidgetSection(model),
          _modeSection(modeModel, model),
          _mainWidgetsSection(model),
          SizedBox(height: 40,)
          // _assistantButton()
          // AssistantButton()
    ])));
  }

}