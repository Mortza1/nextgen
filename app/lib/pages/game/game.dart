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
  late final AnimationController _controllerSecond;
  bool _isSecondAnimationPlayed = false;

  @override
  void initState() {
    super.initState();
    _controllerFirst = AnimationController(vsync: this);
    _controllerSecond = AnimationController(vsync: this, duration: Duration(seconds: 1)); // Second animation runs only once
  }

  @override
  void dispose() {
    _controllerFirst.dispose();
    _controllerSecond.dispose();
    super.dispose();
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
                          children: [
                            Image.asset('assets/images/fire.png', height: 30),
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
                          children: [
                            Image.asset('assets/images/water.png', height: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      // Reset and play the first animation
                      _controllerFirst.reset(); // Reset to the beginning
                      _controllerFirst.forward(); // Start the first animation

                      // Play the second animation only once after the first finishes
                      if (!_isSecondAnimationPlayed) {
                        Future.delayed(_controllerFirst.duration ?? Duration.zero, () {
                          _controllerSecond.forward();
                          setState(() {
                            _isSecondAnimationPlayed = true;
                          });
                        });
                      }
                    },
                    child: Lottie.network(
                      'https://lottie.host/c3ef8a40-5a55-407e-ac16-feda68e10df7/HjPokfeeWS.json',
                      controller: _controllerFirst,
                      onLoaded: (composition) {
                        // Configure the AnimationController for the first animation
                        _controllerFirst.duration = composition.duration;
                      },
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                // Second Lottie animation that will run only once
                Lottie.network(
                  'https://lottie.host/470c7925-7eae-430f-be9f-0e10bfd776a7/Am2UMK3c4X.json',
                  controller: _controllerSecond,
                  onLoaded: (composition) {
                    // Configure the AnimationController for the second animation
                    _controllerSecond.duration = composition.duration;
                  },
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
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
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Image.asset('assets/images/pot.png', height: 30,),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
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
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(
                          child: Image.asset('assets/images/bamboo.png', height: 30,),
                        ),
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Color(0x8C3B3A4B)
                    ),
                    child: Center(
                      child: Image.asset('assets/images/heart.png', height: 25,),
                    ),
                  ),
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
