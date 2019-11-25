import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool loading = false;
  bool wrongCredentials = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color(0xFF202020),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ModalProgressHUD(
            inAsyncCall: loading,
            progressIndicator: CircularProgressIndicator(),
            child: Stack(
              children: <Widget>[
                Center(
                    child: Image(
                      image: AssetImage('assets/bts1.jpg'),
                    )),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          'KPOP United',
                          style: TextStyle(
                              color: Colors.yellowAccent.shade400,
                              fontFamily: 'Grand',
                              letterSpacing: 2,
                              fontSize: 40),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            style: TextStyle(color: Colors.yellowAccent.shade400,
                                fontFamily: 'Grand'),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (newValue) {
                              email = newValue;
                            },
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                letterSpacing: 1.5,
                                fontFamily: 'Grand',),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.yellowAccent.shade400,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                              hintText: 'enter your email',
                              icon: Icon(Icons.email,color: Colors.yellowAccent.shade400,),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid
                                  )
                              ),),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            style: TextStyle(color: Colors.yellowAccent.shade400,
                                fontFamily: 'Grand'),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            obscureText: true,
                            onChanged: (newValue) {
                              password = newValue;
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock,color: Colors.yellowAccent.shade400,),
                              hintText: 'enter your password',
                              hintStyle: TextStyle(
                                letterSpacing: 1.5,
                                fontFamily: 'Grand',),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.yellowAccent.shade400,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(15.0),

                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      style: BorderStyle.solid
                                  )
                              ),),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0))),
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.black,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 24),
                            ),
                            color: Colors.yellowAccent.shade400,
                            onPressed: () async{
                              setState(() {
                                loading = true;
                              });
                              try {
                                AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                                //print(result.user);
                                Navigator.pushNamed(context, '/chatroom');
                              } on Exception catch (e) {
                                wrongCredentials = true;
                                loading = false;
                                setState(() {

                                });
                                // TODO
                              }
                            },
                          ),
                          SizedBox(height: 5,),
                          Center(child: Text(!wrongCredentials?'':'Please check your email and password',style: TextStyle(
                              color: Colors.yellowAccent.shade400,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 20
                          ),)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}