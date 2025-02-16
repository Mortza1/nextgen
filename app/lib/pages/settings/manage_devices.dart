import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/settings/room.dart';

class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  ManageDevicesScreenState createState() => ManageDevicesScreenState();
}

class ManageDevicesScreenState extends State<ManageDevicesScreen> {

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
          options(),
          SizedBox(height: 40,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffC2C3CD), width: 2),
                    borderRadius: BorderRadius.circular(22)
                  ),
                  child: Center(
                    child: Text('Remove Device', style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold, fontSize: 13),),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.38,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffC2C3CD), width: 2),
                      borderRadius: BorderRadius.circular(22)
                  ),
                  child: Center(
                    child: Text('Add Device', style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                )
              ],
            ),
          )

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
                    'Manage Devices',
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
  Widget options() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                buildOptionRow(
                    title: 'Security Camera',
                    ),
                buildOptionRow(
                    title: 'Spotlights',
                    ),
                buildOptionRow(
                    title: 'Armchair socket',
                    ),
                buildOptionRow(
                  title: 'TV',
                ),
                buildOptionRow(
                  title: 'Blinds',
                ),
                buildOptionRow(
                  title: 'Thermostat',
                ),
                buildOptionRow(
                    title: 'Speakers',
                    isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each option row with a toggle
  Widget buildOptionRow(
      {required String title, bool isLast = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: (MediaQuery.of(context).size.height * 0.31) / 4,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: isLast ? 0 : 2))),
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
            Column(
              children: [
                Text('haha', style: TextStyle(fontSize: 12,color: Color(0xff929292)),),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffC2C3CD),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Center(
                    child: Text('Bedroom', style: TextStyle(color: Colors.white, fontSize: 12),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
