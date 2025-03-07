import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/barchart.dart';
import '../components/piechart.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _selectedIndex = 0; // Keeps track of the selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView( // Added this to allow scrolling
          child: Column(
            children: [
              _overviewHeader(),
              SizedBox(height: 10),
              chart(),
              SizedBox(height: 10),
              energySaving(),
              SizedBox(height: 20),
              customTabs(),
              SizedBox(height: 20),
              consumption(),
              SizedBox(height: 20,),
              saved()
            ],
          ),
        ),
      ),
    );
  }


  Widget _overviewHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Energy",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget chart() {
    return Column(
      children: [
        period(),
        SizedBox(height: 40),
        pi(),
        board(),
      ],
    );
  }

  Widget period() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD1D2DA), width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text('Day')),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD1D2DA), width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text('Week')),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD1D2DA), width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text('Month')),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffD1D2DA), width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text('Year')),
          ),
        ],
      ),
    );
  }

  Widget pi() {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width * 0.6, 100),
          painter: SemiCirclePiePainter(),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.17,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Total usage', style: TextStyle(color: Color(0xff575757), fontSize: 11)),
                    SizedBox(width: 3),
                    Text('today', style: TextStyle(color: Color(0xff575757), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('17.43 kWh', style: TextStyle(color: Color(0xff575757), fontWeight: FontWeight.bold, fontSize: 22)),
                Text('Saved 11.34', style: TextStyle(color: Color(0xff34C759), fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ))),
      ],
    );
  }

  Widget board() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffD1D2DA), width: 2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('This week', style: TextStyle(color: Color(0xff575757), fontSize: 13)),
                Text('90.7 kWh', style: TextStyle(color: Color(0xff575757), fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(width: 15),
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
              width: 2,
              decoration: BoxDecoration(
                color: Color(0xffD1D2DA),
              ),
            ),
            SizedBox(width: 15),
            Column(
              children: [
                Text('This month', style: TextStyle(color: Color(0xff575757), fontSize: 13)),
                Text('320.7 kWh', style: TextStyle(color: Color(0xff575757), fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Custom Tabs Section
  Widget customTabs() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _selectedIndex == 0 ? Colors.black : Colors.transparent, width: 3)),
                      ),
                      child: Text('Devices', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 1),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: _selectedIndex == 1 ? Colors.black : Colors.transparent, width: 3)),
                      ),
                      child: Text('Rooms', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('filter', style: TextStyle(color: Color(0xffA1A2AA), fontSize: 15),),
                  SizedBox(width: 5,),
                  Icon(Icons.filter_alt, color: Color(0xffA1A2AA), size: 15, )
                ],
              )
            ],
          ),
          SizedBox(height: 20),
          _selectedIndex == 0
              ? Row(
            children: [
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                width: MediaQuery.of(context).size.width * 0.39,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0x17000000)),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.black, size: 15,),
                    Text('Light', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.pie_chart_outline_outlined, color: Colors.green, size: 18,),
                        Column(
                          children: [
                            Text('Used', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            Text('4 kWh', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                          ],
                        ),
                        Container(
                          width: 2,
                          height: 30,
                          decoration: BoxDecoration(
                              color: Color(0xffDFDFE1)
                          ),
                        ),
                        Column(
                          children: [
                            Text('Saved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                            Text('2 kWh', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ],
                    )

                  ],
                ),
              )
            ],
          )  // Devices content
              : roomCards(),    // Rooms content
        ],
      ),
    );
  }
  Widget energySaving(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xffD5FFB8), Color(0xff8FD993)]),
        borderRadius: BorderRadius.circular(12)
      ),child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/leaf_a.png', height: 30,),
        Text('Turn on energy saving', style: TextStyle(fontWeight: FontWeight.bold),),
        Icon(Icons.toggle_off, size: 35,)
      ],
    ),
    );
  }
  Widget roomCards(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        room('Bedroom'),
        room('Living Room')
      ],
    );
  }
  Widget consumption(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Energy Consumption', style: TextStyle(color: Color(0xffA1A2AA), fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          period(),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Energy consumed', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('17.43', style: TextStyle(color: Color(0xff575757), fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
                Text('kWh', style: TextStyle(color: Color(0xff575757), fontWeight: FontWeight.bold))
              ],
            ),
          ),
          BarChartSample6()
        ],
      ),
    );
  }
  Widget room(String name){
    return Container(
      width: MediaQuery.of(context).size.width * 0.39,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      height: 80,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0x17000000)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.pie_chart_outline_outlined, color: Colors.green, size: 18,),
              Column(
                children: [
                  Text('Used', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  Text('4 kWh', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                ],
              ),
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                    color: Color(0xffDFDFE1)
                ),
              ),
              Column(
                children: [
                  Text('Saved', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                  Text('2 kWh', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget saved(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Energy Saving Results', style: TextStyle(color: Color(0xffA1A2AA), fontSize: 18, fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),
          period(),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Energy saved', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('11.34', style: TextStyle(color: Color(0xff575757), fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(width: 5,),
                Text('kWh', style: TextStyle(color: Color(0xff575757), fontWeight: FontWeight.bold))
              ],
            ),
          ),
          BarChartSample7()
        ],
      ),
    );
  }
}
