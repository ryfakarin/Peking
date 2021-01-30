import 'package:flutter/material.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/screens/home_seller_menetap.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/provider.dart';

class Wrapper extends StatelessWidget {

  int tipeUser;

  @override
  Widget build(BuildContext context) {

    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: getData(snapshot.data, context),
              builder: (BuildContext ctx, snapshot) {
                if (tipeUser == 0) {
                  return CustomerHomePage();
                } else if (tipeUser == 1) {
                  return SellerHomePage();
                } else if (tipeUser == 2)  {
                  return SellerStayHomePage();
                }
                return LoginPage();
              },
            );
          }
          return LoginPage();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  getData(String uid, BuildContext context) async {
    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      tipeUser = result.data['tipeUser'];
    });
  }
}
