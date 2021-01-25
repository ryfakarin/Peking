import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/screens/updateMenu.dart';
import 'package:hehe/screens/update_profile.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/widgets/provider.dart';

class sellerProfilePage extends StatefulWidget {
  @override
  _sellerProfilePageState createState() => _sellerProfilePageState();
}

class _sellerProfilePageState extends State<sellerProfilePage> {
  UserModel _user = UserModel("", "", "", null);

  _getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      _user.phoneNumber = result.data['phoneNumber'];
      _user.name = result.data['nama'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.lime[50],
      appBar: new AppBar(
        leading: null,
        toolbarHeight: _height * 0.07,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 28.0,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SellerHomePage()));
              }),
          Spacer(),
          FlatButton(
            child: AutoSizeText("Log Out",
                style: TextStyle(color: Colors.green, fontSize: 20.0)),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Log out dari akun anda?"),
                  actions: <Widget>[
                    FlatButton(
                      color: Colors.red[100],
                      child: Text(
                        "Kembali",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    FlatButton(
                      color: Colors.green[100],
                      child: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () async {
                        await Provider.of(context).auth.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          //color: Colors.pink[50],
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.18),
                FutureBuilder(
                  future: _getDocument(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AutoSizeText(_user.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold));
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(height: _height * 0.01),
                FutureBuilder(
                  future: _getDocument(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AutoSizeText(_user.phoneNumber,
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 18,
                              fontStyle: FontStyle.italic));
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(height: _height * 0.03),
                RaisedButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  color: Colors.brown[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateProfile()));
                  },
                  child: Container(
                    child: AutoSizeText('Ubah Profil',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: _height * 0.05),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 30, right: 10),
                      child: AutoSizeText('Menu',
                          style: TextStyle(
                              color: Colors.brown[800],
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    Spacer(),
                    RaisedButton(
                      textColor: Colors.black,
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      color: Colors.white60,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => updateMenuPage()));
                      },
                      child: Container(
                        child: AutoSizeText('Ubah Menu',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      width: _width * 0.05,
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  height: _height * 0.6,
                  width: _width,
                  child: StreamBuilder(
                    stream: getMenuStreamSnapshots(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildMenuCard(
                                  context, snapshot.data.documents[index]));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getMenuStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .snapshots();
  }

  Widget buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Text(document['namaMakanan']),
              Spacer(),
              Text('Rp. ' + document['hargaMakanan'])
            ],
          ),
        ),
      ),
    );
  }
}
