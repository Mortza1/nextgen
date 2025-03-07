import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/auth_ui/login.dart';
import 'package:nextgen_software/pages/settings/notificationSetting.dart';
import 'package:nextgen_software/pages/settings/preferences.dart';
import 'package:nextgen_software/pages/settings/privacy.dart';
import 'package:nextgen_software/pages/settings/profile.dart';

import '../../scopedModel/app_model.dart';

class AddModeInHome extends StatefulWidget {
  final AppModel model;
  const AddModeInHome({super.key, required this.model});

  @override
  AddModeInHomeState createState() => AddModeInHomeState();
}

class AddModeInHomeState extends State<AddModeInHome> {
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
          modes()
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
                  Text('Add Mode', style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget modes(){
    return Column(
      children: widget.model.modeModel.allFetch.map((mode) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: MediaQuery.of(context).size.width * 0.95,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(mode.backImg),
                  fit: BoxFit.cover,
                ),
                color: Color(int.parse('0x${mode.bgColor}')),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mode.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Color(0x87D9D9D9),
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('Remove'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


}
