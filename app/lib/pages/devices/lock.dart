import 'dart:async';

import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';

import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';

class LockScreen extends StatefulWidget {
  final AppModel appModel;
  final Appliance device;
  const LockScreen({super.key, required this.appModel, required this.device});

  @override
  LockScreenState createState() => LockScreenState();
}

class LockScreenState extends State<LockScreen> {
  bool isLocked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 35,),
          _screenHeader(),
          SizedBox(height: 55,),
          lockContainer(),
          SizedBox(height: 25,),
          Text('Tap to unlock, Hold to lock', style: TextStyle(color: Color(0xffBBBCC4), fontWeight: FontWeight.bold, ))
          // _seekerControls(_valueNotifier, progress),
        ],
      ),
    );
  }

  Widget _screenHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Text(widget.device.title, style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
            Icon(Icons.toggle_on, size: 40,)
          ],
        ),
      ),
    );
  }

  Widget lockContainer(){
    return GestureDetector(
      onTap: (){
        setState(() {
          isLocked = !isLocked;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          border: Border.all(color: !isLocked ? Color(0xff4285F4) : Color(0xff4BFF47), width: 3)
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: Color(0xffC2C3CD), width: 8)
          ),
          child: Center(
            child: Image.asset('assets/images/lock_screen.png', height: 80,),
          ),
        ),
      ),
    );
  }

}
