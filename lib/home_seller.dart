import 'package:flutter/material.dart';
import 'package:hehe/profile_seller.dart';
import 'package:hehe/status_history.dart';
import 'login.dart';

class SellerHomePage extends StatelessWidget {
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
                padding: EdgeInsets.fromLTRB(0, 25, 25, 0),
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
              margin: EdgeInsets.fromLTRB(0, 15, 10, 0),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.PNG'))),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 50, 110, 20),
                child: Text('Peking',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold))),
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 40, 20, 20),
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
                padding: EdgeInsets.fromLTRB(0, 40, 50, 20),
                icon: Icon(
                  Icons.account_circle,
                  size: 30.0,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerProfilePage()));
                }),
          ],
        ),
        body: Container(
          height: 800,
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                width: 800,
                color: Colors.pink[200],
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 200, 0, 350),
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
                      iconSize: 60,
                      color: Colors.red[600],
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.car_repair),
                      iconSize: 60,
                      color: Colors.red[600],
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(Icons.store),
                      iconSize: 60,
                      color: Colors.red[600],
                      onPressed: () {})
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class trialClass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class showedContainer extends StatelessWidget {
  final String containerName = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width: 800,
      color: Colors.pink[200],
      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
      padding: EdgeInsets.fromLTRB(0, 200, 0, 350),
      child: Text(
        'Coba ya',
        style: TextStyle(color: Colors.red[400], fontSize: 30),
      ),
    );
  }
}
