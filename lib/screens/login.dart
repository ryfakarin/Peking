import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/screens/chooseUserTypeReg.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'home_customer.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  var _formKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String password = '';
  bool showBox = false;

  bool validate() {
    final form = _formKey.currentState;
    form.save();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: _height*0.12),
              Container(
                padding: EdgeInsets.only(right: 50, left: 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0)),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: _height*0.2,
                      width: _width*0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.PNG'))),
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
                  ],
                ),
              ),
              SizedBox(height: _height*0.03),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                color: Colors.orangeAccent[400],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () async {
                  var result = await _authService.verificationUserWithPhone(
                      phoneNumber, context);
                  if (phoneNumber == "" || result == 'error') {
                    showDialog(context: context, builder: (BuildContext context) => CustomDialog(
                      title: "Masukkan nomor anda",
                      description: " ",
                      primaryButtonText: "OK",
                      primaryButtonRoute: "/loginPage"
                    ),);
                  }
                },
                child: Container(
                  child: AutoSizeText('Log In',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: _height*0.01),
              Container(
                child: TextButton(
                  onPressed: () {
                    _authService.signInAnon();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerHomePage()));
                  },
                  child: AutoSizeText('Masuk sebagai tamu',
                      style: TextStyle(
                          color: Colors.lightGreen[700], fontSize: 15)),
                ),
              ),
              SizedBox(height: _height*0.03),
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
                            builder: (context) => chooseUserTypePage()));
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
    );
  }
}
