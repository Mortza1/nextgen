import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nextgen_software/pages/game/plants.dart';
import 'package:nextgen_software/pages/game/pots.dart';
import '../../scopedModel/app_model.dart';

class GameScreen extends StatefulWidget {
  final AppModel model;
  const GameScreen({super.key, required this.model});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late final AnimationController _controllerFirst;
  int _currentImageIndex = 0; // Track the current plant stage

  List<String> images = [
    'assets/images/sapling.png',
    'assets/images/sap2.png',
    'assets/images/sap3.PNG',
    'assets/images/sap4.png'
  ];

  @override
  void initState() {
    super.initState();
    _controllerFirst = AnimationController(vsync: this);

    // Listen for animation completion
    _controllerFirst.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Change the image after animation ends
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % images.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _controllerFirst.dispose();
    super.dispose();
  }

  void _waterPlant() {
    _controllerFirst.reset();
    _controllerFirst.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/game_back.png'),
                fit: BoxFit.cover,
                opacity: 0.53,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Color(0x8C3B3A4B),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/fire.png', height: 25),
                            SizedBox(width: 10,),
                            Text('18', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Color(0x8C3B3A4B),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/water.png', height: 25),
                            SizedBox(width: 10,),
                            Text('4', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: _currentImageIndex == 3 ? null : _waterPlant,
                    child: Lottie.network(
                      'https://lottie.host/c3ef8a40-5a55-407e-ac16-feda68e10df7/HjPokfeeWS.json',
                      controller: _controllerFirst,
                      onLoaded: (composition) {
                        _controllerFirst.duration = composition.duration;
                      },
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Show the current plant image based on state
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.30,
                  child: Center(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 100,),
                            Align(alignment:Alignment.bottomCenter, child: Image.asset('assets/images/pot.png')),
                          ],
                        ),
                        Align(alignment: Alignment.topCenter, child: Image.asset(images[_currentImageIndex], height: 180,)),
                      ],
                    ), // Updated dynamically
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PotsScreen(model: widget.model)),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xffF3F4FC),
                          border: Border.all(color: Color(0xffCACBD5), width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Image.asset('assets/images/pot.png', height: 30),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlantsScreen(model: widget.model)),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xffF3F4FC),
                          border: Border.all(color: Color(0xffCACBD5), width: 2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Image.asset('assets/images/bamboo.png', height: 30),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Color(0x8C3B3A4B),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/heart.png', height: 25),
                          SizedBox(width: 10,),
                          Text('100%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
