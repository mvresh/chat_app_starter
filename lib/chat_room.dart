import 'package:chat_app_starter/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    await mainCollection.document(id.toString()).setData({});
    print('clicked');
    setState(() {});
  }
//
//  void getChatRooms()async{
//    await Firestore.instance.collection('chatroom').getDocuments();
//
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: newChatRoom,
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Text(
                  'New Chat Room',
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
                color: Colors.blue,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection('chatroom').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: RaisedButton(
                                onPressed: () async {
                                  await mainCollection
                                      .document(
                                          '${snapshot.data.documents[index].documentID}')
                                      .collection('messages')
                                      .add({'timestamp': DateTime.now()});
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen(id: snapshot.data.documents[index].documentID,)));
                                },
                                padding: EdgeInsets.all(16),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                child: Text(
                                  snapshot.data.documents[index].documentID,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                ),
                                color: Colors.purple,
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
      ),
    );
  }
}
