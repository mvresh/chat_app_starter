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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            ReusableTopRow('Login'),
            ReusableEmailRow(screenSize: screenSize),
            ReusablePasswordRow(screenSize: screenSize),
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
    var deviceData = MediaQuery.of(context);
    var screenSize = deviceData.size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: <Widget>[
            ReusableTopRow('Register'),
            ReusableEmailRow(screenSize: screenSize),
            ReusablePasswordRow(screenSize: screenSize),
            ReusableButton(screenSize,'Register',Color(0xFFAB00B6)),
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

class ReusableTopRow extends StatelessWidget {
  String title;
  ReusableTopRow(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Hero(
          tag: 'avatar',
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
          ),
        ),
        SizedBox(width: 20,),
        Text(title,
            style: TextStyle(
                color: Colors.blue, fontSize: 45, letterSpacing: 1.5)),
        SizedBox(width: 40,),
      ],
    );
  }
}

class ReusableEmailRow extends StatelessWidget {
  const ReusableEmailRow({
    Key key,
    @required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.email),
        Container(width: screenSize.width * 0.7,
          child: TextField(
            style: TextStyle(fontSize: 15.0),
            decoration: InputDecoration(
                labelText: "elonmusk@spacex.com",
                border: OutlineInputBorder()
            ),
          ),
        ),
      ],
    );
  }
}

class ReusablePasswordRow extends StatelessWidget {
  const ReusablePasswordRow({
    Key key,
    @required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.lock),
        Container(width: screenSize.width * 0.7,
          child: TextField(
            style: TextStyle(fontSize: 15.0),
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Your Password",
                border: OutlineInputBorder()
            ),
          ),
        ),
      ],
    );
  }
}
