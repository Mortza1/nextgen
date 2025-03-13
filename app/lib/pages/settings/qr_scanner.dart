import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nextgen_software/pages/settings/device_settings.dart';

import '../../scopedModel/app_model.dart';

class QRScannerScreen extends StatefulWidget {
  final AppModel model;
  const QRScannerScreen({super.key, required this.model});

  @override
  QRScannerScreenState createState() => QRScannerScreenState();
}

class QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;

  @override
  void dispose() async {
    await _subscription?.cancel();
    await controller.dispose();
    super.dispose();
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (capture.barcodes.isNotEmpty) {
      String scannedData = capture.barcodes.first.rawValue ?? "No Data";

      // Stop the scanner
      controller.stop();

      // Navigate back to the previous screen with the scanned data
      // Navigator.pop(context, scannedData);
      var device = await widget.model.getDevice(scannedData);
      print("Device Data: $device");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeviceSettingsScreen(model: widget.model, device: device),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Color(0xffF3F4FC)
        ),
        child: Column(
          children: [
            SizedBox(height: 30,),
            top(),
            Expanded(
              child: Stack(
                children: [
                  MobileScanner(
                    controller: controller,
                    onDetect: _handleBarcode,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.network(
                      'https://lottie.host/07627f80-4862-46ae-a6d3-13c1050bd9b8/vtlWIj3x67.json',
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget top(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);  // Goes back one screen
              },
              child: Image.asset(
                'assets/images/cross.png',
                height: 15,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Settings', style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold, decoration: TextDecoration.none)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}