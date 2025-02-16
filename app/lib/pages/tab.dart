import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/home_page_body.dart';
import 'package:nextgen_software/pages/overview.dart';
import 'package:nextgen_software/pages/settings/setting.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';

import '../scopedModel/connected_model_appliance.dart';
import 'mode_page.dart';

class CustomTabScreen extends StatefulWidget {
  final AppModel model;
  const CustomTabScreen({super.key, required this.model});

  @override
  _CustomTabScreenState createState() => _CustomTabScreenState();
}

class _CustomTabScreenState extends State<CustomTabScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePageBody(appModel: widget.model),
      ModeScreen(model: widget.model),
      OverviewScreen(),
      SettingScreen(model: widget.model,),
    ];
    return Scaffold(
      body: Stack(
        children: [
          screens[_currentIndex], // Display the current screen
          Positioned(
            bottom: 0, // Adjust distance from the bottom of the screen
            // left: 20,
            // right: 20,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffD2D2DA),
                    width: 2.0
                  )
                )
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem('assets/images/home.png', 0, "dashboard"),
                  _buildNavItem('assets/images/window.png', 1, "overview"),
                  _buildNavItem('assets/images/leaf.png', 2, "profile"),
                  _buildNavItem('assets/images/profile_duck.png', 3, "profile"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String image, int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _currentIndex == index ? Color(0x1f00AB5E) : Colors.transparent,
            border: Border.all(color: _currentIndex == index? Color(0xff00AB5E) : Colors.transparent, width: 2 ),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Image.asset(image, height: 30,)),
    );
  }
}



