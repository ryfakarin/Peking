import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_seller_menetap.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/screens/updateMenu.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';

class sellerProfilePage extends StatefulWidget {
  @override
  _sellerProfilePageState createState() => _sellerProfilePageState();
}

class _sellerProfilePageState extends State<sellerProfilePage> {

  String phoneNumber;

  UserModel _user = UserModel("", "", "", null);

  TextEditingController namaUser = TextEditingController();

  _getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      _user.phoneNumber = result.data['phoneNumber'];
      _user.name = result.data['nama'];
      _user.uid = uid;
      _user.tipeUser = result.data['tipeUser'];
    });
  }

  _setDocument(Map<String, dynamic> toJson) async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .setData(_user.toJson());
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isCode) {
    setState(() {
      phoneNumber = internationalizedPhoneNumber;
      print(phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        toolbarHeight: _height * 0.07,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.only(right: _width * 0.55),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.yellow[800],
                ),
                onPressed: () {
                  _user.tipeUser == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerHomePage()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellerStayHomePage()));
                },
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.yellow[800],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.yellow[800],
                child: AutoSizeText("Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 18.0)),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        "Log out dari akun anda?",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.yellow[700],
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Kembali",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        FlatButton(
                          child: Text(
                            "Log Out",
                            style: TextStyle(color: Colors.red[800]),
                          ),
                          onPressed: () async {
                            await Provider.of(context).auth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          child: Column(
            children: <Widget>[
              Container(
                width: _width,
                child: Image.asset(
                  'assets/images/sellerIcon.png',
                ),
                height: _height * 0.3,
              ),
              Row(
                children: [
                  Spacer(),
                  FutureBuilder(
                    future: _getDocument(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AutoSizeText(_user.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green[800], size: 20),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return _inputNamaDialog('Nama anda', namaUser);
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
              Row(
                children: [
                  Spacer(),
                  FutureBuilder(
                    future: _getDocument(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AutoSizeText(_user.phoneNumber,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                                fontStyle: FontStyle.italic));
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green[800], size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return _inputPhoneDialog(
                              'Nomor telepon anda', namaUser);
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: _height * 0.02),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: _height * 0.02,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 10),
                          child: AutoSizeText('Menu',
                              style: TextStyle(
                                  color: Colors.brown[800],
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Spacer(),
                        RaisedButton(
                          textColor: Colors.black,
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 2),
                              borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateMenuPage()));
                          },
                          child: Container(
                            child: AutoSizeText('Ubah Menu',
                                style: TextStyle(
                                    color: Colors.yellow[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                          width: _width * 0.05,
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      height: _height * 0.6,
                      width: _width,
                      child: StreamBuilder(
                        stream: getMenuStreamSnapshots(context),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();
                          return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  buildMenuCard(
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

  Stream<QuerySnapshot> getMenuStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .snapshots();
  }

  Widget buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              AutoSizeText(document['namaMakanan'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              AutoSizeText('Rp. ' + document['hargaMakanan'],
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }

  Dialog _inputNamaDialog(
      String inputTitle, TextEditingController inputController) {
    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  inputTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: inputController,
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
                    RaisedButton(
                        child: AutoSizeText(
                          'Batal',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(width: 20),
                    RaisedButton(
                      child: AutoSizeText(
                        'Kirim',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                      onPressed: () async {
                        if (inputController.text == "") {
                          warnSnackBar(context, "Nama tidak bisa kosong");
                        } else {
                          try {
                            _user.name = inputController.text;
                            print(_user.name);
                            _setDocument(_user.toJson());
                            Navigator.of(context).pop();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => this.build(context)));
                            createSnackBar(context, "Berhasil mengganti nama");
                          } on Exception catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Dialog _inputPhoneDialog(
      String inputTitle, TextEditingController inputController) {
    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  inputTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.orange[200]),
                      )),
                  child: InternationalPhoneInput(
                      decoration: InputDecoration.collapsed(
                          hintText: '(813) 555-6167'),
                      onPhoneNumberChange: onPhoneNumberChange,
                      initialPhoneNumber: phoneNumber,
                      initialSelection: 'ID',
                      enabledCountries: ['+62'],
                      showCountryFlags: false),
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
                    RaisedButton(
                        child: AutoSizeText(
                          'Batal',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(width: 20),
                    RaisedButton(
                      child: AutoSizeText(
                        'Kirim',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                      onPressed: () async {
                        if (inputController.text == "") {
                          warnSnackBar(
                              context, "Nomor telpon tidak bisa kosong");
                        } else {
                          try {
                            // _user.name = inputController.text;
                            // print(_user.name);
                            // _setDocument(_user.toJson());
                            // Navigator.of(context).pop();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => this.build(context)));
                            // createSnackBar(context, "Berhasil mengganti nomor telpon");
                          } on Exception catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
