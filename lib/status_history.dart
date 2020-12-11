import 'package:flutter/material.dart';
import 'login.dart';
import 'home_customer.dart';
import 'home_seller.dart';

class StatusAndHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
      length: 2,
      child: MaterialApp(
        home: Scaffold(
          appBar: new AppBar(
            leading: null,
            toolbarHeight: 150,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 20, 25, 0),
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
                  padding: EdgeInsets.fromLTRB(0, 40, 110, 20),
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
                  onPressed: null),
              IconButton(
                  padding: EdgeInsets.fromLTRB(0, 40, 50, 20),
                  icon: Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  onPressed: null),
            ],
            bottom: TabBar(
              labelPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              onTap: (index) {},
              indicatorColor: Colors.green,
              labelColor: Colors.green,
              labelStyle: TextStyle(fontSize: 18.0), //For Selected tab
              unselectedLabelStyle: TextStyle(
                  fontSize: 16.0, color: Colors.green), //For Un-selected Tabs
              tabs: [
                Tab(text: 'Status Pemesanan'),
                Tab(text: 'Histori Pemesanan')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nama Lengkap',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nomor Telepon',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Kata Sandi',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ulangi Kata Sandi',
                              hintStyle: TextStyle(color: Colors.grey[400])),
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
                                  builder: (context) => CustomerHomePage()));
                        },
                        child: Container(
                          child: Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nama Lengkap',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Nomor Telepon',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Kata Sandi',
                              hintStyle: TextStyle(color: Colors.grey[400])),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.lightGreen))),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ulangi Kata Sandi',
                              hintStyle: TextStyle(color: Colors.grey[400])),
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
                                  fontSize: 20, fontWeight: FontWeight.bold)),
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
