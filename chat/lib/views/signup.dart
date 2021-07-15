import 'package:chat/services/auth.dart';
import 'package:chat/services/database.dart';
import 'package:chat/views/chatroom.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({required this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Auth _auth = new Auth();
  Database _db = new Database();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: appBarMain(context),
            backgroundColor: Color(0xFF1F1F1F),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 50,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty || val.length < 2
                                    ? "Please provide a valid username"
                                    : null;
                              },
                              controller: username,
                              decoration: textFieldInputDecoration('Username'),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              validator: (val) => EmailValidator.validate(val!)
                                  ? null
                                  : "Enter a valid email",
                              controller: email,
                              decoration: textFieldInputDecoration('Email'),
                              style: simpleTextStyle(),
                            ),
                            TextFormField(
                              validator: (val) => val!.length > 6
                                  ? null
                                  : 'Please enter a valid password',
                              obscureText: true,
                              controller: password,
                              decoration: textFieldInputDecoration('Password'),
                              style: simpleTextStyle(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child:
                              Text('Forgot Password', style: simpleTextStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signUpWithEmail(
                                email.text, password.text);
                            if (result == null) {
                              setState(() {
                                AlertDialog(
                                  title:
                                      Text('Error detected. Cannot sign up.'),
                                  content: Text(
                                      "There seems to be some error. Please try again and make sure you're using correct credentials."),
                                );
                                loading = false;
                              });
                            } else {
                              Map<String, String> userMap = {
                                "name": username.text,
                                "email": email.text,
                              };
                              _db.uploadUserInfo(userMap);
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff007EF4),
                                Color(0xff2A75BC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
