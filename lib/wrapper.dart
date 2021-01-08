import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn ? CustomerHomePage() : LoginPage();
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
