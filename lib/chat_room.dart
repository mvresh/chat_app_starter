import 'package:chat_app_starter/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    await mainCollection.document(id.toString()).setData({'Name':name});
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
            title: Text('Chat Room Name'),
            content: TextField(
              onChanged: (newValue){
                name = newValue;
              },
              controller: nameTextController,
              decoration: InputDecoration(hintText: "Enter"),
            ),
            actions: <Widget>[
               FlatButton(
                child: new Text('CREATE'),
                onPressed: (){
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
              RaisedButton(
                onPressed: () => newChatRoomDialog(context),
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
              Flexible(
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
                              child: Card(
                                elevation: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.documents[index].data['Name'],
                                            style: TextStyle(
                                                color: Colors.blue, fontSize: 21),
                                          ),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: mainCollection
                                                .document(
                                                '${snapshot.data.documents[index].documentID}')
                                                .collection('messages').snapshots(),
                                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                              print('snapshot ${snapshot.connectionState}');
                                              switch (snapshot.connectionState) {
                                                case ConnectionState.waiting: return Text('Awaiting number of messages...');
                                                default:
                                                  if (snapshot.hasError)
                                                    return Text('Error: ${snapshot.error}');
                                                  else
                                                    return Text(snapshot.data.documents.length.toString());
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
                                    RaisedButton(
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
                                        'Join',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 21),
                                      ),
                                      color: Colors.purple,
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
      ),
    );
  }

  @override
  void dispose() {
    nameTextController.dispose();
    super.dispose();
  }
}
