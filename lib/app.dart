import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'package:hehe/widgets/provider.dart';
import 'screens/profile_seller.dart';
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
        child: MaterialApp(
              home: Wrapper(),
              routes: <String, WidgetBuilder>{
                '/loginPage' : (BuildContext context) => LoginPage(),
                '/homeCustomer' : (BuildContext context) => CustomerHomePage(),
                '/homeSeller' : (BuildContext context) => SellerHomePage(),
                '/profileCustomer' : (BuildContext context) => customerProfilePage(),
                '/profileSeller' : (BuildContext context) => sellerProfilePage(),
                // '/inputUserNameReg' : (BuildContext context) => inputNamePage(flag),
                // '/inputUserNameReg/1' : (BuildContext context) => inputNamePage(1),
                // '/inputUserNameReg/2' : (BuildContext context) => inputNamePage(2),
              },
            )
    );
    // return home page (already signed in)
  }
}
