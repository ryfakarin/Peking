import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/widgets/provider.dart';

class statusAndHistorySeller extends StatefulWidget {
  @override
  _statusAndHistorySellerState createState() => _statusAndHistorySellerState();
}

class _statusAndHistorySellerState extends State<statusAndHistorySeller> {
  String cardTitle = '';

  GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);
  final Set<Marker> _mapMarker = {};

  Panggilan panggilan = Panggilan("", "", null);

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SellerHomePage()));
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
    yield* Firestore.instance
        .collection('panggilanData')
        .where('sellerId', isEqualTo: uid)
        .snapshots();
  }

  void setData(String docId, Map<String, dynamic> json) async {
    await Provider.of(context)
        .db
        .collection('panggilanData')
        .document(docId)
        .setData(json);
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
            future: getUserSnapshots(document['custId']),
            builder: (context, snapshot) {
              return ExpansionTile(
                title: AutoSizeText(
                  cardTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                children: <Widget>[
                  buildRow1(document),
                  buildTolakPanggilan(document),
                  buildSellerBerangkat(document),
                  buildSellerPerjalanan(document),
                  buildPanggilanSelesai(document)
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
            color: Colors.green[50],
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

  Widget buildSellerPerjalanan(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 &&
            document['statusPanggilan'] != 2 &&
            document['statusPanggilan'] != 6
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
              SizedBox(
                height: 5,
              ),
              document['statusPanggilan'] == 3
                  ? FlatButton(
                      onPressed: () {
                        toBeSendtoDb(document, 4);
                      },
                      color: Colors.green[100],
                      child: AutoSizeText(
                        'Saya sudah sampai',
                        maxLines: 1,
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : Padding(padding: EdgeInsets.zero),
            ],
          )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget buildSellerBerangkat(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 && document['statusPanggilan'] != 6
        ? ExpansionTile(
            title: AutoSizeText(
              'Konfirmasi pemesanan',
              maxLines: 1,
              style: TextStyle(fontSize: 14),
            ),
            children: <Widget>[
              document['statusPanggilan'] == 2
                  ? FlatButton(
                      onPressed: () {
                        toBeSendtoDb(document, 3);
                      },
                      color: Colors.green[100],
                      child: AutoSizeText(
                        'Saya berangkat',
                        maxLines: 1,
                        style: TextStyle(fontSize: 14),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
            ],
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
                    'Anda menolak pemanggilan ini',
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          );
  }

  ExpansionTile buildRow1(DocumentSnapshot document) {
    return ExpansionTile(
      title: AutoSizeText(
        'Konfirmasi pemanggilan',
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
        SizedBox(height: 10),
        document['statusPanggilan'] == 1
            ? buildButtonTerimaPanggilan(document)
            : Padding(padding: EdgeInsets.zero),
      ],
    );
  }

  Row buildButtonTerimaPanggilan(DocumentSnapshot document) {
    return Row(
      children: <Widget>[
        Spacer(),
        FlatButton(
          color: Colors.green[100],
          onPressed: () {
            toBeSendtoDb(document, 2);
          },
          child: AutoSizeText(
            'Terima Panggilan',
            maxLines: 1,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Spacer(),
        FlatButton(
          color: Colors.red[100],
          onPressed: () {
            toBeSendtoDb(document, 6);
          },
          child: AutoSizeText(
            'Tolak Panggilan',
            maxLines: 1,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Spacer(),
      ],
    );
  }

  void toBeSendtoDb(DocumentSnapshot document, int status) {
    String docId = document.documentID;
    panggilan.custId = document['custId'];
    panggilan.sellerId = document['sellerId'];
    panggilan.statusPanggilan = status;
    setData(docId, panggilan.toJson());
  }
}
