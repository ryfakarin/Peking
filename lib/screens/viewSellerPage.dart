import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:hehe/screens/status_history_customer.dart';
import 'package:hehe/widgets/provider.dart';
import 'home_customer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
  int _tipeSeller;

  Panggilan _panggilan = Panggilan("", "", null);

  _viewSellerPageState({this.uidSeller});

  Set<Marker> _mapMarker = {};
  LatLng _currentPosition = LatLng(0, 0);
  GoogleMapController _mapController;

  void _mapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  _setMarker() async {
    await Provider.of(context)
        .db
        .collection('locData')
        .document(uidSeller)
        .get()
        .then((result) {
      setState(() {
        GeoPoint currPos = result.data['location'];
        _currentPosition = LatLng(currPos.latitude, currPos.longitude);
      });

      _mapMarker.add(
        Marker(
          markerId: MarkerId(_namaSeller),
          position: _currentPosition,
          infoWindow: InfoWindow(
            title: _namaSeller,
          ),
        ),
      );

      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 16.0)));
    });
  }

  _getUser() async {
    var data = await Firestore.instance
        .collection('userData')
        .document(uidSeller)
        .get();

    setState(() {
      _namaSeller = data.data['nama'];
      _tipeSeller = data.data['tipeUser'];
    });
  }

  _panggilSeller() async {
    final custId = await Provider.of(context).auth.getCurrentUID();
    _panggilan.custId = custId;

    _panggilan.statusPanggilan = 1;

    await Provider.of(context)
        .db
        .collection('panggilanData')
        .add(_panggilan.toJson());

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => StatusAndHistoryCust()));
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        height: _height,
        width: _width,
        child: Stack(
          children: <Widget>[
            Container(
              height: _height * 0.42,
              width: _width,
              color: Colors.yellow[700],
              child: Image.asset('assets/images/viewSeller.png'),
            ),
            Positioned(
              top: _height * 0.35,
              child: Container(
                height: _height * 0.7,
                width: _width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: FutureBuilder(
                  future: _getUser(),
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: _width * 0.02,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                size: 28.0,
                                color: Colors.yellow[800],
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerHomePage()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _height * 0.005,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: _width * 0.05,
                            ),
                            AutoSizeText(
                              _namaSeller,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                              maxLines: 1,
                            ),
                            Spacer(),
                            FlatButton(
                              onPressed: () async {
                                _panggilan.sellerId = uidSeller;
                                _panggilSeller();
                              },
                              child: AutoSizeText(
                                _tipeSeller == 1 ? 'Panggil' : 'Hampiri',
                                maxLines: 1,
                                style: TextStyle(color: Colors.white),
                              ),
                              color: _tipeSeller == 1
                                  ? Colors.green[800]
                                  : Colors.yellow[800],
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: _tipeSeller == 1
                                          ? Colors.green[800]
                                          : Colors.yellow[800],
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            SizedBox(
                              width: _width * 0.05,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: _height * 0.02,
                        ),
                        Container(
                          color: Colors.grey[200],
                          height: _height * 0.02,
                        ),
                        SizedBox(
                          height: _height * 0.04,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: _width * 0.08,
                            ),
                            AutoSizeText('Menu',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24)),
                            Spacer(),
                            Container(
                              color: Colors.pink,
                              width: 200,
                              height: 100,
                              child: FutureBuilder(
                                  future: _setMarker(),
                                  builder: (context, snapshot) {
                                    return GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                          target: _currentPosition, zoom: 16.0),
                                      mapType: MapType.normal,
                                      markers: _mapMarker,
                                      onMapCreated: _mapCreated,
                                      padding: EdgeInsets.only(
                                        top: 20.0,
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              width: _width * 0.08,
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          height: _height * 0.3,
                          width: _width,
                          child: StreamBuilder(
                            stream: getMenuStreamSnapshots(context),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          buildMenuCard(context,
                                              snapshot.data.documents[index]));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
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
            AutoSizeText(
              document['namaMakanan'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Spacer(),
            Text(
              'Rp. ' + document['hargaMakanan'],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
