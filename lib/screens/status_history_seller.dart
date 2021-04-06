import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'home_seller_menetap.dart';

class statusAndHistorySeller extends StatefulWidget {
  @override
  _statusAndHistorySellerState createState() => _statusAndHistorySellerState();
}

class _statusAndHistorySellerState extends State<statusAndHistorySeller> {
  Future locationGetter;
  String docId;
  String docIdLoc;
  UserLocation _userLocation = UserLocation(null, null);

  GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);
  final Set<Marker> _mapMarker = {};

  UserModel _user = UserModel("", "", "", null);
  Panggilan _panggilan = Panggilan("", "", null);

  @override
  initState() {
    super.initState();
    locationGetter = _getLocation(docId);
  }

  _getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      setState(() {
        _user.phoneNumber = result.data['phoneNumber'];
        _user.name = result.data['nama'];
        _user.uid = uid;
        _user.tipeUser = result.data['tipeUser'];
      });
    });
  }

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
          FutureBuilder(
            future: _getDocument(),
            builder: (context, snapshot) {
              return IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, _width * 0.01, 0),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.yellow[800],
                ),
                onPressed: () {
                  _user.tipeUser == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerHomePage()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerStayHomePage()));
                },
              );
            },
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.fromLTRB(0, 0, _width * 0.12, 0),
            icon: Icon(
              Icons.account_circle,
              size: 30.0,
              color: Colors.yellow[800],
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => sellerProfilePage()));
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
                      _user.tipeUser == 1
                          ? 'Daftar Pemanggilan'
                          : 'Daftar Penghampiran',
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(
                  height: _height * 0.02,
                ),
                SingleChildScrollView(
                  child: Container(
                    height: _height * 0.7,
                    width: _width,
                    child: StreamBuilder(
                      stream: _getPanggilanStreamSnapshots(context),
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

  Stream<QuerySnapshot> _getPanggilanStreamSnapshots(
      BuildContext context) async* {
    final String uid = await Provider.of(context).auth.getCurrentUID();
    yield* Provider.of(context)
        .db
        .collection('panggilanData')
        .where('sellerId', isEqualTo: uid)
        .orderBy('statusPanggilan')
        .snapshots();
  }

  _getLocation(String docId) async {
    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _userLocation.sellerLocation =
          GeoPoint(currPos.latitude, currPos.longitude);
    });

    await _getLocationData(docId);
  }

  _getLocationData(String docId) async {
    await Firestore.instance
        .collection('panggilanData')
        .document(docId)
        .collection('userLocation')
        .getDocuments()
        .then(
          (value) => setState(
            () {
              docIdLoc = value.documents.first.documentID;
              print(value.documents.first.documentID);
              _userLocation.custLocation =
                  value.documents.first.data['custLocation'];
              _mapMarker.add(
                Marker(
                  markerId: MarkerId(docId),
                  position: LatLng(_userLocation.custLocation.latitude,
                      _userLocation.custLocation.longitude),
                  infoWindow: InfoWindow(
                    title: docId,
                  ),
                ),
              );
              _mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(_userLocation.custLocation.latitude,
                          _userLocation.custLocation.longitude),
                      zoom: 16.0)));
            },
          ),
        );
  }

  _setData(String docId, Map<String, dynamic> json) async {
    await Provider.of(context)
        .db
        .collection('panggilanData')
        .document(docId)
        .setData(json);
  }

  void toBeSendtoDb(
      DocumentSnapshot document, int status, bool updateLocation) {
    String docId = document.documentID;
    _panggilan.custId = document['custId'];
    _panggilan.sellerId = document['sellerId'];
    _panggilan.statusPanggilan = status;
    _setData(docId, _panggilan.toJson());

    if (updateLocation == true) {
      Provider.of(context)
          .db
          .collection('panggilanData')
          .document(docId)
          .collection('userLocation')
          .document(docIdLoc)
          .setData(_userLocation.toJson());
    }
  }

  _buildStatusCards(BuildContext context, DocumentSnapshot document) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Firestore.instance
              .collection('userData')
              .document(document['custId'])
              .get(),
          builder: (context, sn) {
            if (!sn.hasData)
              return Row(children: <Widget>[
                Spacer(),
                AutoSizeText('Tidak ada data yang tersedia'),
                Spacer(),
              ]);
            return ExpansionTile(
              title: Row(
                children: <Widget>[
                  Container(
                    width: 170,
                    child: AutoSizeText(
                      sn.data['nama'],
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Spacer(),
                  document.data['statusPanggilan'] != 4 &&
                          document.data['statusPanggilan'] != 6
                      ? AutoSizeText('Proses',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w400))
                      : AutoSizeText('Selesai',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400))
                ],
              ),
              children: <Widget>[
                _buildRow1(sn, document),
                _buildTolakPanggilan(sn, document),
                _buildSellerBerangkat(sn, document),
                _buildSellerPerjalanan(sn, document),
                _buildPanggilanSelesai(document)
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow1(AsyncSnapshot sn, DocumentSnapshot document) {
    return ExpansionTile(
      title: AutoSizeText(
        _user.tipeUser == 1
            ? 'Konfirmasi pemanggilan'
            : 'Konfirmasi penghampiran',
        maxLines: 1,
        style: TextStyle(fontSize: 14),
      ),
      children: <Widget>[
        document['statusPanggilan'] == 1
            ? FutureBuilder(
                future: _getLocation(document.documentID),
                builder: (context, doc) {
                  return Container(
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
                  );
                },
              )
            : Icon(
                Icons.check,
                color: Colors.green,
              ),
        SizedBox(height: 10),
        document['statusPanggilan'] == 1
            ? _buildButtonTerimaPanggilan(sn, document)
            : Padding(padding: EdgeInsets.zero),
      ],
    );
  }

  Row _buildButtonTerimaPanggilan(AsyncSnapshot sn, DocumentSnapshot document) {
    return Row(
      children: <Widget>[
        Spacer(),
        FlatButton(
          color: Colors.green[100],
          onPressed: () {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text(_user.tipeUser == 1
                    ? "Terima panggilan ini ?"
                    : "Menerima pembeli?"),
                actions: [
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Terima"),
                    onPressed: () {
                      toBeSendtoDb(document, 2, true);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => this.build(context)));
                    },
                  ),
                ],
              ),
            );
          },
          child: AutoSizeText(
            _user.tipeUser == 1 ? 'Terima Panggilan' : 'Terima Penghampiran',
            maxLines: 1,
            style: TextStyle(fontSize: 12),
          ),
        ),
        Spacer(),
        FlatButton(
          color: Colors.red[100],
          onPressed: () {
            showDialog(
              context: context,
              child: AlertDialog(
                title: Text(_user.tipeUser == 1
                    ? "Tolak panggilan ini?"
                    : "Tolak pembeli?"),
                actions: [
                  FlatButton(
                    child: Text("Kembali"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Tolak"),
                    onPressed: () {
                      toBeSendtoDb(document, 6, false);
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => statusAndHistorySeller()));
                    },
                  ),
                ],
              ),
            );
          },
          child: AutoSizeText(
            _user.tipeUser == 1 ? 'Tolak Panggilan' : 'Tolak Penghampiran',
            maxLines: 1,
            style: TextStyle(fontSize: 12),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _buildTolakPanggilan(AsyncSnapshot sn, DocumentSnapshot document) {
    return document['statusPanggilan'] != 6
        ? Card(
            child: Container(
              color: Colors.red[50],
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  AutoSizeText(
                    _user.tipeUser == 1
                        ? 'Anda menolak pemanggilan ini'
                        : 'Anda menolak penghampiri pembeli ini',
                    maxLines: 1,
                    style: TextStyle(fontSize: 14),
                  )
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.zero,
          );
  }

  Widget _buildSellerBerangkat(AsyncSnapshot sn, DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 && document['statusPanggilan'] != 6
        ? _user.tipeUser == 1
            ? ExpansionTile(
                title: AutoSizeText(
                  'Konfirmasi pemesanan',
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
                children: <Widget>[
                  document['statusPanggilan'] == 2
                      ? Column(
                          children: <Widget>[
                            FutureBuilder(
                                future: _getLocation(document.documentID),
                                builder: (context, doc) {
                                  return FlatButton(
                                      onPressed: () {
                                        toBeSendtoDb(document, 3, true);
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
                                      ));
                                })
                          ],
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
            : Card(
                child: Container(
                  color: Colors.lightGreen[50],
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: <Widget>[
                      AutoSizeText(
                        _user.tipeUser == 1
                            ? 'Anda menerima panggilan ini'
                            : 'Menunggu pembeli berangkat',
                        maxLines: 1,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget _buildSellerPerjalanan(AsyncSnapshot sn, DocumentSnapshot document) {
    return document['statusPanggilan'] != 1 &&
            document['statusPanggilan'] != 2 &&
            document['statusPanggilan'] != 6
        ? _user.tipeUser == 1
            ? ExpansionTile(
                title: AutoSizeText(
                  'Penjual dalam perjalanan',
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
                children: <Widget>[
                  FutureBuilder(
                    future: _getLocation(document.documentID),
                    builder: (context, doc) {
                      return Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 350,
                        color: Colors.lightGreen,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _currentPosition, zoom: 14.0),
                          mapType: MapType.normal,
                          markers: _mapMarker,
                          myLocationEnabled: true,
                          onMapCreated: _mapCreated,
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  document['statusPanggilan'] == 3
                      ? FlatButton(
                          onPressed: () {
                            toBeSendtoDb(document, 4, true);
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
            : ExpansionTile(
                title: AutoSizeText(
                  'Pembeli dalam perjalanan',
                  maxLines: 1,
                  style: TextStyle(fontSize: 14),
                ),
                children: <Widget>[
                  document['statusPanggilan'] == 4
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : FutureBuilder(
                          future: _getLocation(document.documentID),
                          builder: (context, doc) {
                            return Container(
                              margin: EdgeInsets.only(left: 20, right: 20),
                              height: 350,
                              color: Colors.lightGreen,
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    target: _currentPosition, zoom: 14.0),
                                mapType: MapType.normal,
                                markers: _mapMarker,
                                myLocationEnabled: true,
                                onMapCreated: _mapCreated,
                              ),
                            );
                          },
                        ),
                ],
              )
        : Padding(padding: EdgeInsets.zero);
  }

  Widget _buildPanggilanSelesai(DocumentSnapshot document) {
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
}
