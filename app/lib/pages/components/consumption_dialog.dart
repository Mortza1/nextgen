import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumptionWidget extends StatefulWidget {
  final Map<String, dynamic> homeData;

  ConsumptionWidget({required this.homeData});

  @override
  _ConsumptionWidgetState createState() => _ConsumptionWidgetState();
}

class _ConsumptionWidgetState extends State<ConsumptionWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConsumptionDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            color: Color(0xffF9E07F),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 55,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xffFFEA96),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Energy Consumption',
                      style: TextStyle(
                          color: Color(0xffD3B84F),
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 5),
                    Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xffE8CA52),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/calender.png'),
                          Text(
                            DateFormat('dd MMM, yyyy').format(DateTime.now()),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoBox('energy.png',
                      '${widget.homeData['used_today']}kWh', 'Today'),
                  SizedBox(width: 10),
                  _buildInfoBox('plug.png',
                      '${widget.homeData['used_this_week']}kWh', 'This Week'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String image, String value, String label) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0xffFFEA96),
          ),
          child: Center(
            child: Image.asset('assets/images/$image', height: 25),
          ),
        ),
        SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                  color: Color(0xffD3B74C), fontWeight: FontWeight.w900),
            ),
            Text(
              label,
              style: TextStyle(
                  color: Color(0xffD3B74C),
                  fontWeight: FontWeight.w900,
                  fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  void _showConsumptionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.white.withOpacity(0.6),
      builder: (BuildContext context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.5, // Parent container height
            decoration: BoxDecoration(
                color: Color(0xffF9E07F),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close_rounded, color: Color(0xffE2C554),)),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffFFEA96)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Energy Consumption', style: TextStyle(color: Color(0xffD3B84F), fontSize: 12, fontWeight: FontWeight.w600),),
                      SizedBox(width: 5,),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        height: 35,
                        // width: 100,
                        decoration: BoxDecoration(
                            color: Color(0xffE8CA52),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/calender.png'),
                            Text(DateFormat('dd MMM, yyyy').format(DateTime.now()), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Color(0xffFFEA96)
                          ),
                          child: Center(
                            child: Image.asset('assets/images/energy.png', height: 25,),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.homeData['used_today'].toString()}kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900),),
                            Text('Today', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(width: 10,),
                    Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Color(0xffFFEA96)
                          ),
                          child: Center(
                            child: Image.asset('assets/images/plug.png', height: 20,),
                          ),
                        ),
                        SizedBox(width: 5,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.homeData['used_this_week'].toString()}kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900),),
                            Text('This Week', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.w900, fontSize: 12)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffFFEA96)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total devices running', style: TextStyle(color: Color(0xffD3B84F), fontSize: 12, fontWeight: FontWeight.w600),),
                      Text('15', style: TextStyle(color: Color(0xffD3B74C), fontSize: 14, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(alignment: Alignment.centerLeft, child: Text('My rooms',  style: TextStyle(color: Color(0xffD3B84F), fontWeight: FontWeight.bold),),),
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Color(0xffFFEA96),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text('Bedroom', style: TextStyle(color: Color(0xffD3B84F), fontSize: 12, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Color(0xffFFEA96)
                                ),
                                child: Center(
                                  child: Image.asset('assets/images/energy.png', height: 15,),
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text('31.7kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.bold),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Color(0xffFFEA96),
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text('Living Room', style: TextStyle(color: Color(0xffD3B84F), fontSize: 12, fontWeight: FontWeight.bold),),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Color(0xffFFEA96)
                                ),
                                child: Center(
                                  child: Image.asset('assets/images/energy.png', height: 15,),
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text('31.7kWh', style: TextStyle(color: Color(0xffD3B74C), fontWeight: FontWeight.bold),)
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        );
      },
    );
  }
}
