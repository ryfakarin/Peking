import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    final Firestore db = Provider.of(context).db;
    return StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool signedIn = snapshot.hasData;
            return signedIn
                ? CustomerHomePage() : LoginPage();
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
