import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hehe/model/menu.dart';
import 'package:hehe/screens/profile_seller.dart';
import 'package:hehe/widgets/customs.dart';
import 'package:hehe/widgets/provider.dart';

class updateMenuPage extends StatefulWidget {
  @override
  _updateMenuPageState createState() => _updateMenuPageState();
}

class _updateMenuPageState extends State<updateMenuPage> {
  profileJualan _jualan = profileJualan("", null);
  menuModel _menu = menuModel("", "");

  TextEditingController _namaController = TextEditingController();

  _getDocument() async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .get()
        .then((result) {
      _jualan.namaJualan = result.data['nama'];
      _jualan.tipeJualan = result.data['tipe'];
    });
  }

  _setDocument(String namaJualan) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    String docId;
    int tipe;

    await Provider.of(context)
        .db
        .collection('userData')
        .document(uid)
        .get()
        .then((result) {
      tipe = result.data['tipeUser'];
    });

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .setData({'nama': namaJualan, 'tipe': tipe});
  }

  _setDocumentFromJson(Map<String, dynamic> toJson) async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .add(toJson);
  }

  _updateDocumentFromJson(Map<String, dynamic> toJson, String uidDoc) async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .document(uidDoc)
        .setData(toJson);
  }

  _deleteDocumentFromJson(String uidDoc) async {
    final uid = await Provider.of(context).auth.getCurrentUID();

    await Provider.of(context)
        .db
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .document(uidDoc)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
          leading: null,
          toolbarHeight: _height * 0.07,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                padding: EdgeInsets.only(right: _width * 0.9),
                icon: Icon(
                  Icons.arrow_back,
                  size: 28.0,
                  color: Colors.yellow[700],
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
          width: _width,
          child: Column(
            children: <Widget>[
              SizedBox(height: _height * 0.04),
              Row(
                children: <Widget>[
                  SizedBox(width: _width * 0.04),
                  AutoSizeText('Nama Jualan: ',
                      maxLines: 1, style: TextStyle(fontSize: 18)),
                  IconButton(
                      icon:
                          Icon(Icons.edit, color: Colors.yellow[800], size: 20),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return _inputDialog(
                                  'Nama jualan anda', _namaController);
                            });
                      }),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: _width * 0.04),
                  FutureBuilder(
                    future: _getDocument(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (_jualan.namaJualan == null) {
                          return AutoSizeText('Jualan belum memiliki nama');
                        }
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(
                            _jualan.namaJualan,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: _height * 0.05),
              Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[800],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: _height * 0.05),
                      Row(
                        children: [
                          SizedBox(width: _width * 0.06),
                          AutoSizeText(
                            'Menu',
                            style:
                                TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: _width * 0.25),
                          AutoSizeText(
                            'Harga',
                            style:
                                TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: _height * 0.03),
                      Container(
                        height: _height * 0.05,
                        width: _width,
                        padding: EdgeInsets.only(left: _width * 0.05, right: _width * 0.05),
                        child: InkWell(
                          child: Card(
                            margin: EdgeInsets.all(0),
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            try {
                              return showDialog(
                                  context: context, builder: (context) => _inputMenu());
                            } on Exception catch (e) {
                              print(e);
                            }
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: _width * 0.05, right: _width * 0.05, top: _height*0.02),
                        height: _height * 0.8,
                        width: _width,
                        child: StreamBuilder(
                          stream: _getMenuStreamSnapshots(context),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());
                            return ListView.builder(
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (BuildContext context, int index) =>
                                    _buildMenuCard(
                                        context, snapshot.data.documents[index]));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getMenuStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance
        .collection('dataJualan')
        .document(uid)
        .collection('menus')
        .snapshots();
  }

  Widget _buildMenuCard(BuildContext context, DocumentSnapshot document) {
    return new SingleChildScrollView(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                AutoSizeText(document['namaMakanan'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                Spacer(),
                AutoSizeText(document['hargaMakanan'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.green[800],
                  onPressed: () {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text(
                            "Hapus " + document['namaMakanan'] + " dari menu?"),
                        actions: [
                          FlatButton(
                            child: Text("Kembali"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text("Hapus"),
                            onPressed: () {
                              String docId = document.documentID;
                              _deleteDocumentFromJson(docId);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => updateMenuPage()));
                              createSnackBar(
                                  context, 'Berhasil menghapus menu');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          onTap: () {
            showDialog(
                context: context, builder: (context) => _editMenu(document));
          },
        ),
      ),
    );
  }

  Dialog _inputMenu() {
    TextEditingController namaMenuController = TextEditingController();
    TextEditingController hargaController = TextEditingController();

    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
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
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
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
                    SizedBox(width: 20),
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
                        if (namaMenuController.text == "") {
                          warnSnackBar(context, "Nama tidak bisa kosong");
                        } else if (hargaController.text == "") {
                          warnSnackBar(context, "Harga tidak bisa kosong");
                        } else {
                          try {
                            _menu.namaMakanan = namaMenuController.text;
                            _menu.hargaMakanan = hargaController.text;
                            _setDocumentFromJson(_menu.toJson());
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateMenuPage()));
                            createSnackBar(
                                context, 'Berhasil menambahkan menu');
                          } on Exception catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog _editMenu(DocumentSnapshot document) {
    TextEditingController namaMenuController =
        TextEditingController(text: document['namaMakanan']);
    TextEditingController hargaController =
        TextEditingController(text: document['hargaMakanan']);

    return Dialog(
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
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
                  keyboardType: TextInputType.number,
                  controller: hargaController,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
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
                    SizedBox(width: 20),
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
                        if (namaMenuController.text == "") {
                          warnSnackBar(context, "Nama tidak bisa kosong");
                        } else if (hargaController.text == "") {
                          warnSnackBar(context, "Harga tidak bisa kosong");
                        } else {
                          try {
                            String docId = document.documentID;
                            _menu.namaMakanan = namaMenuController.text;
                            _menu.hargaMakanan = hargaController.text;
                            _updateDocumentFromJson(_menu.toJson(), docId);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateMenuPage()));
                            createSnackBar(context, 'Menu berhasil diubah');
                          } on Exception catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog _inputDialog(
      String inputTitle, TextEditingController inputController) {
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
                  controller: inputController,
                ),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    SizedBox(width: 40),
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
                    SizedBox(width: 20),
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
                        if (inputController.text == "") {
                          warnSnackBar(context, "Nama tidak bisa kosong");
                        } else {
                          try {
                            _jualan.namaJualan = inputController.text;
                            _setDocument(_jualan.namaJualan);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => updateMenuPage()));
                            createSnackBar(
                                context, "Nama jualan berhasil diubah");
                          } on Exception catch (e) {
                            print(e);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
