import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets4all/blocs/authBloc.dart';
import 'package:provider/provider.dart';

class Pets4allDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    final user$ = authService.user.where((user) => user != null);
    return StreamBuilder<FirebaseUser>(
      stream: user$,
      builder: (context, snap) {
        final user = snap.data;
        if (snap.hasData) {
          return Drawer(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person_outline),
                  title: Text(user.displayName),
                  onTap: null,
                ),

                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: null,
                ),

                ///This is not the way it should be done, or is it?
                Align(
                  heightFactor: 3.5,
                  alignment: Alignment.bottomLeft,
                  child: FlatButton(
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () {
                      ///You must pop drawer manually
                      Navigator.pop(context);
                      authService.signOut();
                      // Navigator.of(context).pushAndRemoveUntil(
                      // MaterialPageRoute(builder: (_) => PhoneLoginScreen()),
                      // (Route r) => r == null);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
