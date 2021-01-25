class Panggilan {
  String sellerId;
  String custId;
  int statusPanggilan;

  // 1 = menunggu konfirmasi penjual
  // 2 = penjual menerima pesanan
  // 3 = penjual dalam perjalanan
  // 4 = pemanggilan selesai

  // 6 = penjual menolak pesanan

  Panggilan(this.sellerId, this.custId, this.statusPanggilan);

  Map<String, dynamic> toJson() => {
    'sellerId': sellerId,
    'custId': custId,
    'statusPanggilan' : statusPanggilan,
  };
}