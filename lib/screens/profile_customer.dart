import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/widgets/provider.dart';
import 'home_customer.dart';
import 'package:hehe/screens/update_profile.dart';

class customerProfilePage extends StatefulWidget {
  @override
  _customerProfilePageState createState() => _customerProfilePageState();
}

class _customerProfilePageState extends State<customerProfilePage> {
  UserModel user = UserModel("", "", "", null);

  getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    String docId;

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      user.phoneNumber = result.data['phoneNumber'];
      user.name = result.data['nama'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.lime[50],
      appBar: new AppBar(
        leading: null,
        toolbarHeight: _height * 0.07,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Row(children: [
            IconButton(
                padding: EdgeInsets.only(right: _width * 0.65),
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
                padding: EdgeInsets.only(right: _width * 0.05),
                child: Text("Log Out",
                    style: TextStyle(color: Colors.green, fontSize: 20.0)),
                onPressed: () async {
                  await Provider.of(context).auth.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }),
          ]),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height*0.6,
          width: _width,
          child: Column(
            children: <Widget>[
              Spacer(),
              Container(
                height: _height * 0.2,
                width: _width * 0.6,
                margin: EdgeInsets.fromLTRB(105, 0, 105, 0),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/images/brown.png'))),
              ),
              SizedBox(height: _height * 0.04),
              FutureBuilder(
                future: getDocument(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AutoSizeText(user.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: _height * 0.01),
              FutureBuilder(
                future: getDocument(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AutoSizeText(user.phoneNumber,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontStyle: FontStyle.italic));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: _height * 0.04),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                color: Colors.brown[300],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UpdateProfile()));
                },
                child: Container(
                  child: Text('Ubah Profil',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
