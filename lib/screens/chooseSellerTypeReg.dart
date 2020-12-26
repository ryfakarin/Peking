import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/widgets/customs.dart';

class chooseSellerTypePage extends StatefulWidget {
  @override
  _chooseSellerTypePageState createState() => _chooseSellerTypePageState();
}

class _chooseSellerTypePageState extends State<chooseSellerTypePage> {
  int flag;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      width: _width,
      height: _height,
      color: Colors.lightGreen[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.3),
              AutoSizeText(
                "Apa tipe dagangan anda?",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, color: Colors.green[900]),
              ),
              SizedBox(height: _height * 0.05),
              RaisedButton(
                color: Colors.orange[50],
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                onPressed: () {
                  flag = 1;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                          title: "Tipe dagangan anda adalah KELILING",
                          description:
                              "Anda berpindah-pindah tempat dalam melakukan penjualan, pilihan ini akan mempengaruhi tampilan anda pada aplikasi ini",
                          primaryButtonText: "Ya",
                          primaryButtonRoute: "/inputUserNameReg/1",
                          secondaryButtonText: "Kembali",
                          secondaryButtonRoute: "/chooseSellerType"));
                },
                child: Text(
                  "Keliling",
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange[900]),
                ),
              ),
              SizedBox(height: _height * 0.025),
              RaisedButton(
                color: Colors.orange[50],
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Text(
                  "Menetap",
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange[900]),
                ),
                onPressed: () {
                  flag = 2;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomDialog(
                            title: "Tipe dagangan anda adalah MENETAP",
                            description:
                                "Anda berdagang hanya di satu tempat yang cenderung sulit atau tidak bisa berpindah-pindah, pilihan ini akan mempengaruhi tampilan anda pada aplikasi ini",
                            primaryButtonText: "Ya",
                            primaryButtonRoute: "/inputUserNameReg/2",
                            secondaryButtonText: "Kembali",
                            secondaryButtonRoute: "/chooseSellerType",
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
