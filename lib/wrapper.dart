import 'package:flutter/material.dart';
import 'package:hehe/auth/authentication.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:hehe/screens/login.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    print(user);
    if (user == null) {
      return CustomerHomePage();
    } else {
      return LoginPage();
    }
  }
}
