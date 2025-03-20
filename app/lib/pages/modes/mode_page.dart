import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/auth_ui/login.dart';
import '../../scopedModel/app_model.dart';
import '../../scopedModel/connected_mode.dart';
import '../../scopedModel/connected_model_appliance.dart';
import '../components/snackbar.dart';
import 'add_mode.dart';
import '../morning.dart';

class ModeScreen extends StatefulWidget {
  final AppModel model;
  const ModeScreen({super.key, required this.model});

  @override
  ModeScreenState createState() => ModeScreenState();
}

class ModeScreenState extends State<ModeScreen> {
  int _selectedTab = 0; // Keeps track of selected tab
  bool isEnergySavingActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _modeHeader(),
          _customTabs(), // Custom tab buttons
          SizedBox(height: MediaQuery.of(context).size.height * 0.745,
              child: _tabViews()), // Tab content
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
                  appModel: widget.model
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
  Widget _yourModesWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Automated',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            Column(
              children: widget.model.modeModel.allFetch.map((mode) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: () {
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
                        image: (mode.backImg.isNotEmpty)
                            ? DecorationImage(
                          image: NetworkImage(mode.backImg),
                          fit: BoxFit.cover,
                        )
                            : null,
                        color: Color(int.parse('0x${mode.bgColor}')),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2),
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
                          Column(
                            children: [
                              mode.isActive()
                                  ? const Icon(Icons.toggle_on,
                                  color: Colors.green, size: 50)
                                  : const Icon(Icons.toggle_off,
                                  color: Colors.black, size: 50),
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Color(0x87D9D9D9),
                                  border: Border.all(color: Colors.black, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text('Edit'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Manual',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.95,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffD5FFB8), Color(0xff8FD993)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Energy Saving',
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEnergySavingActive = !isEnergySavingActive;
                              });
                            },
                            child: Icon(
                              isEnergySavingActive
                                  ? Icons.toggle_on
                                  : Icons.toggle_off,
                              color: isEnergySavingActive ? Colors.green : Colors.black,
                              size: 50,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              showComingSoonSnackBar(context, 'feature coming soon');
                            },
                            child: Container(
                              height: 40,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0x87D9D9D9),
                                border: Border.all(color: Colors.black, width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text('Edit'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featuredWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              child: Text('Explore recommended modes and add to your modes', style: TextStyle(fontSize: 17), textAlign: TextAlign.center,),
            ),
            modeBox('assets/images/movie.png', 'Movie Night'),
            modeBox('assets/images/focus_study.png', 'Focus Study'),
            modeBox('assets/images/dinner_mode.png', 'Dinner Time'),
        ],
      ),
    );
  }

  Widget modeBox(String image, String title){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          // Dynamic navigation based on mode title
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => MorningScreen(mode: mode),
          //   ),
          // );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover,),
            color: const Color(0xffd9d9d9), // Background based on isEnabled
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 2)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w300,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showComingSoonSnackBar(context, 'Coming Soon!');
                },
                child: Container(
                  height: 40,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Color(0x87D9D9D9),
                      border: Border.all(color: Colors.black, width: 3 ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text('Add'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
