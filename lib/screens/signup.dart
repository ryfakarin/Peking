import 'package:flutter/material.dart';
import 'login.dart';
import 'home_customer.dart';
import 'home_seller.dart';
import 'package:hehe/services/auth.dart';
import 'package:international_phone_input/international_phone_input.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final AuthService _authService = AuthService();

  int tipePenjual = 0;
  String _phoneNumber = "";

  setTipePenjual(int value) {
    setState(() {
      tipePenjual = value;
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
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
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
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
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: InternationalPhoneInput(
                                decoration: InputDecoration.collapsed(
                                    hintText: '(416) 123-4567'),
                                onPhoneNumberChange: onPhoneNumberChange,
                                initialPhoneNumber: _phoneNumber,
                                initialSelection: 'ID',
                                enabledCountries: ['+62'],
                                showCountryFlags: false),
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //       border: InputBorder.none,
                            //       hintText: 'Nomor Telepon',
                            //       hintStyle:
                            //           TextStyle(color: Colors.grey[400])),
                            // ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ulangi Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          SizedBox(height: 50),
                          RaisedButton(
                            textColor: Colors.grey[100],
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            color: Colors.lime[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () async {
                              var result = await _authService.createUserWithPhone(_phoneNumber, context);

                              if (_phoneNumber == "" || result == 'error') {
                                setState(() {
                                  print("No longer valid");
                                });
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerHomePage()));
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
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
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
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: InternationalPhoneInput(
                                decoration: InputDecoration.collapsed(
                                    hintText: '(416) 123-4567'),
                                onPhoneNumberChange: onPhoneNumberChange,
                                initialPhoneNumber: _phoneNumber,
                                initialSelection: 'IDN',
                                enabledCountries: ['+62'],
                                showCountryFlags: false),
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //       border: InputBorder.none,
                            //       hintText: 'Nomor Telepon',
                            //       hintStyle:
                            //           TextStyle(color: Colors.grey[400])),
                            // ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.lightGreen))),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ulangi Kata Sandi',
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 50, 0),
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
                                            color: Colors.grey, fontSize: 16)),
                                    onChanged: (val) {
                                      setTipePenjual(val);
                                      print(tipePenjual);
                                    })
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                          RaisedButton(
                            textColor: Colors.grey[100],
                            padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                            color: Colors.lime[700],
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerHomePage()));
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
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
