import 'package:flutter/material.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:nextgen_software/pages/auth_ui/login.dart';
import 'package:nextgen_software/pages/settings/preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: main(),
      ),
    );
  }

  Widget main() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 20), // Prevents keyboard overlap
        decoration: BoxDecoration(color: Color(0xffF3F4FC)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            top(),
            SizedBox(height: 20),
            icon(),
            SizedBox(height: 20),
            field('Name'),
            field('Username'),
            field('Password'),
            field('Email'),
            field('Phone number'),
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
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, size: 20, color: Color(0xffC2C3CD)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Preferences',
                    style: TextStyle(
                        color: Color(0xffAFB0BA),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget icon() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/man.png', height: 80),
          SizedBox(height: 5),
          Text(
            'Change Avatar',
            style: TextStyle(color: Color(0xff00AB5E), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget field(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Color(0xffA8A9B6), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Reduced padding
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x96C2C3CD), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(18)), // Smaller rounded corners
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0x96C2C3CD), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 2.5),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
