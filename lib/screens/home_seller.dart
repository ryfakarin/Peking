import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hehe/screens/status_history_seller.dart';
import 'package:hehe/widgets/provider.dart';

class SellerHomePage extends StatefulWidget {
  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  Color _iconInColor = Colors.green[400];
  Color _iconOutColor = Colors.grey[600];
  Color _iconTravelColor = Colors.green[400];
  Color _iconNotColor = Colors.green[400];
  Color _iconClickColor = Colors.grey[600];

  String _currentStatus = 'checkOut';
  Position _currentLocation;

  List<String> user = List<String>();
  List<GeoPoint> userWithLoc = List<GeoPoint>();

  GoogleMapController _mapController;
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);
  final Set<Marker> _mapMarker = {};

  void _mapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  Future<Position> _locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  _getLocation() async {
    _currentLocation = await _locateUser();
    setState(() {
      _currentPosition =
          LatLng(_currentLocation.latitude, _currentLocation.longitude);
    });

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_currentLocation.latitude, _currentLocation.longitude),
        zoom: 16.0)));

    _setDocument();

  }

  _setDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context).db.collection('locData').document(uid).setData(
        {'location': GeoPoint(_currentPosition.latitude, _currentPosition.longitude)});
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.pink,
        body: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            leading: null,
            toolbarHeight: _height * 0.1,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              SizedBox(width: _width * 0.05),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, _width * 0.03, 0),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logo.PNG'))),
              ),
              Container(
                  padding: EdgeInsets.only(top: _height * 0.04),
                  child: Text('Peking',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold))),
              Spacer(),
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
                            builder: (context) => statusAndHistorySeller()));
                  }),
              IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }),
              SizedBox(width: _width * 0.05),
            ],
          ),
          body: Container(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.03),
                  dynamicWidget(),
                  ButtonBar(
                    mainAxisSize: MainAxisSize.min,
                    buttonPadding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.house),
                          iconSize: 40,
                          color: _iconOutColor,
                          onPressed: () {
                            setState(() {
                              _iconOutColor = _iconClickColor;
                              _iconInColor = _iconNotColor;
                              _iconTravelColor = _iconNotColor;
                              _currentStatus = 'checkOut';
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.store),
                          iconSize: 40,
                          color: _iconInColor,
                          onPressed: () {
                            setState(() {
                              _iconOutColor = _iconNotColor;
                              _iconInColor = _iconClickColor;
                              _iconTravelColor = _iconNotColor;
                              _currentStatus = 'checkIn';
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.directions_bike),
                          iconSize: 40,
                          color: _iconTravelColor,
                          onPressed: () {
                            setState(() {
                              _iconOutColor = _iconNotColor;
                              _iconInColor = _iconNotColor;
                              _iconTravelColor = _iconClickColor;
                              _currentStatus = 'travel';
                            });
                          })
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget dynamicWidget() {
    if (_currentStatus == 'checkOut') {
      return Container(
        height: 400,
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(
              child: AutoSizeText(
                'Anda sedang tidak berjualan..',
                maxLines: 1,
                style: TextStyle(
                    color: Colors.brown[600],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
                height: 350,
                width: 300,
                child: Image.asset('assets/images/store.png')),
            Spacer(),
          ],
        ),
      );
    } else if (_currentStatus == 'checkIn') {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                "Lokasi anda sekarang",
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.green[800]),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
                future: _getLocation(),
                builder: (context, snapshot) {
                  return Container(
                    height: 400,
                    color: Colors.lightGreen,
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: _currentPosition, zoom: 16.0),
                      mapType: MapType.normal,
                      markers: _mapMarker,
                      myLocationEnabled: true,
                      onMapCreated: _mapCreated,
                    ),
                  );
                }),
          ],
        ),
      );
    } else if (_currentStatus == 'travel') {
      return Container(
        height: 400,
        child: Column(
          children: <Widget>[
            Spacer(),
            Center(
              child: AutoSizeText(
                'Anda sedang menuju suatu lokasi..',
                maxLines: 1,
                style: TextStyle(
                    color: Colors.brown[600],
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.all(20),
                height: 350,
                width: 300,
                child: Image.asset('assets/images/distance.png')),
            Spacer()
          ],
        ),
      );
    }
  }
}
