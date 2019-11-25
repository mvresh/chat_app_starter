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
  DocumentSnapshot title;
  String titleString;
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
    title = await Firestore.instance.collection('chatroom').document('${widget.id}').get();
    titleString = title.data['Name'].toString();
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
      backgroundColor: Color(0xFF202020),
      appBar: AppBar(
        title: Text(
          titleString == null ? '' : titleString,
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
          SizedBox(
            width: 5,
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
              child: Image(
                image: AssetImage('assets/bts1.jpg'),
              )),
          Column(
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
                      flex: 85,
                      child: TextField(
                        controller: messageController,
                        style: TextStyle(color: Colors.black,
                            fontFamily: 'Grand',letterSpacing: 1.15),
                        decoration: InputDecoration(

                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          hintText: 'Send a message',
                          hintStyle: TextStyle(fontFamily: 'Grand',letterSpacing: 1.5,color: Colors.black),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(color: Colors.yellowAccent.shade400)
                            )
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 10,
                      child: IconButton(
                          color: messageController.text.isEmpty
                              ? Colors.grey
                              : Colors.blue,
                          icon: Icon(Icons.send),
                          onPressed: messageController.text.isEmpty
                              ? () {}
                              : () {
                            sendMessage();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      )
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
            style: TextStyle(color: Colors.white,fontFamily: 'Grand'),
          ),
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: isSender ? Colors.yellowAccent.shade400 : Colors.white,
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
                style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'Grand'),
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
