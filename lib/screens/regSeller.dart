import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';

class regSellerPage extends StatefulWidget {
  @override
  _regSellerPageState createState() => _regSellerPageState();
}

class _regSellerPageState extends State<regSellerPage> {
  int _radioValue = 0;
  String _phoneNumberCust;

  TextEditingController _namaController = TextEditingController();

  _PhoneNumberChangeCust(
      String number, String internationalizedPhoneNumber, String isCode) {
    _phoneNumberCust = internationalizedPhoneNumber;
    print(_phoneNumberCust);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
      width: _width,
      height: _height,
      color: Colors.lightGreen[50],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.09),
              AutoSizeText(
                "Sign Up sebagai Penjual",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800]),
              ),
              SizedBox(height: _height * 0.075),
              AutoSizeText(
                "Tipe Berjualan",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.teal[800]),
              ),
              SizedBox(height: _height * 0.01),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Radio(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: (newValue) {
                      setState(() => _radioValue = newValue);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          title: "Anda memilih tipe berdagang keliling",
                          description:
                          "Anda berpindah-pindah saat berdagang. Pembeli dapat memanggil anda berdasarkan lokasi anda berhjualan. Pilihan ini tidak dapat diubah.",
                          primaryButtonText: "OK",
                          primaryButtonRoute: "",
                        ),
                      );
                    },
                    activeColor: Colors.teal[800],

                  ),
                  new Text(
                    'Keliling',
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Radio(
                    value: 2,
                    groupValue: _radioValue,
                    onChanged: (newValue) {
                      setState(() => _radioValue = newValue);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => CustomDialog(
                          title: "Anda memilih tipe berdagang menetap",
                          description:
                          "Anda tidak berpindah-pindah saat berdagang. Pembeli tidak dapat memanggil anda, hanya dapat mengetahui lokasi anda berhjualan. Pilihan ini tidak dapat diubah.",
                          primaryButtonText: "OK",
                          primaryButtonRoute: "",
                        ),
                      );
                    },
                    activeColor: Colors.teal[800],
                  ),
                  new Text(
                    'Menetap',
                    style: new TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.025),
              AutoSizeText(
                "Nama",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.teal[800]),
              ),
              SizedBox(height: _height * 0.001),
              Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.teal[900]),
                )),
                child: TextField(
                  controller: _namaController,
                  decoration: InputDecoration.collapsed(hintText: 'Nama anda'),
                ),
              ),
              SizedBox(height: _height * 0.04),
              AutoSizeText(
                "Nomor Telpon",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.teal[800]),
              ),
              SizedBox(height: _height * 0.001),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.teal[900]),
                )),
                child: InternationalPhoneInput(
                    decoration:
                        InputDecoration.collapsed(hintText: '(813) 111-6167'),
                    onPhoneNumberChange: _PhoneNumberChangeCust,
                    initialPhoneNumber: _phoneNumberCust,
                    initialSelection: 'ID',
                    enabledCountries: ['+62'],
                    showCountryFlags: false),
              ),
              SizedBox(height: _height * 0.075),
              RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.teal[800],
                child: Icon(
                  Icons.arrow_right_alt,
                  size: 60.0,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(5.0),
                shape: CircleBorder(),
                onPressed: () async {
                  try {
                    if (_radioValue != 0 &&
                        _namaController.text != "" &&
                        _phoneNumberCust != "") {
                      await Provider.of(context)
                          .db
                          .collection('userData')
                          .where('phoneNumber', isEqualTo: _phoneNumberCust)
                          .getDocuments()
                          .then(
                        (ref) async {
                          if (ref.documents.length > 0) {
                            warnSnackBar(context, "Nomor anda sudah terdaftar");
                          } else {
                            String userName = _namaController.text;
                            String uid = await Provider.of(context)
                                .auth
                                .signUpUserWithPhone(_phoneNumberCust, context,
                                    userName, _radioValue);
                          }
                        },
                      );
                    } else {
                      warnSnackBar(context, "Kolom tidak bisa kosong");
                    }
                  } on Exception catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
