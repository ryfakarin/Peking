import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/screens/chooseUserTypeReg.dart';
import 'package:hehe/services/auth.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'signup.dart';
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(50, 150, 50, 0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/logo.PNG'))),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Text('Peking',
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
                SizedBox(height: 40),
                RaisedButton(
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                  color: Colors.orangeAccent[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () async {
                    var result = await _authService
                        .verificationUserWithPhone(phoneNumber, context);
                    if (phoneNumber == "") {
                      showDialog(context: context, builder: (BuildContext context) => CustomDialog(
                        title: "Masukkan nomor anda",
                        description: " ",
                        primaryButtonText: "Ya",
                        primaryButtonRoute: "/loginPage"
                      ),
                      );
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerHomePage()));
                    }
                  },
                  child: Container(
                    child: Text('Log In',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  child: Center(
                    child: Text('Belum memiliki akun?',
                        style: TextStyle(
                            color: Colors.lightGreen[800],
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
                    child: Text('Buat akun baru',
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
