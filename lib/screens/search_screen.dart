import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'homepage.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _eventController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  final searchFilter = TextEditingController();
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
                      insertData(_eventController.text, _timeController.text);
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
      backgroundColor: Color.fromARGB(255, 231, 230, 230),
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: TextFormField(
            controller: searchFilter,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search',
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              setState(() {});
            },
          ),
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
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final event =
                                streamSnapshot.data!.docs[index]['event'];
                            //searching logic

                            if (searchFilter.text.isEmpty) {
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
                            } else if (event.toLowerCase().contains(
                                searchFilter.text.toLowerCase().toString())) {
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
                              return Container();
                            }
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
    todos.add({'event': event, 'time': time}).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text('Added to database')),
            ));
    _eventController.clear();
    _timeController.clear();
  }
}
