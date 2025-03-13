import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/auth_ui/register.dart';
import 'package:nextgen_software/pages/tab.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scopedModel/app_model.dart';

class LoginPage extends StatefulWidget {
  final AppModel appModel;
  const LoginPage({super.key, required this.appModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return ScopedModelDescendant<AppModel>(
      builder: (context, child, model) {
        return Scaffold(
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xff9D79BC)
                  ),
                ),
                SingleChildScrollView( // Add scroll view here
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.35,
                        child: Center(
                          child: Image.asset('assets/images/splash.png', height: 80,),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.65,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),  // Set top-left corner radius
                            topRight: Radius.circular(30.0), // Set top-right corner radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20,),
                              Text('Login', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),),
                              SizedBox(height: 50,),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'email',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xff9D79BC), width: 2)
                                    )
                                ),
                              ),
                              SizedBox(height: 5,),
                              TextField(
                                controller: passwordController,  // Fixed to passwordController
                                obscureText: true,  // Hides the entered text to make it a password field
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',  // Updated hint text to be more user-friendly
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff9D79BC), width: 2),
                                  ),
                                ),
                              ),

                              SizedBox(height: 20,),
                              GestureDetector(
                                onTap: _isLoading
                                    ? null
                                    : () async {
                                  setState(() {
                                    _isLoading = true; // Start loading
                                  });
                                  try {
                                    await widget.appModel.login(
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomTabScreen(model: widget.appModel),
                                      ),
                                    );
                                  } catch (e) {
                                    // Show Snackbar on login failure
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Login failed: ${e.toString()}"),
                                        backgroundColor: Color(0xff9D79BC),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      _isLoading = false; // Stop loading
                                    });
                                  }
                                },

                                child: Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  child: Center(
                                    child: _isLoading
                                        ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white, // Adjust color to match the theme
                                        strokeWidth: 2.0, // Optional: control thickness
                                      ),
                                    )
                                        : Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Don't have an account? "),
                                  SizedBox(width: 5,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(model: widget.appModel,),
                                        ),
                                      );
                                    },
                                      child: Text('Register', style: TextStyle(color: Color(0xff9D79BC)),))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
