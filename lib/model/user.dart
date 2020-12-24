class UserModel {
  String _uid;

  UserModel(this._uid);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

}

class CustomerModel {
  String _uid;
  String _name;
  String _password;
  String _phoneNumber;

  CustomerModel(this._uid, this._name, this._password, this._phoneNumber);

  String get uid => _uid;
  set uid(String value) {
    _uid = value;
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  String get password => _password;
  set password(String value) {
    _password = value;
  }

  String get phoneNumber => _phoneNumber;
  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  Map<String, dynamic> toJson () => {
    'uid': uid,
    'nama': name,
    'password': password,
    'phoneNumber': phoneNumber,
  };
}

class SellerModel {
  String _uid;
  String _name;
  String _password;
  String _phoneNumber;
  String _tipePenjual;

  SellerModel(this._uid, this._name, this._password, this._phoneNumber,
      this._tipePenjual);

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get tipePenjual => _tipePenjual;

  set tipePenjual(String value) {
    _tipePenjual = value;
  }
}
