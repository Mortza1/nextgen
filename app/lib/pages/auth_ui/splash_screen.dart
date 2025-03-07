import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/tab.dart';
import '../../scopedModel/app_model.dart';

class SplashScreen extends StatefulWidget {
  final AppModel model;

  const SplashScreen({Key? key, required this.model}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay the navigation by 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      _navigateBasedOnLoginState();
    });
  }

  Future<void> _navigateBasedOnLoginState() async {
    print('Checking login status...');
    await widget.model.checkLoginStatus(); // Ensure this completes successfully
    print('Login status: ${widget.model.isLoggedIn}');

    // Navigate based on login status after checking
    if (widget.model.isLoggedIn) {
      print('Navigating to CustomTabScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomTabScreen(model: widget.model),
        ),
      );
    } else {
      print('Navigating to LoginPage...');
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => LoginPage(appModel: widget.model)),
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomTabScreen(model: widget.model),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xff9D79BC)
        ),
        child: Center(
          child: Image.asset('assets/images/splash.png', height: 130,),
        ),
      )
    );
  }
}
