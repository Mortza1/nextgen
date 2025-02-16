import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/auth_ui/login.dart';
import 'package:nextgen_software/pages/settings/notificationSetting.dart';
import 'package:nextgen_software/pages/settings/preferences.dart';
import 'package:nextgen_software/pages/settings/privacy.dart';
import 'package:nextgen_software/pages/settings/profile.dart';

import '../../scopedModel/app_model.dart';

class NotificationsScreen extends StatefulWidget {
  // final AppModel model;
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
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
          SizedBox(height: 40,),
          box()
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
                  Text('Notifications', style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget box(){
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: Color(0xffFAFAFF),
            border: Border.all(color: Color(0x96C2C3CD)),
            borderRadius: BorderRadius.circular(18)
          ),
        ),
        SizedBox(height: 20,),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Color(0xffFAFAFF),
              border: Border.all(color: Color(0x96C2C3CD)),
              borderRadius: BorderRadius.circular(18)
          ),
        )
      ],
    );
  }

}
