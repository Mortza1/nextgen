import 'package:flutter/material.dart';
import '../../scopedModel/app_model.dart';

class PlantsScreen extends StatefulWidget {
  final AppModel model;
  const PlantsScreen({super.key, required this.model});

  @override
  PlantsScreenState createState() => PlantsScreenState();
}

class PlantsScreenState extends State<PlantsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: main(),
    );
  }

  Widget main() {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffF3F4FC)),
        child: Column(
          children: [
            SizedBox(height: 40),
            top(),
            SizedBox(height: 10,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Text('Save energy everyday to earn water drops and unlock new plants!', textAlign: TextAlign.center,)),
            plants()
          ],
        ),
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
                  Text(
                      'Plants',
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
  Widget plants() {
    // List of image paths for each row
    final List<String> imagePaths = [
      'assets/images/montesor.png',
      'assets/images/bamboo-in.png', // Example second image
      'assets/images/rose.png', // Example third image
      'assets/images/bonsai.png', // Example fourth image
    ];

    // List of plant names for each row
    final List<String> plantNames = [
      'Monsterra',
      'Bamboo',
      'Rose Plant',
      'Bonsai',
    ];

    // List of tick image paths for each row
    final List<String> tickImagePaths = [
      'assets/images/tick.png',
      'assets/images/tick.png', // Example second tick image
      'assets/images/lock_price.png', // Example third tick image
      'assets/images/lock_price.png', // Example fourth tick image
    ];

    return Expanded(
      child: SizedBox(
        child: ListView.separated(
          itemCount: 4, // Number of rows
          separatorBuilder: (context, index) => const SizedBox(height: 0), // No space between rows
          itemBuilder: (context, rowIndex) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey, width: rowIndex == 0 ? 2 : 1), // Top border
                  bottom: BorderSide(color: Colors.grey, width: rowIndex == 3 ? 2 : 1), // Bottom border
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between items
                children: [
                  Image.asset(
                    imagePaths[rowIndex], // Use rowIndex to access the corresponding image
                    height: 50,
                  ),
                  Text(plantNames[rowIndex]), // Use rowIndex to access the corresponding plant name
                  rowIndex == 1 ? SizedBox(width: 30,) : Image.asset(
                    tickImagePaths[rowIndex], // Use rowIndex to access the corresponding tick image
                    height: rowIndex == 2 || rowIndex == 3 ? 40 : 30,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}