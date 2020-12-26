import 'package:flutter/material.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/screens/status_history.dart';
import 'package:hehe/services/auth.dart';
import 'login.dart';

class SellerHomePage extends StatelessWidget {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink,
        body: Scaffold(
          appBar: new AppBar(
            leading: null,
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
              Container(
                margin: EdgeInsets.fromLTRB(0, 25, 10, 0),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.PNG'))),
              ),
              Container(
                  padding: EdgeInsets.fromLTRB(0, 52, 80, 20),
                  child: Text('Peking',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold))),
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                  icon: Icon(
                    Icons.history,
                    size: 28.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatusAndHistory()));
                  }),
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 50, 50, 20),
                  icon: Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    width: 800,
                    color: Colors.pink[100],
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      'Coba ya',
                      style: TextStyle(color: Colors.red[400], fontSize: 30),
                    ),
                  ),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    buttonPadding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.house),
                          iconSize: 40,
                          color: Colors.green[400],
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.car_repair),
                          iconSize: 40,
                          color: Colors.green[400],
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.store),
                          iconSize: 40,
                          color: Colors.green[400],
                          onPressed: () {})
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
