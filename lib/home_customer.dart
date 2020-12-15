import 'package:flutter/material.dart';
import 'package:hehe/status_history.dart';
import 'profile_customer.dart';
import 'login.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      // fontStyle: FontStyle.italic,
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
                        builder: (context) => customerProfilePage()));
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.black,
          height: 800,
          child: Column(
            children: <Widget>[Container()],
          ),
        ),
      ),
    ));
  }
}
