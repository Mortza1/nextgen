import 'package:flutter/material.dart';

class MorningScreen extends StatefulWidget {
  final String title;
  const MorningScreen({super.key, required this.title});

  @override
  MorningScreenState createState() => MorningScreenState();
}

class MorningScreenState extends State<MorningScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _screenHeader(),
            _modeBasicCard(),
            _modeDevices(),
          ],
        ),
      ),
    );
  }

  Widget _screenHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 48,
            child: IconButton(
              icon: Icon(Icons.settings, size: 30, color: Colors.black),
              onPressed: () {},
              tooltip: "Settings",
            ),),
        ],
      ),
    );
  }

  Widget _modeBasicCard(){
    return Container(
      height: MediaQuery.of(context).size.height * 0.18,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xffEFEFEF),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff32E1A1),
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Center(
                    child: Icon(Icons.sunny, color: Colors.black,),
                  ),
                ),
                SizedBox(height: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From 6am'),
                    Text('to 9am'),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.toggle_off, size: 50, color: Colors.black),
                  onPressed: () {},
                  tooltip: "On",
                ),
                Container(
                  height: 40,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: Center(
                    child: Text("Change timings", style: TextStyle(color: Colors.white, fontSize: 11), textAlign: TextAlign.center,),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _modeDevices() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          SizedBox(height: 20,),
          Align(alignment: Alignment.topLeft ,child: Text('Device routine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),)),
          Expanded(
            child: GridView.builder(
              physics: AlwaysScrollableScrollPhysics(), // Allow vertical scrolling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 boxes per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 1.7, // Adjust box proportions
              ),
              itemCount: 3, // Total number of boxes
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xffd9d9d9), // Background color for the boxes
                      borderRadius: BorderRadius.circular(10.0), // Rounded corners
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/tv.png', height: 15,),
                              Text('Smart Tv', style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(Icons.settings, color: Colors.black, size: 15,),
                          ),
                        )
                      ],
                    )
                  ),
                );
              },
            ),
          ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
              color: Colors.black
          ),
          child: Center(
            child: Text('Add device', style: TextStyle(color: Colors.white, ),),
          ),
        ),
      )
        ],
      ),
    );
  }


}
