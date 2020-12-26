import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/chooseSellerTypeReg.dart';
import 'package:hehe/screens/chooseUserTypeReg.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'screens/inputUserNameReg.dart';
import 'screens/profile_seller.dart';
import 'package:hehe/wrapper.dart';
import 'package:hehe/services/auth.dart';
import 'package:provider/provider.dart';
import 'screens/home_customer.dart';
import 'screens/home_seller.dart';
import 'screens/login.dart';

class screenArguments {
  final String title;
  final String description;

  screenArguments(this.title, this.description);
}

class App extends StatelessWidget {

  int flag;

  @override
  Widget build(BuildContext context) {
    // return login page
    return StreamProvider<UserModel>.value(
        value: AuthService().user,
        child: MaterialApp(
          home: Wrapper(),
          routes: <String, WidgetBuilder>{
            '/homeCustomer' : (BuildContext context) => CustomerHomePage(),
            '/homeSeller' : (BuildContext context) => SellerHomePage(),
            '/profileCustomer' : (BuildContext context) => customerProfilePage(),
            '/profileSeller' : (BuildContext context) => sellerProfilePage(),
            '/inputUserNameReg' : (BuildContext context) => inputNamePage(flag),
            '/inputUserNameReg/1' : (BuildContext context) => inputNamePage(1),
            '/inputUserNameReg/2' : (BuildContext context) => inputNamePage(2),
          },
        ));
    // return home page (already signed in)
  }
}
