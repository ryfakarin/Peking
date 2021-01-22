class menuModel {

  String namaMakanan;
  String hargaMakanan;

  menuModel(
      this.namaMakanan, this.hargaMakanan);

  Map<String, dynamic> toJson() => {
    'namaMakanan': namaMakanan,
    'hargaMakanan': hargaMakanan,
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