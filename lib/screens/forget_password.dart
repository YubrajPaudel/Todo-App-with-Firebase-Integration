import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_app/screens/homepage.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 197, 195, 195),
                  borderRadius: BorderRadius.circular(20)),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    hintText: 'E-mail',
                    border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                  onPressed: () {
                    auth
                        .sendPasswordResetEmail(
                            email: emailController.text.toString())
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Email sent with reset link")));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    });
                  },
                  child: Text(
                    "Forget",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
