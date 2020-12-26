import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'home_customer.dart';
import 'home_seller.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/services/auth.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  UserModel user = UserModel("");
  CustomerModel customerModel = CustomerModel("", "", "", "", 0);
  SellerModel sellerModel = SellerModel("", "", "", "", 0, 0);

  var _formKeyCustomer = GlobalKey<FormState>();
  var _formKeySeller = GlobalKey<FormState>();

  int tipePenjual = 0;
  int tipeUser;
  String _nama = "";
  String _phoneNumber = "";
  String _password = "";
  String _passwordRep = "";

  setTipePenjual(int value) {
    setState(() {
      tipePenjual = value;
    });
  }

  bool validateCust() {
    final form = _formKeyCustomer.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  bool validateSeller() {
    final form = _formKeySeller.currentState;
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
      _phoneNumber = internationalizedPhoneNumber;
      print(_phoneNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[200],
        body: DefaultTabController(
          length: 2,
          child: MaterialApp(
            home: Scaffold(
              appBar: new AppBar(
                toolbarHeight: 110,
                leading: null,
                backgroundColor: Colors.lime[700],
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 25, 330, 0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                  )
                ],
                bottom: TabBar(
                  onTap: (index) {},
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(fontSize: 20.0),
                  //For Selected tab
                  unselectedLabelStyle: TextStyle(fontSize: 18.0),
                  //For Un-selected Tabs
                  tabs: [Tab(text: 'Pembeli'), Tab(text: 'Penjual')],
                ),
              ),
              body: TabBarView(
                children: [
                    Form(
                      key: _formKeyCustomer,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() => _nama = val);
                                },
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nama Lengkap',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: InternationalPhoneInput(
                                  decoration: InputDecoration.collapsed(
                                      hintText: '(416) 123-4567'),
                                  onPhoneNumberChange: onPhoneNumberChange,
                                  initialPhoneNumber: _phoneNumber,
                                  initialSelection: 'ID',
                                  enabledCountries: ['+62'],
                                  showCountryFlags: false),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Kata Sandi',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                onChanged: (val) {
                                  setState(() => _password = val);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Ulangi Kata Sandi',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                onChanged: (val) {
                                  setState(() => _passwordRep = val);
                                },
                              ),
                            ),
                            SizedBox(height: 50),
                            RaisedButton(
                              textColor: Colors.grey[100],
                              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                              color: Colors.lime[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () async {
                                var result = await _authService
                                    .verificationUserWithPhone(_phoneNumber, context);
                                if (validateCust()) {
                                  if (_phoneNumber == "" || result == 'error') {
                                    return null;
                                  }
                                  // customerModel.name = _nama;
                                  // customerModel.phoneNumber = _phoneNumber;
                                  // customerModel.password = _password;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CustomerHomePage()));
                                }
                              },
                              child: Container(
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),
                  Form(
                      key: _formKeySeller,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                onChanged: (val) {
                                  setState(() => _nama = val);
                                },
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Nama Lengkap',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: InternationalPhoneInput(
                                  decoration: InputDecoration.collapsed(
                                      hintText: '(000) 111-2222'),
                                  onPhoneNumberChange: onPhoneNumberChange,
                                  initialPhoneNumber: _phoneNumber,
                                  initialSelection: 'IDN',
                                  enabledCountries: ['+62'],
                                  showCountryFlags: false),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Kata Sandi',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                onChanged: (val) {
                                  setState(() => _password = val);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.lightGreen))),
                              child: TextFormField(
                                validator: emptyValidator.emptyValidate,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Ulangi Kata Sandi',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400])),
                                onChanged: (val) {
                                  setState(() => _passwordRep = val);
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 50, 0),
                              alignment: Alignment.bottomLeft,
                              width: 350,
                              child: Column(
                                children: <Widget>[
                                  RadioListTile(
                                    value: 1,
                                    groupValue: tipePenjual,
                                    activeColor: Colors.lightGreen,
                                    title: const Text('Menetap',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16)),
                                    onChanged: (val) {
                                      setTipePenjual(val);
                                      print(tipePenjual);
                                    },
                                  ),
                                  RadioListTile(
                                      value: 2,
                                      groupValue: tipePenjual,
                                      activeColor: Colors.lightGreen,
                                      title: const Text('Keliling',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16)),
                                      onChanged: (val) {
                                        setTipePenjual(val);
                                        print(tipePenjual);
                                      })
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              textColor: Colors.grey[100],
                              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                              color: Colors.lime[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () async {
                                var result = await _authService
                                    .verificationUserWithPhone(_phoneNumber, context);
                                if (validateSeller() || tipePenjual == 0) {
                                  if (_phoneNumber == "" || result == 'error') {
                                    return null;
                                  }
                                  // sellerModel.name = _nama;
                                  // sellerModel.phoneNumber = _phoneNumber;
                                  // sellerModel.password = _password;
                                  // if (tipePenjual == 1) {
                                  //   sellerModel.tipePenjual = "Keliling";
                                  // } else if (tipePenjual == 2){
                                  //   sellerModel.tipePenjual = "Menetap";
                                  // }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SellerHomePage()));
                                }
                              },
                              child: Container(
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
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

class cmprPassword {
  static String validate(String pass1, String pass2) {
    if (pass1 != pass2) {
      return "Wrong password";
    }
    return null;
  }
}
