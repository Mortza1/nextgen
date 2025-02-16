import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/login.dart';
import 'package:nextgen_software/pages/settings/settingButton.dart';

import '../../scopedModel/app_model.dart';

class SettingScreen extends StatefulWidget {
  final AppModel model;
  const SettingScreen({super.key, required this.model});

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _settingHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                IconButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingButtonScreen()),
                  );
                }, icon: Icon(Icons.settings, size: 35),),
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _settingHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffF3F4FC)
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 70,),
          GestureDetector(
            onTap: (){
              widget.model.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(appModel: widget.model)),
              );
              },
            child: Image.asset('assets/images/man.png', height: 120,),
          ),
          SizedBox(height: 10,),
          Text(widget.model.userData['name'],  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),),
          Text(widget.model.userData['email'],  style: TextStyle(fontWeight: FontWeight.w500),),
          SizedBox(height: 30,),
          Container(
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffC2C3CD), width: 2),
              borderRadius: BorderRadius.circular(22)
            ),
            child: Center(
              child: Text('Game scores', style: TextStyle(color: Color(0xffA1A2AA)),),
            ),
          ),
          SizedBox(height: 30,),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 15),
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffC2C3CD), width: 2),
              borderRadius: BorderRadius.circular(44)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                    color: Color(0xffCACBD5),
                    borderRadius: BorderRadius.circular(44)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("My rooms", style: TextStyle(color: Colors.white),),
                      Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),)
                    ],
                  ),
                ),
                Text('Manage', style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 15),
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(44)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.065,
                  decoration: BoxDecoration(
                      color: Color(0xffCACBD5),
                      borderRadius: BorderRadius.circular(44)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("My devices", style: TextStyle(color: Colors.white),),
                      Text('9', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),)
                    ],
                  ),
                ),
                Text('Manage', style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          SizedBox(height: 30,),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffC2C3CD), width: 2),
              borderRadius: BorderRadius.circular(22)
            ),
            child: Center(
              child: 
              Text('Game Acheivements', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 18),),
            ),
          )
        ],
      ),
    );
  }



}
