import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nextgen_software/pages/user_profile_page.dart';

import '../scopedModel/connectedModel.dart';


class HomePageBody extends StatefulWidget {
  HomePageBody(this.model);

  final ApplianceModel model;

  _HomePageBodyState createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  Widget _topMyHomeSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.09,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Home',
            style: TextStyle(
              fontSize: 20.0, // Increase font size
              fontWeight: FontWeight.w900, // Make text bold
              fontFamily: 'Roboto', // Optional: change the font family (default is 'Roboto')
            ),
          ),
          Image.asset('assets/images/add.png',
            width: 25,  // Set the width
            height: 25, // Set the height
            )
        ],
      ),
    );
  }
  Widget _topWidgetSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07, // Parent container height
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemCount: 5, // Set the number of items in the list
          itemBuilder: (context, index) {
            // Check if it's the first two boxes
            Color boxColor = (index == 0 || index == 1) ? Color(0xff32E1A1) : Color(0xffefefef);
            String text = (index == 0 || index == 1) ? 'active' : 'not active';

            return Container(
              width: 120, // Width of each box
              height: MediaQuery.of(context).size.height * 0.1, // Set the box height to match parent container
              margin: EdgeInsets.symmetric(horizontal: 4.0), // Space between boxes
              decoration: BoxDecoration(
                color: boxColor, // Use the appropriate color
                borderRadius: BorderRadius.circular(5), // Rounded corners for boxes
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/tv.png', height: 20,),
                  SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("TV",
                        style: TextStyle(
                          fontSize: 10
                        ),),
                      Text(text,
                        style: TextStyle(
                            fontSize: 10
                        ),)
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _modeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
        height: MediaQuery.of(context).size.height * 0.275,
        child: Column(
          children: [
          Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Modes',
              style: TextStyle(
                fontSize: 25.0, // Increase font size
                fontWeight: FontWeight.w600, // Make text bold
                fontFamily: 'Roboto', // Optional: change the font family (default is 'Roboto')
              ),
            ),
            Image.asset('assets/images/add.png',
              width: 25,  // Set the width
              height: 25, // Set the height
            )
          ],
        ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.085,
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Color(0xffd9d9d9),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Morning scene", style: TextStyle(fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w800),),
                          Image.asset('assets/images/switch.png', height:35,)
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.085,
                      width: MediaQuery.of(context).size.width * 0.95,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Morning scene", style: TextStyle(fontSize: 16, fontFamily: 'Roboto', fontWeight: FontWeight.w800),),
                          Image.asset('assets/images/switch.png', height:35,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          _topMyHomeSection(),
          _topWidgetSection(),
          _modeSection()

    ])));
  }
}