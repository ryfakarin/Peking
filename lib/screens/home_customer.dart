import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'package:hehe/screens/status_history_customer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hehe/model/panggilan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hehe/screens/viewSellerPage.dart';
import 'package:hehe/widgets/provider.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  Panggilan _panggilan = Panggilan("", "", null);
  Future resultsLoaded;

  final Set<Marker> _mapMarker = {};
  LatLng _currentPosition = LatLng(0, 0);
  Position _currentLocation;
  GoogleMapController _mapController;

  List<String> user = List<String>();
  List<String> userVal = List<String>();
  List<GeoPoint> userWithLoc = List<GeoPoint>();

  List<String> resultList = List();
  List<String> resultToList = List();
  Map<String, String> _searchResult = Map();
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    showResultList();
  }

  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getSearchResult();
  }

  Future<Position> _locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _getLocation() async {
    _currentLocation = await _locateUser();
    _currentPosition =
        LatLng(_currentLocation.latitude, _currentLocation.longitude);

    _setDocument();
  }

  getSearchResult() async {
    var data = await Firestore.instance.collection('dataJualan').getDocuments();
    int index = 0;

    data.documents.forEach((result) {
      String docId = result.documentID;
      String namaSeller = data.documents[index].data['nama'];
      _searchResult.addAll({docId: namaSeller});
      resultToList.add(namaSeller);
      index++;
    });

    showResultList();

    return "complete";
  }

  showResultList() {
    List<String> showResult = [];

    if (_searchController.text != "") {
      for (String seller in resultToList) {
        if (seller.toLowerCase().contains(_searchController.text)) {
          showResult.add(seller);
        }
      }
    }

    setState(() {
      resultList = showResult;
    });
  }

  void _mapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  navigateMap(LatLng latLng) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 16.0)));
  }

  _setDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Firestore.instance.collection('locData').document(uid).setData({
      'location':
          GeoPoint(_currentPosition.latitude, _currentPosition.longitude)
    });
  }

  _setData() async {
    final custId = await Provider.of(context).auth.getCurrentUID();
    _panggilan.custId = custId;

    _panggilan.statusPanggilan = 1;

    await Provider.of(context)
        .db
        .collection('panggilanData')
        .add(_panggilan.toJson());
  }

  _setMarker() async {
    _getLocation();

    QuerySnapshot snap = await Firestore.instance
        .collection('userData')
        .where('tipeUser', isGreaterThan: 0)
        .getDocuments();

    for (int i = 0; i < snap.documents.length; i++) {
      user.add(snap.documents[i].documentID);
    }

    QuerySnapshot snaps =
        await Firestore.instance.collection('locData').getDocuments();

    for (int i = 0; i < snaps.documents.length; i++) {
      if (user.contains(snaps.documents[i].documentID)) {
        userWithLoc.add(snaps.documents[i].data['location']);
        _mapMarker.add(Marker(
          markerId: MarkerId(snaps.documents[i].documentID),
          position: LatLng(userWithLoc[i].latitude, userWithLoc[i].longitude),
        ));
      }
    }
  }

  getLocationfromDB(String sellerUid) async {
    await Provider.of(context)
        .db
        .collection('locData')
        .document(sellerUid)
        .get()
        .then((result) {
      setState(() {
        GeoPoint currPos = result.data['location'];
        _currentPosition =
            LatLng(currPos.latitude, currPos.longitude);
      });

      navigateMap(_currentPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        leading: null,
        toolbarHeight: _height * 0.1,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, _width * 0.03, 0),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/logo.PNG'))),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, _height * 0.04, _width * 0.3, 0),
              child: Text('Peking',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold))),
          IconButton(
              icon: Icon(
                Icons.history,
                size: 28.0,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatusAndHistoryCust()));
              }),
          IconButton(
              padding: EdgeInsets.fromLTRB(0, 0, _width * 0.1, 0),
              icon: Icon(
                Icons.account_circle,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => customerProfilePage()));
              }),
        ],
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Cari pedagang..",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.lightGreen,
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: _height * 0.02),
              Stack(
                children: <Widget>[
                  FutureBuilder(
                    future: _setMarker(),
                    builder: (context, doc) {
                      return Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: _height * 0.4,
                        color: Colors.lightGreen,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _currentPosition, zoom: 16.0),
                          mapType: MapType.normal,
                          markers: _mapMarker,
                          myLocationEnabled: true,
                          onMapCreated: _mapCreated,
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Container(
                      height: _height * 0.2,
                      width: _width * 0.8,
                      child: ListView.builder(
                        itemCount: resultList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.grey[600],
                            child: InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    AutoSizeText(
                                      resultList[index],
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                String key = _searchResult.keys.firstWhere(
                                    (k) =>
                                        _searchResult[k] == resultList[index],
                                    orElse: () => null);
                                getLocationfromDB(key);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.02),
              Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                height: _height * 0.3,
                width: _width,
                child: StreamBuilder(
                  stream: _getSellerStreamSnapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) =>
                            _buildSellerCard(
                                context, snapshot.data.documents[index]));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getSellerStreamSnapshots() async* {
    var offset = 0.0000089982311916 * 300;
    var latMax = _currentPosition.latitude + offset;
    var latMin = _currentPosition.latitude - offset;

    var lngOffset = offset * cos(_currentPosition.latitude * pi / 180.0);
    var lngMax = _currentPosition.longitude + lngOffset;
    var lngMin = _currentPosition.longitude - lngOffset;

    var greaterGeopoint = GeoPoint(latMax, lngMax);
    var lesserGeopoint = GeoPoint(latMin, lngMin);

    QuerySnapshot query = await Firestore.instance
        .collection('locData')
        .where('location', isLessThan: greaterGeopoint)
        .where('location', isGreaterThan: lesserGeopoint)
        .getDocuments();

    yield* Firestore.instance.collection('dataJualan').snapshots();
  }

  Widget _buildSellerCard(BuildContext context, DocumentSnapshot document) {
    //if(userVal.contains(document.documentID))
    return new SingleChildScrollView(
      child: InkWell(
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    AutoSizeText(
                      document['nama'],
                      maxLines: 1,
                      style: TextStyle(fontSize: 14),
                    ),
                    Spacer(),
                    //IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                    document['tipe'] == 1
                        ? FlatButton(
                            child: AutoSizeText(
                              "Panggil",
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.green[800]),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      "Panggil " + document['nama'] + " ?"),
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
                                        _panggilan.sellerId =
                                            document.documentID;
                                        _setData();
                                        _setDocument();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StatusAndHistoryCust()));
                                      },
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : FlatButton(onPressed: null)
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      viewSellerPage(uidSeller: document.documentID)));
        },
      ),
    );
  }
}
