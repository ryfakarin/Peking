import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/places.dart';
import 'package:hehe/screens/status_history.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/services/credentials.dart';
import 'profile_customer.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final AuthService _authService = AuthService();

  GoogleMapController _mapController;
  String searchAddress;
  final Set<Marker> _mapMarker = {};
  LatLng _currentPosition = LatLng(-7.8032076, 110.3573354);

  TextEditingController _searchController = new TextEditingController();
  List<Places> _placesList = [];

  @override
  void initState() {
    super.initState();
    _mapMarker.add(Marker(
      markerId: MarkerId("-7.8032076, 110.3573354"),
      position: _currentPosition,
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void getLocationResults(String input) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(cities)';

    String req = '$baseUrl?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(req);

    final predictions = response.data['predictions'];
    List<Places> _displayedResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      _displayedResults.add(Places(name));
    }
    print(response);

    setState(() {
      _placesList = _displayedResults;
    });
  }

  void mapCreated(controller) {
    setState(() {
      _mapController = controller;
    });
  }

  searchAndNavigate(String searchString) {

    Geocoder.local.findAddressesFromQuery(searchString).then((result) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(result.first.coordinates.latitude, result.first.coordinates.longitude), zoom: 14.0
      )));
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final Set<Marker> _mapMarker = {};
    final LatLng _currentPosition = LatLng(6.2088, 106.8456);

    return Scaffold(
        appBar: new AppBar(
          leading: null,
          toolbarHeight: _height * 0.1,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, _width*0.03, 0),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/logo.PNG'))),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, _height*0.04, _width*0.3, 0),
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
                          builder: (context) => StatusAndHistory()));
                }),
            IconButton(
                padding: EdgeInsets.fromLTRB(0, 0, _width*0.1, 0),
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
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: "Cari lokasi..",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.lightGreen,
                          onPressed: () {
                            getLocationResults("");
                            _searchController.clear();
                          },
                        )),
                    autofocus: false,
                    onChanged: (text) {
                      getLocationResults(text);
                    },
                    onSubmitted: (text) {
                      setState(() {
                        searchAddress = text;
                      });
                      searchAndNavigate(searchAddress);
                    },
                  )),
              SizedBox(height: _height * 0.02),
              Stack(children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: _height * 0.4,
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
                Container(
                  height: _height * 0.4,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                    itemCount: _placesList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        searchResultCard(context, index),
                  ),
                ),
              ]),
            ],
          ),
        )));
  }

  Widget searchResultCard(BuildContext context, int index) {
    return Hero(
      tag: "SearchedPlace-${_placesList[index].name}",
      transitionOnUserGestures: true,
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 3.0),
          child: SingleChildScrollView(
            child: Card(
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Wrap(
                              children: <Widget>[
                                InkWell(
                                    child: AutoSizeText(_placesList[index].name,
                                        maxLines: 1
                                    ),
                                    onTap: () {
                                      var parts = _placesList[index].name.split(',');
                                      searchAddress = parts[0].trim();
                                      print(searchAddress);
                                      searchAndNavigate(searchAddress);
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
