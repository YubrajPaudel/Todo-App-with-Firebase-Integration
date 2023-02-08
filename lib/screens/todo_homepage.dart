import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:todo_app/screens/register.dart';
import 'package:todo_app/screens/search_screen.dart';

import 'homepage.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  final CollectionReference todos =
      FirebaseFirestore.instance.collection('events');
  List todoDetails = [];

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter the TODO Details.'),
            content: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: _eventController,
                      decoration: InputDecoration(hintText: "Event Name"),
                    ),
                    TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: _timeController,
                      decoration: InputDecoration(hintText: "Time"),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  if (_eventController.text.isNotEmpty &&
                      _timeController.text.isNotEmpty) {
                    setState(() {
                      insertData(
                        _eventController.text,
                        _timeController.text,
                      );
                    });

                    print("inside insertdata");
                  } else {
                    print("Data not inserted");
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff009d8e),
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  child: Icon(
                    Icons.search_outlined,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        // Eliminating all the routes and exit the app
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const HomePage()),
                            (Route<dynamic> route) => false);
                      }).onError((error, stackTrace) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(error.toString()),
                        ));
                      });
                    },
                    child: Icon(
                      Icons.logout_outlined,
                    )),
              ],
            ),
          ),
        ],
        title: Text(
          "TODO",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: todos.where('uid', isEqualTo: userid).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Color(0xff009d8e), Color(0xAFFFC107)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            if (userid ==
                                streamSnapshot.data!.docs[index]['uid']) {
                              return Card(
                                margin: EdgeInsets.all(10),
                                child: ListTile(
                                  title: Text(streamSnapshot.data!.docs[index]
                                      ['event']),
                                  subtitle: Text(
                                      streamSnapshot.data!.docs[index]['time']),
                                  trailing: Wrap(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Enter the TODO Details.'),
                                                  content: Stack(
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            onChanged: (value) {
                                                              setState(() {});
                                                            },
                                                            controller:
                                                                _eventController,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        "Event Name"),
                                                          ),
                                                          TextField(
                                                            onChanged: (value) {
                                                              setState(() {});
                                                            },
                                                            controller:
                                                                _timeController,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        "Time"),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: Text('CANCEL'),
                                                      onPressed: () {
                                                        setState(() {
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        if (_eventController
                                                                .text
                                                                .isNotEmpty &&
                                                            _timeController.text
                                                                .isNotEmpty) {
                                                          setState(() {
                                                            todos
                                                                .doc(streamSnapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id)
                                                                .update({
                                                              'event':
                                                                  _eventController
                                                                      .text,
                                                              'time':
                                                                  _timeController
                                                                      .text
                                                            });
                                                          });

                                                          print("Edited data");
                                                        } else {
                                                          print("Cannot edit");
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Icon(Icons.edit,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            todos
                                                .doc(streamSnapshot
                                                    .data!.docs[index].id)
                                                .delete();
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text("No data");
                            }
                            // return Row(
                            //   children: [
                            //     Flexible(
                            //       child: Container(
                            //         padding: EdgeInsets.all(15),
                            //         width: MediaQuery.of(context).size.width,
                            //         height: 70,
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(20.0),
                            //         ),
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Icon(Icons.circle, color: Colors.pink),
                            //             Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.center,
                            //               crossAxisAlignment:
                            //                   CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   streamSnapshot.data!.docs[index]
                            //                       ['event'],
                            //                   style: TextStyle(
                            //                       color: Colors.black,
                            //                       fontSize: 15,
                            //                       fontWeight: FontWeight.bold),
                            //                 ),
                            //                 Text(
                            //                   streamSnapshot.data!.docs[index]
                            //                       ['time'],
                            //                   style: TextStyle(
                            //                       color: Colors.grey,
                            //                       fontSize: 10,
                            //                       fontWeight: FontWeight.bold),
                            //                 ),
                            //               ],
                            //             ),
                            //             Icon(
                            //               Icons.star,
                            //               color: Colors.yellow,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     )
                            //   ],
                            // );
                          }),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          primary: Colors.black,
          onPrimary: Colors.white,
        ),
        onPressed: () async {
          return await _displayTextInputDialog(context);
        },
        child: const Icon(
          Icons.add,
          size: 70,
          color: Colors.white,
        ),
      ),
    );
  }

  void insertData(String event, String time) {
    todos.doc().set({
      'event': event,
      'time': time,
      'uid': userid,
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Added to database')),
        ));
    _eventController.clear();
    _timeController.clear();
  }
}
