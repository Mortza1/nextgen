import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/login.dart';

import '../scopedModel/app_model.dart';

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
          _settingMain()
        ],
      ),
    );
  }

  Widget _settingHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffd9d9d9)
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                widget.model.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage(appModel: widget.model)),
                );
                },
              child: Image.asset('assets/images/man.png', height: 70,),
            ),
            SizedBox(height: 10,),
            Text('Murtaza Mustafa',  style: TextStyle(fontWeight: FontWeight.w900),)
          ],
        ),
      ),
    );
  }
  Widget _settingMain(){
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.74,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Settings", style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Notifications', style: TextStyle(fontSize: 17),),
                          Icon(Icons.chevron_right, size: 20,)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Account', style: TextStyle(fontSize: 17),),
                          Icon(Icons.chevron_right, size: 20,)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Privacy', style: TextStyle(fontSize: 17),),
                          Icon(Icons.chevron_right, size: 20,)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Help', style: TextStyle(fontSize: 17),),
                          Icon(Icons.chevron_right, size: 20,)
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('About', style: TextStyle(fontSize: 17),),
                          Icon(Icons.chevron_right, size: 20,)
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }


}
