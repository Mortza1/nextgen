import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/barchart.dart';
import '../../scopedModel/app_model.dart';
import '../components/piechart.dart';

class OverviewScreen extends StatefulWidget {
  final AppModel model;
  const OverviewScreen({super.key, required this.model});

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int _selectedIndex = 0; // Keeps track of the selected tab
  String _selectedPeriod1 = 'Day';
  String _selectedPeriod2 = 'Day';
  String _selectedPeriod3 = 'Day';

  // Example data for each tab
  final Map<String, String> usageData = {
    'Day': '17.43',
    'Week': '102.5',
    'Month': '412.8',
    'Year': '4,520',
  };
  final Map<String, String> savedData = {
    'Day': '3.0',
    'Week': '34.22',
    'Month': '109.92',
    'Year': '498.8',
  };

  List<double> pi_data = [4.5, 3.2, 5.1, 1.2];
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
        period(_selectedPeriod1, (value) {
          setState(() {
            _selectedPeriod1 = value;
          });
        }),
        SizedBox(height: 40),
        pi(pi_data),
        legend(),
        board(),
      ],
    );
  }

  Widget legend() {
    var labels = ['Lights', 'Cooling', 'Appliances', 'Security'];
    var colors = [Color(0xff7EFCE3), Color(0xffFDA75C), Color(0xff7E84FC), Color(0xff93DB95)];

    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      alignment: Alignment.topCenter, // Align the container to the top center
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legendItem(colors[0], labels[0]),
              legendItem(colors[1], labels[1]),
            ],
          ),
          SizedBox(height: 10), // Add some vertical spacing
          // Second row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              legendItem(colors[2], labels[2]),
              legendItem(colors[3], labels[3]),
            ],
          ),
        ],
      ),
    );
  }

// Reusable legend item widget
  Widget legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }



  Widget period(String selector, Function(String) onSelected) {
    final periods = ['Day', 'Week', 'Month', 'Year'];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: periods.map((period) {
          final bool isSelected = selector == period;

          return GestureDetector(
            onTap: () {
              onSelected(period); // Use the callback to update state
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xff4B504C) : Colors.white,
                border: Border.all(color: Color(0xffD1D2DA), width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }



  Widget pi(List<double> dataValues) {
    return Stack(
      children: [
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width * 0.6, 100),
          painter: SemiCirclePiePainter(dataValues), // Pass dynamic values
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
                    Text(_selectedPeriod1, style: TextStyle(color: Color(0xff575757), fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('${usageData[_selectedPeriod1]} kWh', style: TextStyle(color: Color(0xff575757), fontWeight: FontWeight.bold, fontSize: 22)),
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
                Text('${usageData['Week'].toString()} kWh', style: TextStyle(color: Color(0xff575757), fontSize: 17, fontWeight: FontWeight.bold)),
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
                Text('${usageData['Month'].toString()} kWh', style: TextStyle(color: Color(0xff575757), fontSize: 17, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Custom Tabs Section
  Widget customTabs() {
    var devices = widget.model.applianceModel.allFetch;
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
              ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling if within another scrollable widget
              shrinkWrap: true, // Important for proper height handling
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 items per row
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.4, // Adjust this to control the height of the grid items
              ),
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final appliance = devices[index];

                return Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0x17000000)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        appliance.title ?? 'Unknown',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.pie_chart_outline_outlined, color: Colors.green, size: 18),
                          Column(
                            children: [
                              Text(
                                'Used',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '4 kWh',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            width: 2,
                            height: 30,
                            decoration: BoxDecoration(color: Color(0xffDFDFE1)),
                          ),
                          Column(
                            children: [
                              Text(
                                'Saved',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '2 kWh',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
  Widget roomCards() {
    var rooms = widget.model.homeData['rooms'] as List<dynamic>;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // Avoids scroll conflicts
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 items per row
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.8, // Adjust as needed
      ),
      itemCount: rooms.length,
      itemBuilder: (BuildContext context, int index) {
        var room = rooms[index];
        String roomName = room['name'];
        print(roomName);
        return roomCard(roomName);
      },
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
          period(_selectedPeriod2, (value) {
            setState(() {
              _selectedPeriod2 = value;
            });
          }),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Energy consumed', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(usageData[_selectedPeriod2].toString(), style: TextStyle(color: Color(0xff575757), fontSize: 22, fontWeight: FontWeight.bold)),
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
  Widget roomCard(String name){
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
          period(_selectedPeriod3, (value) {
            setState(() {
              _selectedPeriod3 = value;
            });
          }),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('Energy saved', style: TextStyle(color: Color(0xffA1A2AA)),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text(savedData[_selectedPeriod3].toString(), style: TextStyle(color: Color(0xff575757), fontSize: 22, fontWeight: FontWeight.bold)),
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
