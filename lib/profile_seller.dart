import 'package:flutter/material.dart';
import 'package:hehe/update_profile.dart';
import 'home_seller.dart';

class SellerProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.lime[50],
      appBar: new AppBar(
          leading: null,
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 20, 380, 20),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerHomePage()));
                }),
          ]),
      body: Container(
        height: 800,
        // color: Colors.pink[50],
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            children: <Widget>[
              Container(
                height: 220,
                width: 220,
                margin: EdgeInsets.fromLTRB(105, 0, 105, 0),
                padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/images/cony.png'))),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text('Cony',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Text('+6282537957720',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontStyle: FontStyle.italic)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 250, 0),
                child: Text('Favorites',
                    style: TextStyle(
                        color: Colors.brown[800],
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 30),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                color: Colors.brown[300],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpdateProfile()));
                },
                child: Container(
                  child: Text('Ubah Profil',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
