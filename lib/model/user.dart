class UserModel {
  String uid;

  UserModel(this.uid);
}

class CustomerModel {
  String uid;
  String name;
  String password;
  String phoneNumber;
  int tipeUser;
  CustomerModel(this.uid, this.name, this.password, this.phoneNumber, this.tipeUser);

  Map<String, dynamic> toJson () => {
    'uid': uid,
    'nama': name,
    'password': password,
    'phoneNumber': phoneNumber,
  };
}

class SellerModel {
  String uid;
  String name;
  String password;
  String phoneNumber;
  int tipeUser;
  int tipePenjual;

  SellerModel(this.uid, this.name, this.password, this.phoneNumber,
      this.tipeUser, this.tipePenjual);

  Map<String, dynamic> toJson () => {
    'uid': uid,
    'nama': name,
    'password': password,
    'phoneNumber': phoneNumber,
    'tipePenjual' :tipePenjual
  };

}
