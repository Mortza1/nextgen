import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/snackbar.dart';
import 'package:nextgen_software/pages/settings/add_room.dart';
import 'package:nextgen_software/pages/settings/room.dart';

import '../../scopedModel/app_model.dart';

class ManageRoomsScreen extends StatefulWidget {
  final AppModel appModel;
  const ManageRoomsScreen({super.key, required this.appModel});

  @override
  ManageRoomsScreenState createState() => ManageRoomsScreenState();
}

class ManageRoomsScreenState extends State<ManageRoomsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: main(),
    );
  }

  Widget main() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Color(0xffF3F4FC)),
      child: Column(
        children: [
          SizedBox(height: 40),
          top(),
          SizedBox(height: 40,),
          roomBox()

        ],
      ),
    );
  }

  Widget top() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Manage Rooms',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Text('DONE', style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }

  Widget roomBox() {
    var rooms = widget.appModel.homeData['rooms'];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Rooms',
                  style: TextStyle(color: Color(0xffA1A2AA)),
                ),
              ),
              IconButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddRoomScreen(model: widget.appModel)),
                  );
                }, // Implement this method
                icon: const Icon(Icons.add, color: Color(0xffB4B6C6)),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffC2C3CD), width: 2),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                ...rooms.asMap().entries.map((entry) {
                  int index = entry.key;
                  var room = entry.value;
                  String roomName = room['name'];
                  List<String> deviceList = List<String>.from(room['devices'] ?? []);

                  return buildOptionRow(
                    deviceList: deviceList,
                    title: roomName, // Pass the room name as the title
                    isLast: index == rooms.length - 1, // Mark last item
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionRow(
      {required String title, required List<String> deviceList, bool isLast = false}) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoomScreen(roomDevices: deviceList, title: title, model: widget.appModel,)),
        );
      },
      child: Container(
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
              Icon(Icons.navigate_next_outlined, color: Color(0xffC2C3CD),)
            ],
          ),
        ),
      ),
    );
  }

}
