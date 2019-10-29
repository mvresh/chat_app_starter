import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'CHAT',
          style: TextStyle(color: Colors.blue, fontSize: 25),
        ),
        actions: <Widget>[
          FlatButton(
              color: Colors.purple,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(
            width: 5,
          ),
          FlatButton(
              color: Colors.blue,
              onPressed: () {}, child: Text('Download', style: TextStyle(color: Colors.white))),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Flexible(
            flex: 9,
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: InputBorder.none,
                hintText: 'Send a message',
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {},
              child: Text('Send',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
