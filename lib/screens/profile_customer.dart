import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/login.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'home_customer.dart';

class customerProfilePage extends StatefulWidget {
  @override
  _customerProfilePageState createState() => _customerProfilePageState();
}

class _customerProfilePageState extends State<customerProfilePage> {

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
      appBar: new AppBar(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerHomePage()));
                  }),
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
                      title: Text("Log out dari akun anda?", style: TextStyle(color: Colors.white),),
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
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(width: _width * 0.05),
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
              Container(
                height: _height * 0.35,
                width: _width,
                child: Image.asset('assets/images/custIcon.png'),
              ),
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
                          return _inputNewPhoneNumber('Nomor telepon anda', namaUser);
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

  Dialog _inputNewPhoneNumber(
      String inputTitle, TextEditingController inputController) {
    return Dialog(
      child: Container(
        height: 230,
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
                      warnSnackBar(context, "Nomor tidak bisa kosong");
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
