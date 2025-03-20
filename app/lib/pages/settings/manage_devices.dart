import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/snackbar.dart';
import 'package:nextgen_software/pages/settings/qr_scanner.dart';

import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';
import '../../scopedModel/connected_model_appliance.dart';

class ManageDevicesScreen extends StatefulWidget {
  final AppModel model;
  const ManageDevicesScreen({super.key, required this.model});

  @override
  ManageDevicesScreenState createState() => ManageDevicesScreenState();
}

class ManageDevicesScreenState extends State<ManageDevicesScreen> {
  String? _scannedData; // Store the scanned data

  // Navigate to the QRScannerScreen and wait for the result
  Future<void> _navigateToQRScanner(BuildContext context) async {
    final scannedData = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen(model: widget.model,)),
    );

    if (scannedData != null) {
      setState(() {
        _scannedData = scannedData;
      });

      // Show a SnackBar indicating the device is being connected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Device is being connected: $scannedData")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: main(),
    );
  }

  Widget main() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xffF3F4FC)),
      child: Column(
        children: [
          SizedBox(height: 40),
          top(),
          SizedBox(height: 40),
          options(widget.model.applianceModel),
          SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){showComingSoonSnackBar(context, 'Action denied');},
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC2C3CD), width: 2),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                          'Remove Device',
                          style: TextStyle(
                              color: Color(0xff00AB5E),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToQRScanner(context),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC2C3CD), width: 2),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                          'Add Device',
                          style: TextStyle(
                              color: Color(0xff00AB5E),
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget top() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Manage Devices',
                      style: TextStyle(
                          color: Color(0xffAFB0BA),
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('DONE',
                    style: TextStyle(
                        color: Color(0xff00AB5E), fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget options(ApplianceModel applianceModel) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffC2C3CD), width: 2),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                ...applianceModel.allFetch.asMap().entries.map((entry) {
                  int index = entry.key;
                  Appliance appliance = entry.value;

                  return buildOptionRow(
                    title: appliance.title, // Use name from the model
                    isLast: index == applianceModel.allFetch.length - 1, // Mark last item
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each option row with a toggle
  Widget buildOptionRow({required String title, bool isLast = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: (MediaQuery.of(context).size.height * 0.31) / 4,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: isLast ? Colors.transparent : Color(0xffC2C3CD),
                  width: isLast ? 0 : 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                title,
                style: TextStyle(
                    color: Color(0xffA1A2AA),
                    fontWeight: FontWeight.bold,
                    fontSize: 17)),
          ],
        ),
      ),
    );
  }
}