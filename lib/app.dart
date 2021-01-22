import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/screens/regCustomer.dart';
import 'package:hehe/screens/regSeller.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:hehe/wrapper.dart';
import 'package:hehe/services/auth.dart';
import 'screens/home_customer.dart';
import 'screens/home_seller.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return login page
    return Provider(
        auth: AuthService(),
        db: Firestore.instance,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
          routes: <String, WidgetBuilder>{
            '/loginPage': (BuildContext context) => LoginPage(),
            '/homeCustomer': (BuildContext context) => CustomerHomePage(),
            '/homeSeller': (BuildContext context) => SellerHomePage(),
            '/regSeller': (BuildContext context) => regSellerPage(),
            '/regCust': (BuildContext context) => regCustomerPage(0),
          },
        ));
    // return home page (already signed in)
  }
}
