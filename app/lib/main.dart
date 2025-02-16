import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/components/assistant_button.dart';
import 'package:nextgen_software/pages/auth_ui/splash_screen.dart';
import 'package:nextgen_software/scopedModel/app_model.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final AppModel model = AppModel();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppModel>(
      model: model,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(model: model), // Pass the AppModel instance here
      ),
    );
  }
}
