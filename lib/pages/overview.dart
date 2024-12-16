import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/home_page_body.dart';

class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _overviewHeader(),
          _summaryCard(),
          _overviewCards()
        ],
      ),
    );
  }

  Widget _overviewHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("Home", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),)
        ],
      ),
    );
  }
  Widget _summaryCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.27,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
          color: Color(0xffd9d9d9),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color with opacity
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 7, // How blurry the shadow is
              offset: Offset(0, 3), // Offset of the shadow (x, y)
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Row(
                children: [
                  Image.asset('assets/images/man.png', height: 50,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hey'),
                      Text('Murtaza!')
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text("Did you know you can automate your smart blinds to open and close based on sunrise and sunset times? Setting them to open automatically at sunrise can bring in natural light and warmth, reducing your reliance on the thermostat. This simple change can help you save on heating and create a cozy atmosphere when you wake up!",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
            )
          ],
        ),
      ),
    );
  }
  Widget _overviewCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
              _totalDevicesCard(),
              SizedBox(width: 10,),
              _energyPointsCard()
                ],
              ),
            ),
            _goalsCard()
          ],
        ),
      )
    );
  }

  Widget _totalDevicesCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        color: Color(0xff32E1A1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('14', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),),
            Text('devices running')
          ],
        ),
      ),
    );
  }
  Widget _energyPointsCard() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: Color(0xffFEDC97),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('38', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25)),
            Text('energy points collected', textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
  Widget _goalsCard() {
    return Material(
      color: Colors.transparent, // Maintain the container's background color
      child: InkWell(
        onTap: () {
          // Do nothing for now
        },
        borderRadius: BorderRadius.circular(8), // Match container radius
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.91,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xffFF6978),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Goals',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset(
                  'assets/images/target.png',
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

