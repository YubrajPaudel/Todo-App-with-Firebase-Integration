import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/screens/todo_homepage.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  height: 50,
                ),
                Text(
                  "Register",
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
                          height: 5,
                        ),
                        const Text(
                          "Don't remember your password?",
                          style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () async {
                              try {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    )
                                    .then((value) => {
                                          Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TodoApp()))
                                              .onError((error, stackTrace) => {
                                                    print("Error Occurred"),
                                                  }),
                                        });
                              } catch (e) {
                                print(e.toString());
                              }

                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.orange,
                                      content: Text('Processing Data')),
                                );
                              }
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
