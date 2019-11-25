import 'package:chat_app_starter/chat_room.dart';
import 'package:chat_app_starter/register_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        'login': (context) => LoginScreen(),
        'register': (context) => RegisterScreen(),
        '/chat': (context) => ChatScreen(),
        '/chatroom': (context) => ChatRoom(),
      },
    ),
  );
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  Route _createRoute(screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.slowMiddle;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Center(child: Image(image: AssetImage('assets/bts1.jpg'),)),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
//          Hero(
//            tag: 'LogoImage',
//            child: Image(
//                image:
//                NetworkImage('https://mclarencollege.in/images/icon.png'),
//                width: 200,
//                height: 200,
//                fit: BoxFit.contain),
//          ),
                Container(
                  padding: EdgeInsets.fromLTRB(50, 12, 50, 12),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'KPOP United',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 2,
                            color: Colors.yellowAccent.shade400,
                            fontSize: 40,
//                          color: Color(0xFF202020),
                            fontFamily: 'Grand'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        elevation: 10,
                        onPressed: () {
//                          Navigator.pushNamed(context, 'login');
                          Navigator.of(context).push(_createRoute(LoginScreen()));
                        },
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.black, fontSize: 24,letterSpacing: 1.15,fontFamily: 'Grand'),
                        ),
                        color: Colors.yellowAccent.shade400,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        onPressed: () {
//                          Navigator.pushNamed(context, 'register');
                          Navigator.of(context).push(_createRoute(RegisterScreen()));
                        },
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12.0))),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 24),
                        ),
                        color: Colors.yellowAccent.shade400,
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}