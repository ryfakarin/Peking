import 'package:flutter/material.dart';
import 'profile_customer.dart';
import 'profile_seller.dart';

class UpdateProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.amber[50],
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
                // backnya masih ke seller, nanti divalidasi untuk ke seller
                // atau customer
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerProfilePage()));
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
                child: Stack(children: <Widget>[
                  new Positioned(
                    right: 0.0,
                    left: 0.0,
                    bottom: 0.0,
                    child: new Icon(
                      Icons.camera_alt,
                      size: 36.0,
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 280, 5),
                child: Text('Nama',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.lightGreen),
                  top: BorderSide(color: Colors.lightGreen),
                  left: BorderSide(color: Colors.lightGreen),
                  right: BorderSide(color: Colors.lightGreen),
                )),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nama Lengkap',
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 180, 5),
                child: Text('Nomor Telepon',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.lightGreen),
                  top: BorderSide(color: Colors.lightGreen),
                  left: BorderSide(color: Colors.lightGreen),
                  right: BorderSide(color: Colors.lightGreen),
                )),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nomor Telepon',
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 215, 5),
                child: Text('Kanta Sandi',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.lightGreen),
                  top: BorderSide(color: Colors.lightGreen),
                  left: BorderSide(color: Colors.lightGreen),
                  right: BorderSide(color: Colors.lightGreen),
                )),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Kata Sandi',
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 100, 5),
                child: Text('Konfirmasi Kata Sandi',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.lightGreen),
                  top: BorderSide(color: Colors.lightGreen),
                  left: BorderSide(color: Colors.lightGreen),
                  right: BorderSide(color: Colors.lightGreen),
                )),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Konfirmasi Kata Sandi',
                      hintStyle: TextStyle(color: Colors.grey[400])),
                ),
              ),
              SizedBox(height: 30),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                color: Colors.green[800],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                // validasi untuk nanti ke seller atau customer
                onPressed: () {},
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
