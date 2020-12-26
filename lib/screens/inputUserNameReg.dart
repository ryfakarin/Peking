import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'inputUserPhoneNumReg.dart';

class inputNamePage extends StatelessWidget {
  int flag;

  inputNamePage(this.flag);

  TextEditingController namaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      width: _width,
      height: _height,
      color: Colors.teal[800],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.3),
              AutoSizeText(
                "Nama anda",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, color: Colors.teal[100]),
              ),
              SizedBox(height: _height * 0.05),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  hintText: "Nama..",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal[100])),
                  focusedBorder: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal[100])),
                ),
              ),
              SizedBox(height: _height * 0.05),
              RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.lightGreen[200],
                child: Icon(
                  Icons.arrow_right_alt,
                  size: 60.0,
                  color: Colors.black54,
                ),
                padding: EdgeInsets.all(5.0),
                shape: CircleBorder(),
                onPressed: () {
                  if (namaController.text != "") {
                    print(flag);
                    print(namaController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => inputPhonePage(flag, namaController.text)));
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
