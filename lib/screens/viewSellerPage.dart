import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:hehe/screens/status_history_customer.dart';
import 'package:hehe/widgets/provider.dart';
import 'home_customer.dart';

class viewSellerPage extends StatefulWidget {
  final String uidSeller;

  viewSellerPage({Key key, this.uidSeller}) : super(key: key);

  @override
  _viewSellerPageState createState() =>
      _viewSellerPageState(uidSeller: uidSeller);
}

class _viewSellerPageState extends State<viewSellerPage> {
  String uidSeller;
  String _namaSeller = "";

  Panggilan _panggilan = Panggilan("", "", null);

  _viewSellerPageState({this.uidSeller});

  _getUser() async {
    var data = await Firestore.instance
        .collection('userData')
        .document(uidSeller)
        .get();

    setState(() {
      _namaSeller = data.data['nama'];
    });
  }

  _panggilSeller() async {
    final custId = await Provider
        .of(context)
        .auth
        .getCurrentUID();
    _panggilan.custId = custId;

    _panggilan.statusPanggilan = 1;

    await Provider
        .of(context)
        .db
        .collection('panggilanData')
        .add(_panggilan.toJson());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StatusAndHistoryCust()));
  }

  Stream<QuerySnapshot> getMenuStreamSnapshots(BuildContext context) async* {
    yield* Firestore.instance
        .collection('dataJualan')
        .document(uidSeller)
        .collection('menus')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery
        .of(context)
        .size
        .width;
    final _height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        leading: null,
        toolbarHeight: _height * 0.1,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            // padding: EdgeInsets.only(right: _width * 0.05),
              icon: Icon(
                Icons.arrow_back,
                size: 28.0,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerHomePage()));
              }),
          Spacer(),
        ],
      ),
      body: Container(
        // color: Colors.pink[200],
        height: _height * 0.8,
        width: _width,
        padding: EdgeInsets.all(_width * 0.1),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: _getUser(),
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      AutoSizeText(
                        _namaSeller,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: _height * 0.05,
                      ),
                      Row(
                        children: <Widget>[
                          AutoSizeText('Menu',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: _height * 0.02,
                      ),
                      Row(
                        children: <Widget>[
                          Text('Nama Makanan', style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                          Text('Harga Makanan', style: TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        height: _height * 0.3,
                        width: _width,
                        child: StreamBuilder(
                          stream: getMenuStreamSnapshots(context),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                return buildMenuCard(context,
                                      snapshot.data.documents[index]);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(
                height: _height * 0.05,
              ),
              FlatButton(
                onPressed: () async {
                  _panggilan.sellerId = uidSeller;
                  _panggilSeller();
                },
                child: Text('Panggil'),
                color: Colors.green[200],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
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
    );
  }
}
