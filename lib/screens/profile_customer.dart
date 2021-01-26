import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';
import 'home_customer.dart';
import 'package:hehe/screens/update_profile.dart';

class customerProfilePage extends StatefulWidget {
  @override
  _customerProfilePageState createState() => _customerProfilePageState();
}

class _customerProfilePageState extends State<customerProfilePage> {
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
          Row(
            children: [
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Log out dari akun anda?"),
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
                            await Provider.of(context).auth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height * 0.6,
          width: _width,
          child: Column(
            children: <Widget>[
              Spacer(),
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
                                fontSize: 30,
                                fontWeight: FontWeight.bold));
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
                          return _inputNamaDialog('Nama anda', namaUser);
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: _height * 0.01),
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
                          // return _inputPhoneDialog('Nomor telepon anda', namaUser);
                        },
                      );
                    },
                  ),
                  Spacer(),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Dialog _inputNamaDialog(
      String inputTitle, TextEditingController inputController) {
    return Dialog(
      child: Container(
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
    );
  }
}
