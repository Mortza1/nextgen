import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';

class ToggleMain extends StatefulWidget {
  final String deviceId;
  final AppModel appModel;
  const ToggleMain({super.key, required this.deviceId, required this.appModel});

  @override
  State<ToggleMain> createState() => _ToggleMainState();
}

class _ToggleMainState extends State<ToggleMain> {
  bool isLoading = false; // Track loading state for this toggle only

  Future<void> toggleLight(AppModel model) async {
    setState(() {
      isLoading = true; // Show loading indicator only for this button
    });

    var device = await model.getDeviceById(widget.deviceId);
    if (device == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    bool isOn = (device.state as LightState).isOn;
    await model.setCommand(device.id, isOn ? 'turn_off' : 'turn_on');
    await model.getDevices(); // Refresh devices

    setState(() {
      isLoading = false; // Hide loader after update
    });
  }

  Widget LightIcon(LightState state) {
    return Icon(
      state.isOn ? Icons.toggle_on : Icons.toggle_off,
      color: state.isOn ? Colors.green : Colors.black,
      size: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return FutureBuilder<Appliance?>(
          future: model.getDeviceById(widget.deviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(color: Color(0xffE8CA52),),
              ); // Show loading while fetching device
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox(); // Handle no device found
            }

            var device = snapshot.data!;

            return IconButton(
              onPressed: () => toggleLight(model),
              icon: isLoading
                  ? SizedBox(
              height: 15,
              width: 15,
              child: CircularProgressIndicator(color: Color(0xffE8CA52),),
            )
                  : device.type == 'light'
                  ? LightIcon(device.state as LightState)
                  : Icon(
                device.isEnable ? Icons.toggle_on : Icons.toggle_off,
                color: device.isEnable ? Colors.green : Colors.black,
                size: 35,
              ),
            );
          },
        );
      },
    );
  }
}
