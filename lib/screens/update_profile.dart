import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/profile_customer.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/widgets/provider.dart';

class UpdateProfile extends StatefulWidget {
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  UserModel user = UserModel("", "", "", null);

  String docId;

  TextEditingController namaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: new AppBar(
          toolbarHeight: _height * 0.07,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.only(right: _width * 0.9),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.green,
                ),
                onPressed: () {
                  if(user.tipeUser == 0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => customerProfilePage()));
                  } else if(user.tipeUser != 0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }
                }),
          ]),
      body: SingleChildScrollView(
        child: Container(
          width: _width,
          child: Column(
            children: <Widget>[
              Container(
                height: _height * 0.2,
                width: _width * 0.6,
                margin: EdgeInsets.fromLTRB(105, 0, 105, 0),
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage('assets/images/cony.png'))),
                child: Stack(children: <Widget>[
                  new Positioned(
                    right: 0.0,
                    left: 0.0,
                    bottom: 0.0,
                    child: new Icon(
                      Icons.camera_alt,
                      size: 36.0,
                      color: Colors.black,
                    ),
                  ),
                ]),
              ),
              SizedBox(height: _height * 0.02),
              Container(
                padding: EdgeInsets.only(right: _width * 0.7),
                child: AutoSizeText('Nama',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: _height * 0.01),
              FutureBuilder(future: getDocument(), builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return inputBox(namaController, user.name);
                }else{
                  return CircularProgressIndicator();
                }
              },),
              SizedBox(height: _height * 0.01),
              Container(
                padding: EdgeInsets.only(right: _width * 0.5),
                child: Text('Nomor Telepon',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: _height * 0.01),
              FutureBuilder(future: getDocument(), builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  return inputBox(phoneController, user.phoneNumber);
                }else{
                  return CircularProgressIndicator();
                }
              },),
              SizedBox(height: 30),
              RaisedButton(
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                color: Colors.green[800],
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                // validasi untuk nanti ke seller atau customer
                onPressed: () async {
                  if(namaController.text != '' && phoneController.text != ""){
                    user.name = namaController.text;
                    user.phoneNumber = phoneController.text;
                    setDocument();
                  } else if(namaController.text != ''){
                    user.name = namaController.text;
                    setDocument();
                  } else if(phoneController.text != ""){
                    user.phoneNumber = phoneController.text;
                    setDocument();
                  }

                  if(user.tipeUser == 0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => customerProfilePage()));
                  } else if(user.tipeUser != 0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => sellerProfilePage()));
                  }

                },
                child: Container(
                  child: Text('Ubah Profil',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Container inputBox(TextEditingController controller, String hintText) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.lightGreen),
        top: BorderSide(color: Colors.lightGreen),
        left: BorderSide(color: Colors.lightGreen),
        right: BorderSide(color: Colors.lightGreen),
      )),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  getDocument() async {
    final uid = await Provider
        .of(context)
        .auth
        .getCurrentUID();

    var doc_ref = await Provider
        .of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .getDocuments();
    doc_ref.documents.forEach((result) {
      docId = result.documentID;
    });

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .document(docId)
        .get()
        .then((result) {
      user.phoneNumber = result.data['phoneNumber'];
      user.name = result.data['nama'];
      user.uid = result.data['uid'];
      user.tipeUser = result.data['tipeUser'];

    });
  }

  setDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    var doc_ref = await Provider
        .of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .getDocuments();
    doc_ref.documents.forEach((result) {
      docId = result.documentID;
    });

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .collection('profileData')
        .document(docId)
        .setData(user.toJson());
  }

}
