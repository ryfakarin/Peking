import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hehe/screens/regSeller.dart';
import 'regCustomer.dart';

class chooseUserTypePage extends StatefulWidget {
  @override
  _chooseUserTypePageState createState() => _chooseUserTypePageState();
}

class _chooseUserTypePageState extends State<chooseUserTypePage> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      width: _width,
      height: _height,
      color: Colors.orange[100],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.3),
              AutoSizeText(
                "Daftar sebagai",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, color: Colors.green[900]),
              ),
              SizedBox(height: _height * 0.05),
              RaisedButton(
                color: Colors.orange[50],
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  "Pembeli",
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => regCustomerPage(0)));
                },
              ),
              SizedBox(height: _height * 0.025),
              RaisedButton(
                color: Colors.orange[50],
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  "Penjual",
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => regSellerPage()));
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
