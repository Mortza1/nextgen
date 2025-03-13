import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/auth_ui/login.dart';
import 'package:nextgen_software/pages/components/snackbar.dart';
import 'package:nextgen_software/pages/settings/notificationSetting.dart';
import 'package:nextgen_software/pages/settings/preferences.dart';
import 'package:nextgen_software/pages/settings/privacy.dart';
import 'package:nextgen_software/pages/settings/profile.dart';

import '../../model/appliance.dart';
import '../../scopedModel/app_model.dart';

class RoomScreen extends StatefulWidget {
  final List<String> roomDevices;
  final String title;
  final AppModel model;
  const RoomScreen({super.key, required this.roomDevices, required this.title, required this.model});

  @override
  RoomScreenState createState() => RoomScreenState();
}

class RoomScreenState extends State<RoomScreen> {
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
          SizedBox(height: 40,),
          GestureDetector(
            onTap: (){showComingSoonSnackBar(context, 'action denied');},
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('DELETE', style: TextStyle(color: Color(0xffCC0202), fontWeight: FontWeight.bold),),
                    SizedBox(width: 5,),
                    Icon(Icons.delete, color: Color(0xffCC0202), size: 20,)
                  ],
                ),
              ),
            ),
          )

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
            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Color(0xffC2C3CD), size: 18,)),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title, style: TextStyle(color: Color(0xffAFB0BA), fontSize: 19, fontWeight: FontWeight.bold),),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget options(){
    List<Appliance> appliances = [];

    for (String deviceId in widget.roomDevices) {
      Appliance? appliance = widget.model.applianceModel.getApplianceById(deviceId);
      if (appliance != null) {
        appliances.add(appliance);
      }
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Devices', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)
            ),
            child: Column(
              children: [
                ...appliances.asMap().entries.map((entry) {
              int index = entry.key;
              var room = entry.value;
              String roomName = room.title;
              // List<String> deviceList = List<String>.from(room['devices'] ?? []);
              //
              return buildOptionRow(
                title: roomName, // Pass the room name as the title
                isLast: index == widget.roomDevices.length - 1, // Mark last item
              );
            })
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget buildOptionRow(
      {required String title, bool isLast = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: (MediaQuery.of(context).size.height * 0.29)/4,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isLast ? Colors.transparent : Color(0xffC2C3CD), width: isLast ? 0 : 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),
            ),
            GestureDetector(onTap: (){showComingSoonSnackBar(context, 'Feature in progress');}, child: Text('REMOVE', style: TextStyle(color: Color(0xff00AB5E), fontSize: 13, fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }

}
