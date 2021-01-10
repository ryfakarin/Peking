import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/screens/status_history.dart';
import 'package:hehe/services/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SellerHomePage extends StatefulWidget {
  @override
  _SellerHomePageState createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  final AuthService _authService = AuthService();

  String currentStatus = 'checkIn';

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
        backgroundColor: Colors.pink,
        body: Scaffold(
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
                  padding:
                      EdgeInsets.fromLTRB(0, _height * 0.04, _width * 0.3, 0),
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StatusAndHistory()));
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
                            builder: (context) => sellerProfilePage()));
                  }),
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
                          color: Colors.green[400],
                          onPressed: () {
                            setState(() {
                              currentStatus = 'checkIn';
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.car_repair),
                          iconSize: 40,
                          color: Colors.green[400],
                          onPressed: () {
                            setState(() {
                              currentStatus = 'travel';
                            });
                          }),
                      IconButton(
                          icon: Icon(Icons.store),
                          iconSize: 40,
                          color: Colors.green[400],
                          onPressed: () {
                            setState(() {
                              currentStatus = 'checkOut';
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
    if (currentStatus == 'checkIn') {
      return AutoSizeText(
        'Check In',
        style: TextStyle(color: Colors.blue, fontSize: 20),
      );
    } else if (currentStatus == 'travel') {
      return Column(
        children: <Widget>[
          RaisedButton(
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            color: Colors.brown[300],
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            onPressed: () {},
            child: Container(
              child: AutoSizeText('Perbarui Lokasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 20),
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
      );
    } else if (currentStatus == 'checkOut') {
      return AutoSizeText(
        'Check Out',
        style: TextStyle(color: Colors.blue, fontSize: 20),
      );
    }
  }
}
