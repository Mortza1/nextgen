import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  final double _progress = 0;
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screenHeader(),
          _settingOptions(),
          _mainCameraFeed(),
          _allCameraGrid()
        ],
      ),
    );
  }

  Widget _screenHeader() {
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
                "Home",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _settingOptions() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Cameras', style: TextStyle(fontSize: 20)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.settings, size: 30, color: Colors.black),
                onPressed: () {},
                tooltip: "Settings",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mainCameraFeed() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: Text('Main feed'),
      ),
    );
  }

  Widget _allCameraGrid() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Expanded(
        child: GridView.builder(
          physics: AlwaysScrollableScrollPhysics(), // Allow vertical scrolling
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 boxes per row
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
            childAspectRatio: 1.7, // Adjust box proportions
          ),
          itemCount: 6, // Total number of boxes
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black), // Background color for the boxes
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Center(
                    child: Text('Camera feed'),
                  )
              ),
            );
          },
        ),
      ),
    );
  }

}
