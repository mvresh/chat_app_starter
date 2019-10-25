import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/Login': (context) => LoginScreen(),
        '/Register': (context) => RegisterScreen(),
      }
  ));
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var screenSize = deviceData.size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Hero(
              tag: 'avatar',
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.blue,
              ),
            ),
            Text('McLaren Chat',
                style: TextStyle(
                    color: Colors.blue, fontSize: 45, letterSpacing: 1.5)),
            ReusableButton(screenSize,'Login',Color(0xFF0096FB)),
            ReusableButton(screenSize, 'Register', Color(0xFFAB00B6)),
          ],
        ),
      ),
    );
  }
}

class ReusableButton extends StatelessWidget {
  final Color color;
  final Size screenSize;
  final String text;

  ReusableButton(this.screenSize,this.text,this.color);


  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: screenSize.width * 0.9,
        height: screenSize.height * 0.12,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        buttonColor: color,
        child: RaisedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/$text');
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              letterSpacing: 1.3,
            ),
          ),
        ));
  }
}



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var screenSize = deviceData.size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'avatar',
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                  ),
                ),
                Text('Login',
                    style: TextStyle(
                        color: Colors.blue, fontSize: 45, letterSpacing: 1.5)),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration(
                    labelText: "Phone or Email",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Your Password",
                    border: OutlineInputBorder()
                ),
              ),
            ),
            ReusableButton(screenSize,'Login',Color(0xFF0096FB)),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
