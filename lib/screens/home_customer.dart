import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/menu.dart';
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
  profileJualan jualan = profileJualan("", null);
  Future resultsLoaded;

  final Set<Marker> _mapMarker = {};
  LatLng _currentPosition = LatLng(0, 0);
  Position _currentLocation;
  GoogleMapController _mapController;

  List<String> user = List<String>();
  List<GeoPoint> userWithLoc = List<GeoPoint>();

  List _allResults = [];
  List _resultList = [];
  TextEditingController _searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    showResultList();
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

  _getLocation() async {
    _currentLocation = await _locateUser();
    _currentPosition =
        LatLng(_currentLocation.latitude, _currentLocation.longitude);

    navigateMap(_currentPosition);

    _setDocument();
  }

  getSearchResult() async {
    var data = await Firestore.instance.collection('dataJualan').getDocuments();

    setState(() {
      _allResults = data.documents;
    });

    showResultList();

    return "complete";
  }

  showResultList() {
    var showResult = [];

    if (_searchController.text != "") {
      for(var profile in _allResults){
        var namaJualan = profileJualan.fromSnapshot(profile).namaJualan.toLowerCase();
        if(namaJualan.contains(_searchController.text.toLowerCase())){
          showResult.add(profile);
        }
      }
    } else {
      showResult = List.from(_allResults);
    }

    setState(() {
      _resultList = showResult;
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
                height: _height * 0.5,
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
                            },
                          ),
                        ),
                        controller: _searchController,
                      ),
                    ),
                    Container(
                      height: _height * 0.8,
                      width: _width,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ListView.builder(
                        itemCount: _resultList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildSellerCard(context, _resultList[index]);
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
                        Container(
                          width: 200,
                          child: AutoSizeText(
                            document['nama'],
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
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
                            SizedBox(
                              width: 120,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    FlatButton(
                      color: document['tipe'] == 1
                          ? Colors.green[700]
                          : Colors.yellow[700],
                      child: AutoSizeText(
                        document['tipe'] == 1 ? "Panggil" : "Hampiri",
                        maxLines: 1,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Panggil " + document['nama'] + " ?"),
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
                                color: document['tipe'] == 1
                                    ? Colors.green[100]
                                    : Colors.yellow[600],
                                child: Text(
                                  document['tipe'] == 1 ? "Panggil" : "Hampiri",
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () async {
                                  _panggilan.sellerId = document.documentID;
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
