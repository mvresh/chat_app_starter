import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    bool detailsEntered = true;
    return WillPopScope(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          backgroundColor: Color(0xFF202020),
          body: GestureDetector(
            onTap: (){
              FocusScope.of(context).requestFocus(new FocusNode());
            },
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
                      Container(
                        alignment: Alignment.center,
                        child: Column(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.black,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 24),
                              ),
                              color: Colors.yellowAccent.shade400,
                              onPressed: () {if(email!='' && password != ''){
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);
                                Navigator.pushNamed(context, 'login');
                              }
                              else{
                                detailsEntered = false;
                                setState(() {

                                });
                              }
                              },
                            ),
                          ],
                        ),
                      ),
                      Center(child: Text(detailsEntered?'':'Enter email and password',style: TextStyle(
                          color: Colors.yellowAccent.shade400,fontFamily: 'Grand',letterSpacing: 1.15, fontSize: 20
                      ),))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
