import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/services/auth.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:provider/provider.dart';

class regCustomerPage extends StatelessWidget {
  final AuthService _authService = AuthService();
  final db = Firestore.instance;

  int flag;
  String phoneNumberCust;

  regCustomerPage(this.flag);

  TextEditingController namaController = TextEditingController();

  UserModel userModel;

  void PhoneNumberChangeCust(
      String number, String internationalizedPhoneNumber, String isCode) {
    phoneNumberCust = internationalizedPhoneNumber;
    print(phoneNumberCust);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      width: _width,
      height: _height,
      color: Colors.green[50],
      child: SafeArea(
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
                child: TextField(
                  controller: namaController,
                  decoration: InputDecoration.collapsed(hintText: 'Nama anda'),
                  onChanged: (val) {},
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
                    decoration:
                        InputDecoration.collapsed(hintText: '(813) 111-2323'),
                    onPhoneNumberChange: PhoneNumberChangeCust,
                    initialPhoneNumber: phoneNumberCust,
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
                  if (namaController.text != "" && phoneNumberCust != "") {
                    userModel.uid = await _authService.getCurrentUID();
                    userModel.name = namaController.text;
                    userModel.phoneNumber = phoneNumberCust;
                    userModel.tipeUser = 0;
                    // final uid = await Provider.of(context).auth.getCurrentUID();
                    // UserModel(uid, namaController.text, phoneNumberCust, 0);
                    //await db.collection("userData").document(uid).collection("user").add(data)
                    print(userModel.uid);
                    print(userModel.name);
                    print(userModel.phoneNumber);
                    print(userModel.tipeUser);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             inputPhonePage(flag, namaController.text)));
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
