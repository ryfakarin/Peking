import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:hehe/widgets/provider.dart';

class regCustomerPage extends StatefulWidget {
  regCustomerPage(flag);

  @override
  _regCustomerPageState createState() => _regCustomerPageState();
}

class _regCustomerPageState extends State<regCustomerPage> {
  int _tipeUser;
  String _phoneNumberCust;

  TextEditingController _namaController = TextEditingController();

  _PhoneNumberChangeCust(
      String number, String internationalizedPhoneNumber, String isCode) {
    _phoneNumberCust = internationalizedPhoneNumber;
    print(_phoneNumberCust);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: _height * 0.125),
                    AutoSizeText(
                      "Sign Up sebagai Pembeli",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800]),
                    ),
                    SizedBox(height: _height * 0.1),
                    AutoSizeText(
                      "Nama",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.teal[800]),
                    ),
                    SizedBox(height: _height * 0.02),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.teal[900]),
                      )),
                      child: TextFormField(
                        controller: _namaController,
                        decoration:
                            InputDecoration.collapsed(hintText: 'Nama anda'),
                      ),
                    ),
                    SizedBox(height: _height * 0.05),
                    AutoSizeText(
                      "Nomor Telpon",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, color: Colors.teal[800]),
                    ),
                    SizedBox(height: _height * 0.02),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(color: Colors.teal[900]),
                      )),
                      child: InternationalPhoneInput(
                          decoration: InputDecoration.collapsed(
                              hintText: '(813) 111-2323'),
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
                          if (_namaController.text != "" &&
                              _phoneNumberCust != "") {
                            String userName = _namaController.text;
                            _tipeUser = 0;
                            await Provider.of(context)
                                .db
                                .collection('userData')
                                .where('phoneNumber',
                                    isEqualTo: _phoneNumberCust)
                                .getDocuments()
                                .then(
                              (ref) async {
                                if (ref.documents.length > 0) {
                                  warnSnackBar(
                                      context, "Nomor anda sudah terdaftar");
                                } else {
                                  String uid = await Provider.of(context)
                                      .auth
                                      .signUpUserWithPhone(_phoneNumberCust,
                                          context, userName, _tipeUser);
                                }
                              },
                            );
                          } else {
                            warnSnackBar(context, "Kolom harus diisi");
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
            Container(
              height: _height * 0.35,
            ),
          ],
        ),
      ),
    );
  }
}
