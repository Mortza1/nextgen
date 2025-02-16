import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/login.dart';
import '../scopedModel/app_model.dart';
import '../scopedModel/connected_mode.dart';
import '../scopedModel/connected_model_appliance.dart';
import 'add_mode.dart';
import 'morning.dart';

class ModeScreen extends StatefulWidget {
  final AppModel model;
  const ModeScreen({super.key, required this.model});

  @override
  ModeScreenState createState() => ModeScreenState();
}

class ModeScreenState extends State<ModeScreen> {
  int _selectedTab = 0; // Keeps track of selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _modeHeader(),
          _customTabs(), // Custom tab buttons
          Expanded(child: _tabViews()), // Tab content
        ],
      ),
    );
  }

  /// **Header Section**
  Widget _modeHeader() {
    ApplianceModel model = widget.model.applianceModel;
    ModeModel modeModel = widget.model.modeModel;

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Scenes',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, fontFamily: 'Roboto'),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddModeScreen(
                  model: model,
                  modeModel: modeModel,
                )),
              );

              if (result == true) {
                setState(() {});
              }
            },
            child: Image.asset(
              'assets/images/add.png',
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  /// **Custom Tab Bar**
  Widget _customTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _tabItem(title: "Your Modes", index: 0),
          const SizedBox(width: 20),
          _tabItem(title: "Featured", index: 1),
        ],
      ),
    );
  }

  /// **Single Tab Button with Custom Styling**
  Widget _tabItem({required String title, required int index}) {
    bool isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.black : Colors.grey, // Change color based on selection
            ),
          ),
          const SizedBox(height: 5),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent, // Show line if selected
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }

  /// **Tab Views**
  Widget _tabViews() {
    return _selectedTab == 0 ? _yourModesWidget() : _featuredWidget();
  }

  /// **Placeholder Widgets for Tabs**
  Widget _yourModesWidget() {

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: SingleChildScrollView(
          child: Column(
            children: widget.model.modeModel.allFetch.map((mode) {
              // Use dynamic modes from the model
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: GestureDetector(
                  onTap: () {
                    // Dynamic navigation based on mode title
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MorningScreen(mode: mode),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.95,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage(mode.backImg), fit: BoxFit.cover,),
                      color: const Color(0xffd9d9d9), // Background based on isEnabled
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          mode.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        mode.isActive()
                            ? const Icon(Icons.toggle_on,
                            color: Colors.green, size: 50)
                            : const Icon(Icons.toggle_off,
                            color: Colors.black, size: 50),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _featuredWidget() {
    return Center(child: Text("Featured Content", style: TextStyle(fontSize: 18)));
  }
}
