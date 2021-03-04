import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'package:hehe/widgets/provider.dart';

class StatusAndHistoryCust extends StatefulWidget {
  @override
  _StatusAndHistoryCustState createState() => _StatusAndHistoryCustState();
}

class _StatusAndHistoryCustState extends State<StatusAndHistoryCust> {
  DateTime nowTime = DateTime.now();

  GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);
  final Set<Marker> _mapMarker = {};

  UserModel _seller = UserModel("", "", "", null);
  Panggilan _panggilan = Panggilan("", "", null);

  _mapCreated(controller) {
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
          SizedBox(
            width: _width * 0.03,
          ),
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, _width * 0.01, 0),
            icon: Icon(
              Icons.arrow_back,
              size: 28.0,
              color: Colors.yellow[700],
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerHomePage()));
            },
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, _width * 0.12, 0),
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
              color: Colors.yellow[700],
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => customerProfilePage()));
            },
          ),
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
                      'Histori Pesanan',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Container(
                    height: _height * 0.75,
                    width: _width,
                    // color: Colors.purple,
                    child: StreamBuilder(
                      stream: _getCurrPanggilanStreamSnapshots(context),
                      builder: (context, sn) {
                        if (!sn.hasData)
                          return Row(children: <Widget>[
                            Spacer(),
                            AutoSizeText('Tidak ada data yang tersedia'),
                            Spacer(),
                          ]);
                        return ListView.builder(
                            itemCount: sn.data.documents.length,
                            itemBuilder: (BuildContext context, int index) =>
                                _buildStatusCards(
                                    context, sn.data.documents[index]));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getCurrPanggilanStreamSnapshots(
      BuildContext context) async* {
    final String uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('panggilanData')
        .where('custId', isEqualTo: uid)
        .orderBy('statusPanggilan')
        .snapshots();
  }

  _getSeller(DocumentSnapshot document) async {

    await Provider.of(context)
        .db
        .collection('userData')
        .document(document['sellerId'])
        .get()
        .then((result) {
      _seller.phoneNumber = result.data['phoneNumber'];
      _seller.name = result.data['nama'];
      _seller.uid = document['sellerId'];
      _seller.tipeUser = result.data['tipeUser'];
    });
  }

  _setData(String docId, Map<String, dynamic> json) async {
    await Provider.of(context)
        .db
        .collection('panggilanData')
        .document(docId)
        .setData(json);
  }

  _setTime(String docId, int status) async {
    String ts = Timestamp.now().toString();
    await Provider.of(context)
        .db
        .collection('panggilanData')
        .document(docId)
        .setData({status: ts});
  }

  void toBeSendtoDb(DocumentSnapshot document, int status) {
    String docId = document.documentID;
    _panggilan.custId = document['custId'];
    _panggilan.sellerId = document['sellerId'];
    _panggilan.statusPanggilan = status;
    _setData(docId, _panggilan.toJson());
    _setTime(docId, status);
  }

  Widget _buildStatusCards(BuildContext context, DocumentSnapshot document) {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: FutureBuilder(
                future: Firestore.instance
                    .collection('dataJualan')
                    .document(document.data['sellerId'])
                    .get(),
                builder: (context, sn) {
                  if (!sn.hasData)
                    return Row(children: <Widget>[
                      Spacer(),
                      AutoSizeText('Tidak ada data yang tersedia'),
                      Spacer(),
                    ]);
                  return Container(
                    width: 200,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 170,
                          child: AutoSizeText(
                            sn.data['nama'],
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        document.data['statusPanggilan'] != 4 &&
                                document.data['statusPanggilan'] != 6
                            ? AutoSizeText('Proses',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.green[800], fontWeight: FontWeight.w400))
                            : AutoSizeText('Selesai',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[700], fontWeight: FontWeight.w400))
                        // Container(
                        //   child: AutoSizeText(
                        //     DateTime.now().toString().substring(10, 16),
                        //     maxLines: 1,
                        //     style: TextStyle(fontSize: 14, color: Colors.green[800]),
                        //   ),
                        // ),
                      ],
                    ),
                  );
                }),
            children: <Widget>[
              _buildCard1(document),
              _buildTolakPanggilan(document),
              _buildTerimaPanggilan(document),
              _buildCustBerangkat(document),
              _buildPenjualTravel(document),
              _buildPanggilanSelesai(document),
            ],
          ),
        ),
      ),
    );
  }

  Card _buildCard1(DocumentSnapshot document) {
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

  Widget _buildTerimaPanggilan(DocumentSnapshot document) {
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

  Widget _buildTolakPanggilan(DocumentSnapshot document) {
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

  Widget _buildCustBerangkat(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 && document['statusPanggilan'] != 6
        ? FutureBuilder(
            future: _getSeller(document),
            builder: (context, snapshot) {
              if (_seller.tipeUser == 2) {
                return ExpansionTile(
                  title: AutoSizeText(
                    'Pembeli akan berangkat',
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  ),
                  children: <Widget>[
                    document['statusPanggilan'] == 2
                        ? FlatButton(
                            onPressed: () {
                              toBeSendtoDb(document, 3);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          this.build(context)));
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
                );
              } else {
                return Padding(padding: EdgeInsets.zero);
              }
            },
          )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget _buildPenjualTravel(DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 &&
            document['statusPanggilan'] != 6 &&
            document['statusPanggilan'] != 2
        ? ExpansionTile(
            title: AutoSizeText(
              _seller.tipeUser == 1
                  ? 'Penjual dalam perjalanan'
                  : 'Anda dalam perjalanan',
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
                  onMapCreated: _mapCreated,
                ),
              ),
              _seller.tipeUser == 2 || document['statusPanggilan'] == 3
                  ? FlatButton(
                      onPressed: () {
                        toBeSendtoDb(document, 4);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => this.build(context)));
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

  Widget _buildPanggilanSelesai(DocumentSnapshot document) {
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
}
