import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_app/screens/todo_homepage.dart';

class VerifyCode extends StatefulWidget {
  final verificationId;
  VerifyCode({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  @override
  final auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Verification",
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
                keyboardType: TextInputType.number,
                controller: codeController,
                decoration: InputDecoration(
                  hintText: "6 Digit Code",
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
                    onPressed: () async {
                      final credential = PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: codeController.text);
                      try {
                        await auth.signInWithCredential(credential);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => TodoApp()));
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: Text(
                      "Verify",
                      style: TextStyle(color: Colors.white),
                    ))),
          ],
        ),
      ),
    );
  }
}
