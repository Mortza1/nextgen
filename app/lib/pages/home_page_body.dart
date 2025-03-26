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
              Image.asset(widget.appModel.userData['gender'] == 'male' ? 'assets/images/man.png' : 'assets/images/profile_female.png', width: 75, height: 75,),
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
    List<Mode> allModes = model.allFetch;

    // Prioritize active modes first
    List<Mode> sortedModes = [
      ...allModes.where((mode) => mode.isActive()), // Active modes first
      ...allModes.where((mode) => !mode.isActive()), // Inactive modes next
    ];

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
              ],
            ),
            // Display all modes, sorted
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: SingleChildScrollView(
                  child: Column(
                    children: sortedModes.map((mode) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: GestureDetector(
                          onTap: () {
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
                              image: (mode.backImg.isNotEmpty)
                                  ? DecorationImage(
                                image: NetworkImage(mode.backImg),
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
                                    ? Container(
                                  height: MediaQuery.of(context).size.height * 0.04,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(
                                    child: Text('ACTIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),),
                                  ),
                                )
                                    : SizedBox()
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
    // Format the start and end time
    String formattedStartTime = DateFormat('h:mm a').format(mode.startTime);
    String formattedEndTime = DateFormat('h:mm a').format(mode.endTime);

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
                    Text(
                      mode.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 1),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.more_time_rounded, color: Colors.grey, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Scheduled: $formattedStartTime - $formattedEndTime',
                        style: TextStyle(
                          color: Color(0xff7E7979),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Device routine',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.7,
                    ),
                    itemCount: mode.appliances.length,
                    itemBuilder: (BuildContext context, int index) {
                      final appliance = mode.appliances[index];
                      return GestureDetector(
                        onTap: () {
                          if (appliance.type == 'curtain') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CurtainScreen(device: appliance),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffEFEFEF),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      appliance.mainIconString,
                                      height: 15,
                                    ),
                                    SizedBox(height: 5),
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
      padding: const EdgeInsets.only(left: 5, right:5, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: rooms.isNotEmpty
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rooms.map((room) {
            String roomName = room['name'] ?? 'Unnamed Room';
            List<String> deviceIds = List<String>.from(room['devices'] ?? []);

            // Fetch appliances by IDs, safely handle nulls
            List<Appliance> appliances = deviceIds
                .map((deviceId) => model.getApplianceById(deviceId))
                .where((appliance) => appliance != null)
                .cast<Appliance>()
                .toList();

            return appliances.isEmpty ? SizedBox() : Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
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
                    shrinkWrap: true, // Prevents unnecessary scrolling
                    physics: const NeverScrollableScrollPhysics(), // Disable scrolling
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
          }).toList(),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x3f000017)),
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
            // Device Icon and Title
            Expanded(
              child: Column(
                children: [
                  // Device Icon
                  Image.asset(
                    device.mainIconString,
                    height: 15,
                    width: 15,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10), // Add spacing between icon and title

                  // Device Title (with truncation and tooltip)
                  Expanded(
                    child: Tooltip(
                      message: device.title, // Show full title on hover/long-press
                      child: Text(
                        device.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1, // Limit to 1 line
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Toggle Button
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


  @override
  Widget build(BuildContext context) {
    ApplianceModel model = widget.appModel.applianceModel;
    ModeModel modeModel = widget.appModel.modeModel;
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _topMyHomeSection(),
                ConsumptionWidget(
                  homeData: widget.appModel.homeData,
                  model: widget.appModel,
                ),
                _modeSection(modeModel, model),
                _mainWidgetsSection(model),
                SizedBox(height: 80), // Add bottom padding
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 80.0,
          right: 16.0,
          child: AssistantButton(model: widget.appModel),
        ),
      ],
    );
  }

}