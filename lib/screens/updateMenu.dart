import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/menu.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/widgets/provider.dart';

class updateMenuPage extends StatefulWidget {
  @override
  _updateMenuPageState createState() => _updateMenuPageState();
}

class _updateMenuPageState extends State<updateMenuPage> {
  UserModel user = UserModel("", "", "", null);
  profileJualan jualan = profileJualan("");
  menuModel menu = menuModel("", "", "", null);

  TextEditingController namaController = TextEditingController();

  getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    user.uid = uid;

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .get()
        .then((result) {
      jualan.namaJualan = result.data['nama'];
    });
  }

  setDocument(String namaJualan) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    user.uid = uid;

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .setData({'nama': namaJualan});
  }

  setDocumentFromJson(Map<String, dynamic> toJson) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    user.uid = uid;

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .add(toJson);
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => sellerProfilePage()));
                }),
          ]),
      body: SingleChildScrollView(
        child: Container(
          height: _height * 0.8,
          width: _width,
          child: Padding(
            padding: EdgeInsets.all(_width * 0.08),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AutoSizeText('Nama Jualan: ',
                        maxLines: 1, style: TextStyle(fontSize: 18)),
                    IconButton(
                        icon: Icon(Icons.edit,
                            color: Colors.green[800], size: 20),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return inputDialog(
                                    'Nama jualan anda', namaController);
                              });
                        }),
                  ],
                ),
                FutureBuilder(
                    future: getDocument(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            jualan.namaJualan,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SizedBox(height: _height * 0.05),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      AutoSizeText(
                        'Menu',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      AutoSizeText(
                        'Harga',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      AutoSizeText(
                        'Satuan',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: _height * 0.05,
                  width: _width,
                  child: InkWell(
                    child: Card(
                      child: Icon(Icons.add),
                    ),
                    onTap: () {
                      try {
                        return showDialog(
                            context: context,
                            builder: (context) => inputMenu());
                      } on Exception catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: _height * 0.4,
                  width: _width,
                  child: StreamBuilder(
                    stream: getMenuStreamSnapshots(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) =>
                              buildMenuCard(
                                  context, snapshot.data.documents[index]));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getMenuStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('dataJualan').document(uid).collection('menus').snapshots();
  }

  Widget buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Text(document['namaMakanan']),
                Spacer(),
                Text(document['hargaMakanan']),
                Spacer(),
                Text(document['satuan'].toString()),
                Spacer(),
                Text(document['satuanMakanan']),
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  Dialog inputMenu() {
    TextEditingController namaMenuController = TextEditingController();
    TextEditingController hargaController = TextEditingController();
    TextEditingController satuanController = TextEditingController();

    bool showTextfield = false;

    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 350,
            padding: const EdgeInsets.all(20.0),
            color: Colors.yellow[50],
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    AutoSizeText(
                      'Nama Menu',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer()
                  ],
                ),
                TextField(
                  controller: namaMenuController,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    AutoSizeText(
                      'Harga',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer()
                  ],
                ),
                TextField(
                  controller: hargaController,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    AutoSizeText(
                      'Satuan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer()
                  ],
                ),
                Container(
                  child: Row(children: <Widget>[
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: showTextfield,
                      child: Container(
                        width: 50,
                        child: TextField(
                          controller: satuanController,
                        ),
                      ),
                    ),
                    DropdownButton<String>(
                        items: <String>['satuan', 'porsi'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == 'satuan') {
                            setState(() {
                              showTextfield = true;
                            });
                          } else if (value == 'porsi') {
                            setState(() {
                              showTextfield = false;
                            });
                          }
                        }),
                  ]),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
                    RaisedButton(
                        child: AutoSizeText(
                          'Kirim',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        ),
                        onPressed: () async {
                          try {
                            menu.namaMakanan = namaMenuController.text;
                            menu.hargaMakanan = hargaController.text;
                            menu.satuanMakanan = 'porsi';
                            menu.satuan = 0;
                            setDocumentFromJson(menu.toJson());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateMenuPage()));
                          } on Exception catch (e) {
                            print(e);
                          }
                        }),
                    SizedBox(width: 20),
                    RaisedButton(
                        child: AutoSizeText(
                          'Batal',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey[800]),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog inputDialog(String inputTitle, TextEditingController inputController) {
    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 200,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                AutoSizeText(
                  inputTitle,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: inputController,
                ),
                SizedBox(height: 30),
                Row(children: <Widget>[
                  SizedBox(width: 40),
                  RaisedButton(
                      child: AutoSizeText(
                        'Kirim',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                      onPressed: () async {
                        try {
                          jualan.namaJualan = inputController.text;
                          setDocument(jualan.namaJualan);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => updateMenuPage()));
                        } on Exception catch (e) {
                          print(e);
                        }
                      }),
                  SizedBox(width: 20),
                  RaisedButton(
                      child: AutoSizeText(
                        'Batal',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
