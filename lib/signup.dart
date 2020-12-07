import 'package:flutter/material.dart';
import 'login.dart';
import 'home_customer.dart';
import 'home_seller.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[200],
        body: DefaultTabController(
          length: 2,
          child: MaterialApp(
            home: Scaffold(
              appBar: new AppBar(
                leading: null,
                backgroundColor: Colors.lime[700],
                actions: <Widget>[
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0, 0, 380, 0),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  )
                ],
                bottom: TabBar(
                  onTap: (index) {},
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 20.0), //For Selected tab
                  unselectedLabelStyle:
                      TextStyle(fontSize: 18.0), //For Un-selected Tabs
                  tabs: [Tab(text: 'Pembeli'), Tab(text: 'Penjual')],
                ),
              ),
              body: TabBarView(
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nama Lengkap',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nomor Telepon',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ulangi Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          SizedBox(height: 50),
                          RaisedButton(
                            textColor: Colors.grey[100],
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            color: Colors.lime[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerHomePage()));
                            },
                            child: Container(
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nama Lengkap',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Nomor Telepon',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ulangi Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 50, 0),
                            alignment: Alignment.bottomLeft,
                            width: 350,
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  title: const Text('Menetap',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                  leading: Radio(value: 'Menetap'),
                                ),
                                ListTile(
                                  title: const Text('Keliling',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 16)),
                                  leading: Radio(value: 'Keliling'),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          RaisedButton(
                            textColor: Colors.grey[100],
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            color: Colors.lime[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerHomePage()));
                            },
                            child: Container(
                              child: Text('Sign Up',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
