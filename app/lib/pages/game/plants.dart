import 'package:flutter/material.dart';
import '../../scopedModel/app_model.dart';

class PlantsScreen extends StatefulWidget {
  final AppModel model;
  const PlantsScreen({super.key, required this.model});

  @override
  PlantsScreenState createState() => PlantsScreenState();
}

class PlantsScreenState extends State<PlantsScreen> {
  late int? selectedPot;

  @override
  void initState() {
    super.initState();
    String plant = widget.model.selectedPlant.split('-')[0];
    if (plant == 'mon'){
      selectedPot = 0;
    } else {
      selectedPot = 1;
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
          SizedBox(height: 10,),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Text(
                'Save energy everyday to earn water drops and unlock new plants!',
                textAlign: TextAlign.center,
              )
          ),
          plants()
        ],
      ),
    );
  }

  Widget top() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xffD2D2DA), width: 2))
      ),
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
                  Text(
                      'Plants',
                      style: TextStyle(
                          color: Color(0xffAFB0BA),
                          fontSize: 19,
                          fontWeight: FontWeight.bold
                      )
                  ),
                ],
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                    'DONE',
                    style: TextStyle(
                        color: Color(0xff00AB5E), fontWeight: FontWeight.bold
                    )
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget plants() {
    final List<String> imagePaths = [
      'assets/images/montesor.png',
      'assets/images/bamboo-in.png',
      'assets/images/rose.png',
      'assets/images/bonsai.png',
    ];

    final List<String> plantNames = [
      'Monsterra',
      'Bamboo',
      'Rose Plant',
      'Bonsai',
    ];

    final List<String> tickImagePaths = [
      'assets/images/tick.png',
      'assets/images/tick.png',
      'assets/images/lock_price.png',
      'assets/images/lock_price.png',
    ];

    return Expanded(
      child: SizedBox(
        child: ListView.separated(
          itemCount: 4,
          separatorBuilder: (context, index) => const SizedBox(height: 0),
          itemBuilder: (context, rowIndex) {
            return GestureDetector(
              onTap: () {
                if (rowIndex == 0 || rowIndex == 1) {
                  if (rowIndex == 0){
                    widget.model.updatePlant('mon');
                  } else {
                    widget.model.updatePlant('bam');
                  }
                  setState(() {
                    selectedPot = rowIndex;
                  });

                  // Return the selected plant back to the GameScreen
                  // Navigator.pop(context, plantNames[rowIndex]);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey, width: rowIndex == 0 ? 2 : 1),
                    bottom: BorderSide(color: Colors.grey, width: rowIndex == 3 ? 2 : 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      imagePaths[rowIndex],
                      height: 50,
                    ),
                    Text(plantNames[rowIndex]),
                    if (rowIndex == 0 || rowIndex == 1)
                      (selectedPot == rowIndex
                          ? Image.asset('assets/images/tick.png', height: 30)
                          : SizedBox(width: 30))
                    else
                      Image.asset(
                        tickImagePaths[rowIndex],
                        height: rowIndex == 2 || rowIndex == 3 ? 40 : 30,
                      )
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
