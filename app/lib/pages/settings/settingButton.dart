import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/login.dart';
import 'package:nextgen_software/pages/settings/notificationSetting.dart';
import 'package:nextgen_software/pages/settings/preferences.dart';
import 'package:nextgen_software/pages/settings/privacy.dart';
import 'package:nextgen_software/pages/settings/profile.dart';

import '../../scopedModel/app_model.dart';

class SettingButtonScreen extends StatefulWidget {
  // final AppModel model;
  const SettingButtonScreen({super.key});

  @override
  SettingButtonScreenState createState() => SettingButtonScreenState();
}

class SettingButtonScreenState extends State<SettingButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: main()
    );
  }

  Widget main(){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffF3F4FC)
      ),
      child: Column(
        children: [
          SizedBox(height: 40,),
          top(),
          SizedBox(height: 20,),
          options(),
          SizedBox(height: 20,),
          supportBox(),
          SizedBox(height: 10,),
          signout()

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
                  Text('Settings', style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget options(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Account', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: ()=>{
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreferenceScreen()),
                  )
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: (MediaQuery.of(context).size.height * 0.29)/4,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: 2))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Preferences', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    )
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: (MediaQuery.of(context).size.height * 0.29)/4,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: 2))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Profile', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationSettingScreen()),
                    )
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: (MediaQuery.of(context).size.height * 0.29)/4,
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: 2))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Notifications', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacySettingScreen()),
                    )
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: (MediaQuery.of(context).size.height * 0.29)/4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text('Privacy Settings', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
  Widget supportBox(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Support', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: (MediaQuery.of(context).size.height * 0.29)/4,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: 2))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text('Help Center', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: (MediaQuery.of(context).size.height * 0.29)/4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text('Feedback', style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
  Widget signout(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0x96C2C3CD), width: 5),
          borderRadius: BorderRadius.circular(18)
      ),
      child: Center(
        child: Text('Sign Out', style: TextStyle(color: Color(0xff5CC093), fontSize: 19, fontWeight: FontWeight.bold),),
      ),
    );
  }


}
