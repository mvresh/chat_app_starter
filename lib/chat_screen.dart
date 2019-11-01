import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  String id;
  ChatScreen({this.id});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  TextEditingController messageController = TextEditingController();
  String email;
  List<Widget> chatList = List<Widget>();

  @override
  void initState() {
    getMessageStream();
    messageController.addListener(() {
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  void getMessages() async {
    chatList = [];
    QuerySnapshot messages =
        await Firestore.instance.collection('messages').getDocuments();
    email =
        await FirebaseAuth.instance.currentUser().then((user) => user.email);
    //print(email);
    for (DocumentSnapshot message in messages.documents) {
      String text = message['text'];
      String sender = message['sender'];
      chatList.add(MessageBubble(
        message: text,
        isSender: sender == email,
        sender: sender,
      ));
    }
    setState(() {});
    print(chatList);

//    print(messages.documents.length);
//    messages.documents.forEach((message) => print(message.data));
  }

  void getMessageStream() async {
    email =
        await FirebaseAuth.instance.currentUser().then((user) => user.email);
    await for (var snapshot
        in Firestore.instance.collection('messages').snapshots()) {
      chatList.clear();
      for (var message in snapshot.documents) {
        String text = message['text'];
        String sender = message['sender'];
        chatList.add(MessageBubble(
          message: text,
          isSender: sender == email,
          sender: sender,
        ));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'CHAT',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Icon(Icons.power_settings_new,color: Colors.white,)),
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('chatroom').document(widget.id).collection('messages').orderBy('time').snapshots(),
                        builder: (context,snapshot){
                          if(!snapshot.hasData){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          else {
                            return ListView.builder(itemBuilder: (context,index){
                              return MessageBubble(
                                message: snapshot.data.documents[index].data['text'],
                                sender: snapshot.data.documents[index].data['sender'],
                                isSender: snapshot.data.documents[index].data['sender'] == email,
                              );
                            },itemCount: snapshot.data.documents.length,shrinkWrap: true,);
                          }
                        },
                      )
                    ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                  flex: 1,
                  child: IconButton(
                    color: messageController.text.isEmpty
                        ? Colors.grey
                        : Colors.blue,
                    icon: Icon(Icons.send),
                      onPressed: messageController.text.isEmpty
                          ? () {}
                          : () {
                        sendMessage();
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    email =
        await FirebaseAuth.instance.currentUser().then((user) => user.email);
    await Firestore.instance.collection('chatroom').document(widget.id)
        .collection('messages')
        .add({'sender': email, 'text': messageController.text,'time': DateTime.now()});
    messageController.clear();
  }
}

class MessageBubble extends StatelessWidget {
  String message;
  String sender;
  bool isSender;

  MessageBubble({this.message, this.isSender, this.sender});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSender ? Colors.blueAccent.shade100 : Colors.purple,
              borderRadius: isSender
                  ? BorderRadius.only(
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(5.0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                      bottomRight: Radius.circular(10.0),
                    ),
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Text(
                message,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
