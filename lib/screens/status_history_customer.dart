import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hehe/widgets/provider.dart';

class StatusAndHistoryCust extends StatefulWidget {
  @override
  _StatusAndHistoryCustState createState() => _StatusAndHistoryCustState();
}

class _StatusAndHistoryCustState extends State<StatusAndHistoryCust> {
  String cardTitle = '';

  GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);
  final Set<Marker> _mapMarker = {};

  void mapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: new AppBar(
        leading: null,
        toolbarHeight: _height * 0.1,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, _width * 0.01, 0),
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, _width * 0.03, 0),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.PNG'))),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, _height * 0.035, _width * 0.2, 0),
              child: Text('Peking',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold))),
          IconButton(
              icon: Icon(
                Icons.history,
                size: 28.0,
                color: Colors.green,
              ),
              onPressed: null),
          IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, _width * 0.12, 0),
              icon: Icon(
                Icons.account_circle,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: null),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: 20, bottom: 20)),
                    AutoSizeText(
                      'Histori Pemanggilan',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Container(
                  height: _height * 0.75,
                  width: _width,
                  // color: Colors.purple,
                  child: StreamBuilder(
                      stream: getPanggilanStreamSnapshots(context),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Row(children: <Widget>[
                            Spacer(),
                            AutoSizeText('Tidak ada data yang tersedia'),
                            Spacer(),
                          ]);
                        return ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildStatusCards(
                                    context, snapshot.data.documents[index]));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getPanggilanStreamSnapshots(
      BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('panggilanData').where('custId', isEqualTo:uid).snapshots();
  }

  getUserSnapshots(String userId) async {
    await Firestore.instance
        .collection('userData')
        .document(userId)
        .get()
        .then((value) => cardTitle = value.data['nama']);
  }

  Widget buildStatusCards(BuildContext context, DocumentSnapshot document) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getUserSnapshots(document['sellerId']),
            builder: (context, snapshot) {
              return ExpansionTile(
                title: AutoSizeText(
                  cardTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                children: <Widget>[
                  buildCard1(document),
                  buildTolakPanggilan(document),
                  buildTerimaPanggilan(document),
                  buildPenjualTravel(document),
                  buildPanggilanSelesai(document),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildPanggilanSelesai(DocumentSnapshot document) {
    return document['statusPanggilan'] == 4
        ? Card(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  AutoSizeText(
                    "Pemanggilan telah selesai",
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  ),
                  Spacer(),
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget buildPenjualTravel(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 &&
            document['statusPanggilan'] != 6 &&
            document['statusPanggilan'] != 2
        ? ExpansionTile(
            title: AutoSizeText(
              'Penjual dalam perjalanan',
              maxLines: 1,
              style: TextStyle(fontSize: 14),
            ),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                height: 350,
                color: Colors.lightGreen,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: _currentPosition, zoom: 14.0),
                  mapType: MapType.normal,
                  markers: _mapMarker,
                  myLocationEnabled: true,
                  onMapCreated: mapCreated,
                ),
              ),
            ],
          )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget buildTerimaPanggilan(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 && document['statusPanggilan'] != 6
        ? Card(
            child: Container(
              color: Colors.green[50],
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  AutoSizeText(
                    'Penjual menerima panggilan anda',
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget buildTolakPanggilan(DocumentSnapshot document) {
    return document['statusPanggilan'] != 6
        ? Padding(
            padding: EdgeInsets.zero,
          )
        : Card(
            child: Container(
              color: Colors.red[50],
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  AutoSizeText(
                    'Penjual menolak pemanggilan anda',
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          );
  }

  Card buildCard1(DocumentSnapshot document) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            AutoSizeText(
              'Menunggu Konfirmasi Pemanggilan',
              maxLines: 1,
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            document['statusPanggilan'] == 1
                ? AutoSizeText("")
                : Icon(
                    Icons.check,
                    color: Colors.green,
                  )
          ],
        ),
      ),
    );
  }
}