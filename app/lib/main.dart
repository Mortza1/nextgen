import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/tab.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';
import 'package:nextgen_software/scopedModel/connected_model_appliance.dart';
import 'package:scoped_model/scoped_model.dart';

import 'pages/home_page_body.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppModel model = AppModel();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  ScopedModel<AppModel>(
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

  final AppModel model;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          // color: Color(0xfffcfcfd),
          child:  CustomTabScreen(model: widget.model,),)
    );
  }
}