import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/home_page_body.dart';

class CustomTabScreen extends StatefulWidget {
  @override
  _CustomTabScreenState createState() => _CustomTabScreenState();
}

class _CustomTabScreenState extends State<CustomTabScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePageBody(),
    ScreenTwo(),
    ScreenThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex], // Display the current screen
          Positioned(
            bottom: 20, // Adjust distance from the bottom of the screen
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black, // Black background color
                borderRadius: BorderRadius.circular(15), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem('assets/images/dashboard.png', 0, "dashboard"),
                  _buildNavItem('assets/images/graph.png', 1, "overview"),
                  _buildNavItem('assets/images/user.png', 2, "profile"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String image, int index, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: _currentIndex == index ? EdgeInsets.symmetric(horizontal: 15, vertical: 5) : EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: _currentIndex == index ?   Colors.grey : Colors.transparent,
          borderRadius: _currentIndex == index? BorderRadius.circular(5): BorderRadius.circular(0)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 15,),
            if (_currentIndex == index)
            SizedBox(width: 5,),
            if (_currentIndex == index)
            Text(
              label,
              style: TextStyle(
                color: _currentIndex == index ? Colors.white : Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w900
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Dummy screen for "Search"
class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Search Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Dummy screen for "Settings"
class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
