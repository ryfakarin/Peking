import 'package:flutter/cupertino.dart';

class menuModel {

  String namaMakanan;
  String hargaMakanan;
  String satuanMakanan;
  int satuan;

  menuModel(
      @required this.namaMakanan, this.hargaMakanan, this.satuanMakanan, this.satuan);

  Map<String, dynamic> toJson() => {
    'namaMakanan': namaMakanan,
    'hargaMakanan': hargaMakanan,
    'satuanMakanan': satuanMakanan,
    'satuan' : satuan
  };

}

class profileJualan{

  String namaJualan;
  int tipeJualan;

  profileJualan(this.namaJualan, this.tipeJualan);

  Map<String, dynamic> toJson() => {
    'nama' : namaJualan,
    'tipe' : tipeJualan
  };

}