import 'package:flutter/material.dart';

class PrivacySettingScreen extends StatefulWidget {
  const PrivacySettingScreen({super.key});

  @override
  PrivacySettingScreenState createState() => PrivacySettingScreenState();
}

class PrivacySettingScreenState extends State<PrivacySettingScreen> {
  // Define state variables to hold the toggle states for each option
  bool isEnergyAIEnabled = false;
  bool areSusAiEnabled = false;
  bool isModeEnabled = false;
  bool isRoutineEnabled = false;

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
          SizedBox(height: 20),
          options(),
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
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xffC2C3CD)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Privacy Settings',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget options() {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xffC2C3CD), width: 2),
                borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                buildOptionRow(
                    title: 'Tracking and personalization for advertising',
                    isEnabled: isEnergyAIEnabled,
                    isLast: true,
                    onTap: () {
                      setState(() {
                        isEnergyAIEnabled = !isEnergyAIEnabled;
                      });
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build each option row with a toggle
  Widget buildOptionRow(
      {required String title, required bool isEnabled, required VoidCallback onTap, bool isLast = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: (MediaQuery.of(context).size.height * 0.29) / 4,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffC2C3CD), width: isLast ? 0 : 2))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Text(
            //   title,
            //   style: TextStyle(color: Color(0xffA1A2AA), fontWeight: FontWeight.bold, fontSize: 17),
            // ),
            Expanded( // Wrap text inside Expanded to prevent overflow
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xffA1A2AA),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                softWrap: true, // Enable text wrapping
                overflow: TextOverflow.ellipsis, // Show '...' if text is too long
                maxLines: 2, // Limits to 2 lines before truncation
              ),
            ),
            IconButton(
              onPressed: onTap,
              icon: Icon(
                isEnabled ? Icons.toggle_on : Icons.toggle_off,
                color: isEnabled ? Colors.green : Colors.black,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
