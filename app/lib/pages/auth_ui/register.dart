import 'package:flutter/material.dart';
import 'package:nextgen_software/pages/tab.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scopedModel/app_model.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  final AppModel model;
  const RegisterPage({super.key, required this.model});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController tokenController = TextEditingController();
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
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color(0xff9D79BC)
                  ),
                ),
                SingleChildScrollView( // Add scroll view here
                  child: Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.25,
                        child: Center(
                          child: Image.asset('assets/images/splash.png', height: 80,),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
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
                              Text('Register', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700, fontFamily: 'Roboto'),),
                              SizedBox(height: 50,),
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'full name',
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xff9D79BC), width: 2)
                                    )
                                ),
                              ),
                              SizedBox(height: 5,),
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
                                controller: tokenController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'token received on email',
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
                                  hintText: 'new password',  // Updated hint text to be more user-friendly
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
                                    await widget.model.register(
                                      nameController.text,
                                      tokenController.text,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CustomTabScreen(model: widget.model),
                                      ),
                                    );
                                    
                                    // Optionally, navigate or show success message
                                  } catch (e) {
                                    // Handle error
                                    print("Error: $e");
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
                                      'Register',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Already have an account? "),
                                  SizedBox(width: 5,),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(appModel: widget.model,),
                                        ),
                                      );
                                    },
                                      child: Text('Login', style: TextStyle(color: Color(0xff9D79BC)),))
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
