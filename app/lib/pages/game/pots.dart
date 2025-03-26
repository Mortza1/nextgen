import 'package:flutter/material.dart';
import '../../scopedModel/app_model.dart';

class PotsScreen extends StatefulWidget {
  final AppModel model;
  const PotsScreen({super.key, required this.model});

  @override
  PotsScreenState createState() => PotsScreenState();
}

class PotsScreenState extends State<PotsScreen> {
  late int? selectedPotIndex; // Track the selected pot index

  @override
  void initState() {
    super.initState();
    print(widget.model.selectedPlant);
    String pot = widget.model.selectedPlant.split('-')[1];
    if (pot == 'clay'){
      selectedPotIndex = 0;
    } else if (pot == 'painted') {
      selectedPotIndex = 1;
    } else {
      selectedPotIndex = 5;
    }
  }

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
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                'Save energy everyday to earn water drops and unlock new pots!',
                textAlign: TextAlign.center,
              )),
          pots(),
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Pots',
                      style: TextStyle(
                          color: Color(0xffAFB0BA),
                          fontSize: 19,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('DONE',
                    style: TextStyle(
                        color: Color(0xff00AB5E), fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget pots() {
    final List<String> imagePaths = [
      'assets/images/clay-pot.png',
      'assets/images/painted_pot.png',
      'assets/images/pot_pink.png',
      'assets/images/pot_black.png',
      'assets/images/modern.png',
      'assets/images/galactic_pot.png',
    ];

    final List<String> plantNames = [
      'Clay Pot',
      'Painted Clay Pot',
      'Ceramic Pot Pink',
      'Ceramic Pot Black',
      'Modern Pot',
      'Intergalactic Pot',
    ];

    final List<String> tickImagePaths = [
      'assets/images/tick.png',
      'assets/images/tick.png',
      'assets/images/lock_price.png',
      'assets/images/lock_price.png',
      'assets/images/lock_price.png',
      'assets/images/lock_price.png',
    ];

    return Expanded(
      child: SizedBox(
        child: ListView.separated(
          itemCount: 6,
          separatorBuilder: (context, index) => const SizedBox(height: 0),
          itemBuilder: (context, rowIndex) {
            return GestureDetector(
              onTap: () {
                if (rowIndex == 0 || rowIndex == 1 || rowIndex == 5) {
                  if (rowIndex == 0){
                    widget.model.updatePot('clay');
                  } else if (rowIndex == 1){
                    widget.model.updatePot('painted');
                  } else {
                    widget.model.updatePot('galactic');
                  }
                  setState(() {
                    selectedPotIndex = rowIndex;
                  });
                  // Update the model with the selected pot if needed
                  // Example:
                  // widget.model.currentPot = plantNames[rowIndex];
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: rowIndex == 0 ? 2 : 1),
                    bottom: BorderSide(color: Colors.grey, width: rowIndex == 5 ? 2 : 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      imagePaths[rowIndex],
                      height: 75,
                    ),
                    Text(plantNames[rowIndex]),
                    if (rowIndex == 0 || rowIndex == 1 || rowIndex == 5)
                      (selectedPotIndex == rowIndex
                          ? Image.asset('assets/images/tick.png', height: 30)
                          : SizedBox(width: 30))
                    else
                      Image.asset(
                        tickImagePaths[rowIndex],
                        height: 40,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}