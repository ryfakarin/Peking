import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/wrapper.dart';
import 'package:hehe/services/auth.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return login page
    return StreamProvider<UserModel>.value(
        value: AuthService().user, child: MaterialApp(home: Wrapper()));

    // return home page (already signed in)
  }
}
