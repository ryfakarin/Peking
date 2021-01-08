import 'package:flutter/material.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/provider.dart';
import 'home_customer.dart';
import 'package:hehe/screens/update_profile.dart';

class customerProfilePage extends StatefulWidget {
  @override
  _customerProfilePageState createState() => _customerProfilePageState();
}

class _customerProfilePageState extends State<customerProfilePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.lime[50],
        appBar: new AppBar(
            leading: null,
            toolbarHeight: _height*0.07,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.only(right: _width*0.65),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerHomePage()));
                      }),
                  FlatButton(
                      padding: EdgeInsets.only(right: _width*0.05),
                      child: Text("Log Out",
                          style: TextStyle(color: Colors.green, fontSize: 20.0)),
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()));
                      }),
                ]),
                ],
              ),
        body: SingleChildScrollView(
          child: Container(
            height: _height*0.8,
            color: Colors.pink[50],
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                    future: Provider.of(context).auth.getCurrentUID(),
                    builder: (context, snapshot){
                      if (snapshot.connectionState == ConnectionState.done){
                        return Text("${snapshot.data}");
                        // return Text("done");
                      }else{
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  Container(
                    height: 220,
                    width: 220,
                    margin: EdgeInsets.fromLTRB(105, 0, 105, 0),
                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage('assets/images/brown.png'))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text('Brown',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text('+6282537957720',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontStyle: FontStyle.italic)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 30, 250, 0),
                    child: Text('Favorites',
                        style: TextStyle(
                            color: Colors.brown[800],
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    textColor: Colors.white,
                    padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    color: Colors.brown[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      print(_auth.getCurrentUID());
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => UpdateProfile()));
                    },
                    child: Container(
                      child: Text('Ubah Profil',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ));
  }
}
