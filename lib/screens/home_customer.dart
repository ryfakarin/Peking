import 'package:flutter/material.dart';
import 'package:hehe/model/places.dart';
import 'package:hehe/screens/status_history.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/services/credentials.dart';
import 'profile_customer.dart';
import 'login.dart';
import 'package:dio/dio.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final AuthService _authService = AuthService();

  TextEditingController _searchController = new TextEditingController();

  String _heading;

  List<Places> _placesList = [
    Places("Example 1"),
    Places("Example 2"),
    Places("Example 3")
  ];

  @override
  void initState() {
    super.initState();
    _heading = null;
  }

  void getLocationResults(String input) async {
    String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String type = '(regions)';

    String req = '$baseUrl?input=$input&key=$PLACES_API_KEY&type=$type';
    Response response = await Dio().get(req);

    final predictions = response.data['predictions'];
    List<Places> _displayedResults = [];

    for (var i = 0; i < predictions.length; i++) {
      String name = predictions[i]['description'];
      _displayedResults.add(Places(name));
    }
    // print(response);

    setState(() {
      _placesList = _displayedResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            appBar: new AppBar(
              leading: null,
              toolbarHeight: 100,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: <Widget>[
                IconButton(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 28.0,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 25, 10, 0),
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/logo.PNG'))),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 52, 80, 20),
                    child: Text('Peking',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            // fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold))),
                IconButton(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
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
                    padding: EdgeInsets.fromLTRB(0, 50, 50, 20),
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
              height: 800,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                            hintText: "Cari lokasi..",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              color: Colors.lightGreen,
                              onPressed: () {},
                            )),
                        autofocus: false,
                        onChanged: (text) {
                          getLocationResults(text);
                        },
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _placesList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          searchResultCard(context, index),
                    ),
                  ),
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
                                Text(_placesList[index].name),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
