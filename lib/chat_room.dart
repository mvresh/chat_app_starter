import 'package:chat_app_starter/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

CollectionReference mainCollection = Firestore.instance.collection('chatroom');

class _ChatRoomState extends State<ChatRoom> {
  void newChatRoom() async {
    int id = Random().nextInt(300);
    await mainCollection.document(id.toString()).setData({'Name': name});
    print('clicked');
    setState(() {});
  }

//
//  void getChatRooms()async{
//    await Firestore.instance.collection('chatroom').getDocuments();
//
//  }
  TextEditingController nameTextController = TextEditingController();
  String name;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  newChatRoomDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Space Name',
                style: TextStyle(fontFamily: 'Grand', letterSpacing: 1.15)),
            content: TextField(
              onChanged: (newValue) {
                name = newValue;
              },
              controller: nameTextController,
              decoration: InputDecoration(hintText: "Enter"),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('CREATE',
                    style: TextStyle(fontFamily: 'Grand', letterSpacing: 1.15)),
                onPressed: () {
                  newChatRoom();
                  nameTextController.clear();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat Rooms',
            style: TextStyle(
                color: Colors.yellowAccent.shade400,
                fontFamily: 'Grand',
                letterSpacing: 1.15,
                fontSize: 30),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Icon(Icons.power_settings_new,color: Colors.red.shade200,)),
          ],
        ),
        backgroundColor: Color(0xFF202020),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                  child: Image(
                image: AssetImage('assets/bts1.jpg'),
              )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () => newChatRoomDialog(context),
                      padding: EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0))),
                      child: Text(
                        'New Space',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Grand',
                            letterSpacing: 1.15,
                            fontSize: 24),
                      ),
                      color: Colors.yellowAccent.shade400,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('chatroom')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Card(
                                      elevation: 10,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: <Widget>[
                                                Text(
                                                    snapshot.data.documents[index]
                                                        .data['Name'],
                                                    style: TextStyle(
                                                        color: Colors.yellowAccent
                                                            .shade200,
                                                        fontFamily: 'Grand',
                                                        letterSpacing: 1.15,
                                                        fontSize: 24)),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: mainCollection
                                                      .document(
                                                          '${snapshot.data.documents[index].documentID}')
                                                      .collection('messages')
                                                      .snapshots(),
                                                  builder: (BuildContext context,
                                                      AsyncSnapshot<QuerySnapshot>
                                                          snapshot) {
                                                    print(
                                                        'snapshot ${snapshot.connectionState}');
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                          .waiting:
                                                        return Text(
                                                            'waiting');
                                                      default:
                                                        if (snapshot.hasError)
                                                          return Text(
                                                              'Error: ${snapshot.error}');
                                                        else
                                                          return Text('frequency : ${snapshot
                                                              .data
                                                              .documents
                                                              .length
                                                              .toString()}',
                                                              style: TextStyle(color: Colors.yellowAccent.shade400,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 20));
                                                    }
                                                  },
                                                ),
//                                          Text(mainCollection
//                                              .document(
//                                              '${snapshot.data.documents[index].documentID}')
//                                              .collection('messages').snapshots().length.toString(),style: TextStyle(
//                                              color: Colors.purpleAccent, fontSize: 10)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                              onPressed: () async {
                                                await mainCollection
                                                    .document(
                                                        '${snapshot.data.documents[index].documentID}')
                                                    .collection('messages')
                                                    .add({
                                                  'timestamp': DateTime.now()
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            ChatScreen(
                                                              id: snapshot
                                                                  .data
                                                                  .documents[index]
                                                                  .documentID,
                                                            )));
                                              },
                                              padding: EdgeInsets.all(16),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
                                              child: Text(
                                                'JOIN',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Grand',
                                                    letterSpacing: 1.15,
                                                    fontSize: 18),
                                              ),
                                              color: Colors.yellowAccent.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: snapshot.data.documents.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }
}
