import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/tab.dart';
import 'package:nextgen_software/scopedModel/connectedModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/home_page_body.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ApplianceModel model = ApplianceModel();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ScopedModel<ApplianceModel>(
      model: model,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(model),
      ),);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(this.model, {super.key});

  final ApplianceModel model;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          // color: Color(0xfffcfcfd),
          child:  CustomTabScreen(model: widget.model,),)
    );
  }
}