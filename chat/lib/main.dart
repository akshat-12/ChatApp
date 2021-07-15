import 'package:chat/helper/authenticate.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth.dart';
import 'package:chat/views/signin.dart';
import 'package:chat/views/signup.dart';
import 'package:chat/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ModelUser?>.value(
      initialData: null,
      value: Auth().stream,
      child: MaterialApp(
        title: 'Flutter Demo',
        home: Wrapper(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff1F1F1F),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
