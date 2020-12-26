import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/chooseUserTypeReg.dart';
import 'package:international_phone_input/international_phone_input.dart';

class inputPhonePage extends StatelessWidget {
  int flag;
  String nama;

  inputPhonePage(this.flag, this.nama);

  TextEditingController phoneController = TextEditingController();

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isCode) {
    phoneController.text = internationalizedPhoneNumber;
      print(phoneController);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          width: _width,
          height: _height,
          color: Colors.teal[600],
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: _height * 0.3),
                  AutoSizeText(
                    "Nomor Telepon Anda",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.teal[100]),
                  ),
                  SizedBox(height: _height * 0.03),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.teal[100]),
                        )),
                    child: InternationalPhoneInput(
                        decoration: InputDecoration.collapsed(
                            hintText: '(813) 555-6167'),
                        onPhoneNumberChange: onPhoneNumberChange,
                        initialPhoneNumber: phoneController.text,
                        initialSelection: 'ID',
                        enabledCountries: ['+62'],
                        showCountryFlags: false),
                  ),
                  SizedBox(height: _height * 0.05),
                  RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Colors.black54,
                    child: Icon(
                      Icons.arrow_right_alt,
                      size: 60.0,
                      color: Colors.lightGreen[200],
                    ),
                    padding: EdgeInsets.all(5.0),
                    shape: CircleBorder(),
                    onPressed: () {
                      if (phoneController.text != "") {
                        print(flag);
                        print(phoneController.text);
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
