import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/services/auth.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.fromLTRB(50, 120, 50, 0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                      child: Text('Log In',
                          style: TextStyle(
                              color: Colors.orange[400],
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.orange[200]))),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() => phoneNumber = val);
                        },
                        validator: emptyValidator.emptyValidate,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nomor Telepon',
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.orange[200]))),
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                        validator: emptyValidator.emptyValidate,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Kata Sandi',
                            hintStyle: TextStyle(color: Colors.grey[400])),
                      ),
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
                  if(validate()){
                    // check pembeli apa penjual
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerHomePage()));
                  }
                },
                child: Container(
                  child: Text('Log In',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpPage()));
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
    );
  }
}

class emptyValidator {
  static String emptyValidate(String value) {
    if (value.isEmpty) {
      return "Lengkapi Kolom";
    }
    return null;
  }
}
