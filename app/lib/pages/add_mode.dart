import 'package:flutter/material.dart';
import 'package:nextgen_software/scopedModel/connected_model_appliance.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../model/appliance.dart';
import '../model/mode.dart';
import '../scopedModel/connected_mode.dart';
import 'curtain.dart';

class AddModeScreen extends StatefulWidget {
  final ApplianceModel model;
  final ModeModel modeModel;
  const AddModeScreen({super.key, required this.model, required this.modeModel});


  @override
  AddModeScreenState createState() => AddModeScreenState();
}

class AddModeScreenState extends State<AddModeScreen> {
  int state = 0;
  bool no = false;
  List selectedWidgets = [];
  List selectedDays = [];
  List<Appliance> selectedDevices = [];
  final now = TimeOfDay.now();
  late int hoursFrom = now.hour % 12;
  late int minutesFrom = now.minute;
  late int hoursTo = now.hour % 12;
  late int minutesTo = now.minute;
  late DayPeriod amPmFrom = now.period;
  late DayPeriod amPmTo = now.period;
  final TextEditingController _textController = TextEditingController();
  bool everyWeek = false;


  @override
  void dispose() {
    // Don't forget to dispose the controllers at the end.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screenHeader(),
          _settingOptions(),
        ],
      ),
    );
  }

  Widget _screenHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.14,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Add Mode",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _settingOptions() {
    List pages = [_name(), _devices(widget.model), _time(), _days(), _deviceModification(widget.model)];
    List next = ['Choose devices', 'Choose time', 'Choose days', 'Device setup', 'Done'];
    double width = (state + 1)/5;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Container(
        height: MediaQuery.of(context).size.height * 0.85 - keyboardHeight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Let's start..", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: state == 0 ? Colors.black : Colors.transparent),),
                SizedBox(height: 10,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xffd9d9d9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Align(
                        alignment: Alignment.centerLeft, // Align to the left
                        child: Container(
                          width: constraints.maxWidth * width, // 10% of parent's width
                          height: constraints.maxHeight, // Full parent's height
                          decoration: BoxDecoration(
                            color: Colors.orange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40,),
                pages[state],
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  state == 0? SizedBox():
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        if (state > 0){
                          state--;
                        }

                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(3, 3), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(Icons.arrow_upward, color: Colors.black,),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      no ? Text('complete this section', style: TextStyle(color: Colors.red, fontSize: 13),) : SizedBox(),
                      Text('next section', style: TextStyle(color: Colors.grey)),
                      Text(next[state], style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w700),),

                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      var startTime = getDateTimeFromTime(hoursFrom, minutesFrom, amPmFrom);
                      var endTime = getDateTimeFromTime(hoursTo, minutesTo, amPmTo);
                      if(state == 4){
                        Mode mode = Mode(title: _textController.text, startTime: startTime, endTime: endTime, appliances: selectedDevices);
                        widget.modeModel.addMode(mode);
                        Navigator.pop(context, true); // Pass a value indicating that a change happened
                      }
                      setState(() {
                        if(state < pages.length - 1){
                          if(state == 0 && _textController.text != ''){
                            no = false;
                            state++;
                          }else if(state == 1 && selectedWidgets.isNotEmpty){
                            no = false;
                            state++;
                          } else if(state == 2 && (startTime != endTime)){
                            no = false;
                            state ++;
                          } else if(state == 3){
                            no = false;
                            state ++;
                          }else {
                            no = true;
                          }

                        }

                      });
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: state == 4 ? Colors.greenAccent : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // Shadow color with transparency
                            spreadRadius: 2, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: Offset(3, 3), // Shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(state == 4 ? Icons.check : Icons.arrow_downward, color: Colors.black,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      )
    );
  }

  Widget _name(){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Give a name to your mode!", style: TextStyle(fontSize: 17),),
        SizedBox(height: 20,),
        TextField(
          controller: _textController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Away from home..',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2)
            )
          ),
        ),
      ],
      ),
    );
  }

  Widget _devices(ApplianceModel model){
    var devices = model.allFetch;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose the devices you want to control", style: TextStyle(fontSize: 17),),
          SizedBox(height: 20,),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 boxes per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 1.7, // Adjust box proportions
              ),
              itemCount: devices.length, // Total number of appliances
              itemBuilder: (BuildContext context, int index) {
                final appliance = devices[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if(selectedWidgets.contains(index)){
                        selectedWidgets.remove(index);
                      } else {
                        selectedWidgets.add(index);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9), // Inactive appliance color
                      borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black)
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                appliance.mainIconString, // Dynamic icon path
                                height: 15,
                              ),
                              Text(
                                appliance.title,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(
                              selectedWidgets.contains(index) ? Icons.radio_button_on : Icons.radio_button_off,
                              color: selectedWidgets.contains(index) ? Colors.orange : Colors.black,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _time(){
    const textStyle = TextStyle(fontSize: 22.0, height: 1.5);
    final wheelStyle = WheelPickerStyle(
      itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
      squeeze: 1.1,
      diameterRatio: .6,
      surroundingOpacity: .25,
      magnification: 1.2,
    );

    Widget itemBuilder(BuildContext context, int index) {
      return Text("$index".padLeft(2, '0'), style: textStyle);
    }

    final timeWheelsFrom = <Widget>[
      for (final wheelController in ['hour', 'minute'])
        Expanded(
          child: WheelPicker(
            builder: itemBuilder,
            looping: wheelController == 'minute',
            itemCount: wheelController == 'minute' ? 60 : 12,
            initialIndex: wheelController == 'minute' ? minutesFrom : hoursFrom,
            style: wheelStyle,
            selectedIndexColor: Colors.orange,
            onIndexChanged: (index){
              setState(() {
                if (wheelController == 'hour'){
                  hoursFrom = index;
                } else {
                  minutesFrom = index;
                }
              });
            },
          ),
        ),
    ];
    timeWheelsFrom.insert(1, const Text(":", style: textStyle));

    final timeWheelsTo = <Widget>[
      for (final wheelController in ['hour', 'minute'])
        Expanded(
          child: WheelPicker(
            builder: itemBuilder,
            looping: wheelController == 'minute',
            itemCount: wheelController == 'minute' ? 60 : 12,
            initialIndex:wheelController == 'minute' ? minutesTo : hoursTo,
            style: wheelStyle,
            selectedIndexColor: Colors.orange,
            onIndexChanged: (index){
              setState(() {
                if (wheelController == 'hour'){
                  hoursTo = index;
                } else {
                  minutesTo = index;
                }
              });
            },
          ),
        ),
    ];
    timeWheelsTo.insert(1, const Text(":", style: textStyle));

    final amPmWheelFrom = Expanded(
      child: WheelPicker(
        itemCount: 2,
        builder: (context, index) {
          return Text(["AM", "PM"][index], style: textStyle);
        },
        initialIndex: (amPmFrom == DayPeriod.am) ? 0 : 1,
        looping: false,
        onIndexChanged: (index){
          setState(() {
            if (amPmFrom == DayPeriod.am){
              amPmFrom = DayPeriod.pm;
            } else {
              amPmFrom = DayPeriod.am;
            }
          });
        },
        style: wheelStyle.copyWith(
          shiftAnimationStyle: const WheelShiftAnimationStyle(
            duration: Duration(seconds: 1),
            curve: Curves.bounceOut,
          ),
        ),
      ),
    );
    final amPmWheelTo = Expanded(
      child: WheelPicker(
        itemCount: 2,
        builder: (context, index) {
          return Text(["AM", "PM"][index], style: textStyle);
        },
        initialIndex: (amPmTo == DayPeriod.am) ? 0 : 1,
        looping: false,
        onIndexChanged: (index){
          setState(() {
            if (amPmTo == DayPeriod.am){
              amPmTo = DayPeriod.pm;
            } else {
              amPmTo = DayPeriod.am;
            }
          });
        },
        style: wheelStyle.copyWith(
          shiftAnimationStyle: const WheelShiftAnimationStyle(
            duration: Duration(seconds: 1),
            curve: Curves.bounceOut,
          ),
        ),
      ),
    );
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Let's set the time", style: TextStyle(fontSize: 17),),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FROM', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.grey),),
              SizedBox(
                width: 200.0,
                height: 200.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _centerBar(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          ...timeWheelsFrom,
                          const SizedBox(width: 6.0),
                          amPmWheelFrom,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TO', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.grey),),
              SizedBox(
                width: 200.0,
                height: 200.0,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _centerBar(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          ...timeWheelsTo,
                          const SizedBox(width: 6.0),
                          amPmWheelTo,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _centerBar(BuildContext context) {
    return Center(
      child: Container(
        height: 38.0,
        decoration: BoxDecoration(
          color: const Color(0xFFC3C9FA).withAlpha(26),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
  Widget _days() {
    List<String> days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select the days!",
            style: TextStyle(fontSize: 17),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.asMap().entries.map((entry) {
              int index = entry.key;
              String day = entry.value;

              return GestureDetector(
                onTap: (){
                  setState(() {
                    if(selectedDays.contains(index)){
                      selectedDays.remove(index);
                    } else {
                      selectedDays.add(index);
                    }
                  });
                },
                child: Container(
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedDays.contains(index) ? Colors.orange : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black)
                  ),
                  child: Text(
                    day, // Displaying day and index
                    textAlign: TextAlign.center,
                    style: TextStyle(color: selectedDays.contains(index) ? Colors.white : Colors.black, fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 15,),
          Row(
            children: [
              Checkbox(
                activeColor: Colors.orange,
                value: everyWeek, // Current state of the checkbox
                onChanged: (value) { // Called when checkbox is toggled
                  setState(() {
                    everyWeek = value!; // Update state
                  });
                },
              ),
              Text(
                'Every week?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deviceModification(ApplianceModel model){
    var devices = model.allFetch;
    selectedDevices = selectedWidgets.map((index) => devices[index]).toList();
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Set device settings!", style: TextStyle(fontSize: 17),),
          Text("(click on the device to set it up)", style: TextStyle(fontSize: 13),),
          SizedBox(height: 20,),
          Expanded(
            child: GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 boxes per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 1.7, // Adjust box proportions
              ),
              itemCount: selectedDevices.length, // Total number of appliances
              itemBuilder: (BuildContext context, int index) {
                final appliance = selectedDevices[index];
                return GestureDetector(
                  onTap: () async {
                    if (appliance.type == 'curtain') {
                      final updatedAppliance = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurtainScreen(device: appliance),
                        ),
                      );

                      if (updatedAppliance != null) {
                        setState(() {
                          // Update the appliance in the list with the returned appliance
                          selectedDevices[index] = updatedAppliance;
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9), // Inactive appliance color
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black)
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                appliance.mainIconString, // Dynamic icon path
                                height: 15,
                              ),
                              Text(
                                appliance.title,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DateTime getDateTimeFromTime(int hour, int minute, DayPeriod period) {
    // Get the current date
    DateTime now = DateTime.now();

    // Convert hour to 24-hour format based on DayPeriod
    int adjustedHour = period == DayPeriod.pm ? (hour % 12) + 12 : hour % 12;

    // Create DateTime with today's date and the given time
    return DateTime(now.year, now.month, now.day, adjustedHour, minute);
  }
}
