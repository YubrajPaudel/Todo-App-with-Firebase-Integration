import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/forget_password.dart';
import 'package:todo_app/screens/login_with_phone.dart';

import 'todo_homepage.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              //Main Column
              children: [
                SizedBox(
                  height: 25,
                ),
                Image.asset(
                  "assets/calendar.png",
                  height: 150,
                  width: 150,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Todo App",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Divider(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email required*';
                            }
                            return null;
                          },
                          controller: _emailController,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email_rounded,
                            ),
                            border: InputBorder.none,
                            hintText: "Enter your email...",
                            label: Text("E-mail"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password required*';
                            }
                            return null;
                          },
                          obscureText: true,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.lock),
                            border: InputBorder.none,
                            hintText: "Enter your password...",
                            label: Text("Password"),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ForgetPasswordScreen()));
                        },
                        child: const Text(
                          "Don't remember your password?",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            User? user = await loginUsingEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context);
                            if (_formKey.currentState!.validate()) {
                              print(user);
                              if (user != null) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a databas

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TodoApp()));
                              } else {
                                print("Credentials Not matched");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.orange,
                                      content:
                                          Text('Enter Correct Credentials')),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomButton(text: "Register", btncolor: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PhoneAuthenticationScreen()));
                        },
                        child: Text(
                          "Use phone to sign in? Tap me!!",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
