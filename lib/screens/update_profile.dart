import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/widgets/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  TextEditingController controller;
  String hintText;

  UserModel _user = UserModel("", "", "", null);

  TextEditingController _namaController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    controller = TextEditingController(text: hintText);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.amber[50],
      appBar: new AppBar(
          toolbarHeight: _height * 0.07,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.only(right: _width * 0.9),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.green,
                ),
                onPressed: () {
                  if (_user.tipeUser == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => customerProfilePage()));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }
                }),
          ]),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.15),
              AutoSizeText('Ubah Profil',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: _height * 0.02),
              Container(
                padding: EdgeInsets.only(right: _width * 0.7),
                child: AutoSizeText('Nama',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: _height * 0.01),
              FutureBuilder(
                future: getDocument(),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.lightGreen),
                          top: BorderSide(color: Colors.lightGreen),
                          left: BorderSide(color: Colors.lightGreen),
                          right: BorderSide(color: Colors.lightGreen),
                        )),
                    child: TextFormField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: _height * 0.01),
              Container(
                padding: EdgeInsets.only(right: _width * 0.5),
                child: Text('Nomor Telepon',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: _height * 0.01),
              FutureBuilder(
                future: getDocument(),
                builder: (context, snapshot) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.lightGreen),
                          top: BorderSide(color: Colors.lightGreen),
                          left: BorderSide(color: Colors.lightGreen),
                          right: BorderSide(color: Colors.lightGreen),
                        )),
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 30),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                color: Colors.green[800],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                // validasi untuk nanti ke seller atau customer
                onPressed: () async {
                  print(_namaController.text);
                  if (_namaController.text == _user.name &&
                      _phoneController.text == _user.phoneNumber) {
                    _user.name = _namaController.text;
                    _user.phoneNumber = _phoneController.text;
                    setDocument();
                  } else if (_namaController.text == _user.name) {
                    _user.name = _namaController.text;
                    setDocument();
                  } else if (_phoneController.text == _user.phoneNumber) {
                    _user.phoneNumber = _phoneController.text;
                    setDocument();
                  }

                  if (_user.tipeUser == 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => customerProfilePage()));
                  } else if (_user.tipeUser != 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }
                },
                child: Container(
                  child: Text('Ubah Profil',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    _user.uid = uid;

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      _user.phoneNumber = result.data['phoneNumber'];
      _user.name = result.data['nama'];
      _user.tipeUser = result.data['tipeUser'];
    });
  }

  setDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .setData(_user.toJson());
  }
}
