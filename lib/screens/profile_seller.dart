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
  UserModel user = UserModel("", "", "", null);
  String docId;

  getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    var doc_ref = await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .getDocuments();
    doc_ref.documents.forEach((result) {
      docId = result.documentID;
    });

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .document(docId)
        .get()
        .then((result) {
      user.phoneNumber = result.data['phoneNumber'];
      user.name = result.data['nama'];
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SellerHomePage()));
                }),
            Spacer(),
            FlatButton(
                child: AutoSizeText("Log Out",
                    style: TextStyle(color: Colors.green, fontSize: 20.0)),
                onPressed: () async {
                  await Provider.of(context).auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
          ]),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          // color: Colors.pink[50],
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Container(
                  height: _height * 0.2,
                  width: _width * 0.6,
                  margin: EdgeInsets.fromLTRB(105, 0, 105, 0),
                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/images/cony.png'))),
                ),
                SizedBox(height: _height * 0.02),
                FutureBuilder(
                  future: getDocument(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AutoSizeText(user.name,
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
                  future: getDocument(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AutoSizeText(user.phoneNumber,
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
                      child: AutoSizeText('Foto',
                          style: TextStyle(
                              color: Colors.brown[800],
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold)),
                    ),
                    RaisedButton(
                      textColor: Colors.black,
                      padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                      color: Colors.white60,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 2),
                          borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () {},
                      child: Container(
                        child: AutoSizeText('Ubah Foto',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: _height * 0.05),
                    AutoSizeText('Tidak ada foto yang tersedia'),
                  ],
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
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  height: _height * 0.4,
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
    yield* Firestore.instance.collection('dataJualan').document(uid).collection('menus').snapshots();
  }

  Widget buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Text(document['namaMakanan']),
                Spacer(),
                Text(document['hargaMakanan']),
                Spacer(),
                Text(document['satuan'].toString()),
                Spacer(),
                Text(document['satuanMakanan']),
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

}
