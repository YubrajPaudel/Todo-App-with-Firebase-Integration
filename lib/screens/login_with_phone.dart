import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/screens/verify_code.dart';
import 'package:todo_app/widgets/custom_button.dart';

class PhoneAuthenticationScreen extends StatefulWidget {
  const PhoneAuthenticationScreen({super.key});

  @override
  State<PhoneAuthenticationScreen> createState() =>
      _PhoneAuthenticationScreenState();
}

class _PhoneAuthenticationScreenState extends State<PhoneAuthenticationScreen> {
  final auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        elevation: .5,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 214, 214),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: "+9779876543210",
                  contentPadding: EdgeInsets.all(10),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                    onPressed: () {
                      auth.verifyPhoneNumber(
                          phoneNumber: phoneController.text,
                          verificationCompleted: (_) {},
                          verificationFailed: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          },
                          codeSent: (String verification, int? token) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyCode(
                                          verificationId: verification,
                                        )));
                          },
                          codeAutoRetrievalTimeout: (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          });
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ))),
          ],
        ),
      ),
    );
  }
}
