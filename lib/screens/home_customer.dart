import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool isExpanded = false;

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
    setState(() {
      isExpanded = !isExpanded;
    });
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
    final uidDoc = await FirebaseAuth.instance.currentUser();
    String uid = uidDoc.uid;

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
        DocumentSnapshot snapshot = await Firestore.instance
            .collection('dataJualan')
            .document(snaps.documents[i].documentID)
            .get();
        userWithLoc.add(snaps.documents[i].data['location']);
        _mapMarker.add(
          Marker(
            markerId: MarkerId(snaps.documents[i].documentID),
            position: LatLng(userWithLoc[i].latitude, userWithLoc[i].longitude),
            infoWindow: InfoWindow(
              title: snapshot.data['nama'],
            ),
            // onTap: () {
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               viewSellerPage(uidSeller: snaps.documents[i].documentID)));
            // }
          ),
        );
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
        _currentPosition = LatLng(currPos.latitude, currPos.longitude);
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: _width,
                height: _height * 0.53,
                child: Stack(
                  children: <Widget>[
                    FutureBuilder(
                      future: _setMarker(),
                      builder: (context, doc) {
                        return Container(
                          width: _width,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: _currentPosition, zoom: 16.0),
                            mapType: MapType.normal,
                            markers: _mapMarker,
                            myLocationEnabled: true,
                            onMapCreated: _mapCreated,
                            padding: EdgeInsets.only(
                              top: 20.0,
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: _height * 0.06,
                      right: _width * 0.14,
                      child: RawMaterialButton(
                        child: Icon(
                          Icons.history,
                          size: 30.0,
                          color: Colors.yellow[600],
                        ),
                        padding: EdgeInsets.all(3.0),
                        shape: CircleBorder(),
                        fillColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StatusAndHistoryCust()));
                        },
                      ),
                    ),
                    Positioned(
                      top: _height * 0.06,
                      right: 0,
                      child: RawMaterialButton(
                        child: Icon(
                          Icons.account_circle,
                          size: 30.0,
                          color: Colors.yellow[600],
                        ),
                        padding: EdgeInsets.all(3.0),
                        shape: CircleBorder(),
                        fillColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => customerProfilePage()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: _width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: _height * 0.03,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: _width * 0.08,
                        ),
                        AutoSizeText(
                          'Cari Pedagang',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(
                      height: _height * 0.015,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: _width * 0.05, right: _width * 0.05),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30.0),
                            ),
                          ),
                          hintText: "Cari nama dagangan",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            color: Colors.lightGreen,
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                isExpanded = isExpanded;
                              });
                            },
                          ),
                        ),
                        controller: _searchController,
                      ),
                    ),
                    Container(
                      height: _height*0.8,
                      width: _width,
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: StreamBuilder(
                        stream: _getSellerStreamSnapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  _buildSellerCard(
                                      context, snapshot.data.documents[index]));
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
        //.where('location', isLessThan: greaterGeopoint)
        .where('location', isGreaterThan: lesserGeopoint)
        .getDocuments();

    yield* Firestore.instance.collection('dataJualan').snapshots();
  }

  Widget _buildSellerCard(BuildContext context, DocumentSnapshot document) {
    return SingleChildScrollView(
      child: InkWell(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: [
                        AutoSizeText(
                          document['nama'],
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        document['tipe'] == 1
                            ? AutoSizeText(
                                'Keliling',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              )
                            : AutoSizeText(
                                'Menetap',
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                    Spacer(),
                    //IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
                    document['tipe'] == 1
                        ? FlatButton(
                            color: Colors.yellow[700],
                            child: AutoSizeText(
                              "Panggil",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
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
