import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/screens/chooseUserTypeReg.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';
import 'package:international_phone_input/international_phone_input.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _formKey = GlobalKey<FormState>();

  String phoneNumber = '';

  bool validate() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Form(
                  key: _formKey,
                  child: SafeArea(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: _height * 0.12),
                        Container(
                          padding: EdgeInsets.only(right: 50, left: 50),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: _height * 0.2,
                                width: _width * 0.4,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/logo.PNG'))),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                child: AutoSizeText('Peking',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.orange[200]),
                                  ),
                                ),
                                child: InternationalPhoneInput(
                                    decoration: InputDecoration.collapsed(
                                        hintText: '(813) 555-6167'),
                                    onPhoneNumberChange: onPhoneNumberChange,
                                    initialPhoneNumber: phoneNumber,
                                    initialSelection: 'ID',
                                    enabledCountries: ['+62'],
                                    showCountryFlags: false),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: _height * 0.03),
                        RaisedButton(
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                          color: Colors.orangeAccent[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          onPressed: () async {
                            if (phoneNumber != '') {
                              await Provider.of(context)
                                  .db
                                  .collection('userData')
                                  .where('phoneNumber', isEqualTo: phoneNumber)
                                  .getDocuments()
                                  .then(
                                (ref) {
                                  if (ref.documents.length > 0) {
                                    Provider.of(context)
                                        .auth
                                        .signInUserWithPhone(
                                            phoneNumber, context);
                                  } else {
                                    warnSnackBar(context,
                                        "Nomor telepon belum terdaftar");
                                  }
                                },
                              );
                            } else {
                              warnSnackBar(
                                  context, "Nomor telepon tidak bisa kosong");
                            }
                          },
                          child: Container(
                            child: AutoSizeText('Log In',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: _height * 0.03),
                        Container(
                          child: Center(
                            child: AutoSizeText('Belum memiliki akun?',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          chooseUserTypePage()));
                            },
                            child: AutoSizeText('Buat akun baru',
                                style: TextStyle(
                                    color: Colors.lightGreen[700],
                                    fontSize: 15,
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: _height * 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
