import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pets4all/blocs/forum_bloc.dart';
import 'package:pets4all/models/question.dart';
import 'package:pets4all/models/events.dart';
import 'package:pets4all/models/forums.dart';
import "package:pets4all/blocs/authBloc.dart";
import 'package:pets4all/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      value: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Color(0xFFF92b7e),
        ),
        home: Login(),
      ),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return StreamBuilder(
        stream: authService.user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => authService.googleSignIn(),
                    child: Text("login in"),
                  )
                ],
              ),
            );
          }
          return HomeScreen();
        });
  }
}
