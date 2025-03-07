import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';

class ToggleMain extends StatefulWidget {
  final Appliance device;
  final AppModel appModel;

  const ToggleMain({
    super.key,
    required this.appModel,
    required this.device,
  });

  @override
  State<ToggleMain> createState() => _ToggleMainState();
}

class _ToggleMainState extends State<ToggleMain> {
  bool isLoading = false;
  late String deviceId;

  @override
  void initState() {
    super.initState();
    deviceId = widget.device.id;
  }

  // Generic toggle method for all device types
  Future<void> toggleDevice(AppModel model) async {
    setState(() {
      isLoading = true;
    });

    var device = widget.device;
    if (device == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Handle device-specific commands
    String command;
    switch (device.type) {
      case 'light':
        command = (device.state as LightState).isOn ? 'turn_off' : 'turn_on';
        break;
      case 'socket':
        command = (device.state as SocketState).isOn ? 'unplug' : 'plug_in';
        break;
      case 'thermostat':
        command = (device.state as ThermostatState).isOn ? 'plug_out' : 'plug_in';
      case 'security lock':
        command = (device.state as SmartLockState).isOn ? 'unplug' : 'plug_in';
      default:
        command = 'toggle'; // Default command
    }

    await model.setCommand(device.id, command);
    await model.getDevices(); // Refresh devices

    setState(() {
      isLoading = false;
    });
  }

  // Factory method for device icons
  Widget getDeviceIcon(Appliance device) {
    if (isLoading) {
      return SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(color: Color(0xffE8CA52)),
      );
    }

    switch (device.type) {
      case 'light':
        return _buildIcon((device.state as LightState).isOn);
      case 'socket':
        return _buildIcon((device.state as SocketState).isOn);
      case 'thermostat':
        return _buildIcon((device.state as ThermostatState).isOn);
      case 'security lock':
        return _buildIcon((device.state as SmartLockState).isOn);
      default:
        return _buildIcon(device.isEnable);
    }
  }

  // Helper method to build icons
  Widget _buildIcon(bool isOn) {
    return Icon(
      isOn ? Icons.toggle_on : Icons.toggle_off,
      color: isOn ? Colors.green : Colors.black,
      size: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return FutureBuilder<Appliance?>(
          future: model.getDeviceById(deviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(color: Color(0xffE8CA52)),
              );
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox(); // Handle no device found
            }

            var device = snapshot.data!;

            return IconButton(
              onPressed: () => toggleDevice(model),
              icon: getDeviceIcon(device),
            );
          },
        );
      },
    );
  }
}