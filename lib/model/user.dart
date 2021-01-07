class UserModel {
  String uid;
  String name;
  String phoneNumber;
  int tipeUser;

  UserModel({this.uid, this.name, this.phoneNumber, this.tipeUser});

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'nama': name,
        'phoneNumber': phoneNumber,
      };
}
