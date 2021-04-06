import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';
import 'package:hehe/screens/home_seller.dart';
import 'package:hehe/screens/home_seller_menetap.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = Firestore.instance;

  Stream<String> get onAuthStateChanged =>
      _auth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  // GET UID
  Future<String> getCurrentUID() async {
    FirebaseUser user = await _auth.currentUser();
    String userid = user.uid;
    return userid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  // sign up phone number
  Future<String> signUpUserWithPhone(
      String phone, BuildContext context, String userName, int tipeUser) {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 0),
      verificationCompleted: (AuthCredential authCredential) {
        _auth.signInWithCredential(authCredential).then((AuthResult result) {
          if (tipeUser == 0) {
            FocusScope.of(context).unfocus();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerHomePage()));
            Navigator.pop(context);
          } else if (tipeUser == 1) {
            FocusScope.of(context).unfocus();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SellerHomePage()));
            Navigator.pop(context);
          } else {
            FocusScope.of(context).unfocus();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SellerStayHomePage()));

          }
        }).catchError((e) {
          return "error";
        });
      },
      verificationFailed: (AuthException exception) {
        return 'error';
      },
      codeSent: (String verificationId, [int forceResendToken]) {
        final _codeController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Kode Verifikasi Anda"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _codeController,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red[100],
                child: Text(
                  "Kembali",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 30,
              ),
              FlatButton(
                color: Colors.lightGreen,
                child: Text("Submit"),
                textColor: Colors.white,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  var _credential = PhoneAuthProvider.getCredential(
                      verificationId: verificationId,
                      smsCode: _codeController.text.trim());
                  _auth.signInWithCredential(_credential).then(
                    (AuthResult result) async {
                      String uid = await result.user.uid;
                      createUserToDatabase(uid, userName, phone, tipeUser);
                      if (tipeUser == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerHomePage()));
                        Navigator.pop(context);
                      } else if (tipeUser == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerHomePage()));
                        Navigator.pop(context);
                      } else if (tipeUser == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SellerStayHomePage()));
                        Navigator.pop(context);
                      }
                    },
                  ).catchError(
                    (e) {
                      return "error";
                    },
                  );
                },
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("Timeout");
      },
    );
  }

  // register and sign in with phone number
  Future signInUserWithPhone(String phone, BuildContext context) {
    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: Duration(seconds: 0),
      verificationCompleted: (AuthCredential authCredential) {
        _auth.signInWithCredential(authCredential).then((AuthResult result) {
          navigateUser(phone, context);
          Navigator.pop(context);
        }).catchError((e) {
          return "error";
        });
      },
      verificationFailed: (AuthException exception) {
        return 'error';
      },
      codeSent: (String verificationId, [int forceResendToken]) {
        final _codeController = TextEditingController();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text("Kode Verifikasi Anda"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _codeController,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red[100],
                child: Text(
                  "Kembali",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 30,
              ),
              FlatButton(
                color: Colors.lightGreen,
                child: Text("Submit"),
                textColor: Colors.white,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  var _credential = PhoneAuthProvider.getCredential(
                      verificationId: verificationId,
                      smsCode: _codeController.text.trim());
                  _auth.signInWithCredential(_credential).then(
                    (AuthResult result) async {
                      navigateUser(phone, context);
                      Navigator.pop(context);
                    },
                  ).catchError(
                    (e) {
                      print("error");
                    },
                  );
                },
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        verificationId = verificationId;
        print(verificationId);
        print("Timeout");
      },
    );
  }

  // update user phone number
  // Future updateUserPhone(String phone, BuildContext context) {
  //   _auth.verifyPhoneNumber(
  //       phoneNumber: phone,
  //       timeout: Duration(seconds: 0),
  //       verificationCompleted: null,
  //       verificationFailed: null,
  //       codeSent: (verificationId, [forceResendingToken]) {
  //         final _codeController = TextEditingController();
  //         showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) => AlertDialog(
  //             title: Text("Kode Verifikasi Anda"),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 TextField(
  //                   keyboardType: TextInputType.number,
  //                   inputFormatters: <TextInputFormatter>[
  //                     FilteringTextInputFormatter.digitsOnly
  //                   ],
  //                   controller: _codeController,
  //                 )
  //               ],
  //             ),
  //             actions: <Widget>[
  //               FlatButton(
  //                 color: Colors.red[100],
  //                 child: Text(
  //                   "Kembali",
  //                   style: TextStyle(color: Colors.black),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //               SizedBox(
  //                 width: 30,
  //               ),
  //               FlatButton(
  //                 color: Colors.lightGreen,
  //                 child: Text("Submit"),
  //                 textColor: Colors.white,
  //                 onPressed: () {
  //                   final AuthCredential credential = PhoneAuthProvider.getCredential(verificationId: verificationId, smsCode: _codeController.text.trim());
  //                     //FirebaseAuth.instance.currentUser()).updatePhoneNumberCredential(credential);
  //                   var _credential = PhoneAuthProvider.getCredential(
  //                       verificationId: verificationId,
  //                       smsCode: _codeController.text.trim());
  //                   // _auth.(_credential).then(
  //                   //       (AuthResult result) async {
  //                   //     navigateUser(phone, context);
  //                   //     Navigator.pop(context);
  //                   //   },
  //                   // ).catchError(
  //                   //       (e) {
  //                   //     print("error");
  //                   //   },
  //                   // );
  //                 },
  //               ),
  //               SizedBox(
  //                 width: 30,
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //       codeAutoRetrievalTimeout: null);
  // }

  // sign out
  Future signOut() async {
    await _auth.signOut();
  }

  void navigateUser(String phoneNumber, BuildContext context) async {
    FocusScope.of(context).unfocus();
    await db
        .collection('userData')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .getDocuments()
        .then((ref) {
      if (ref.documents.length > 0) {
        if (ref.documents[0].data['tipeUser'] == 0) {
          print('pembeli');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CustomerHomePage()));
        } else if (ref.documents[0].data['tipeUser'] == 1) {
          print('penjual');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SellerHomePage()));
        } else {
          print('penjual');
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SellerStayHomePage()));
        }
      }
    });
  }

  void createUserToDatabase(
      String uidUser, String namaUser, String phoneUser, int tipeUser) async {
    UserModel userModel = new UserModel(uidUser, namaUser, phoneUser, tipeUser);

    try {
      await db
          .collection("userData")
          .document(uidUser)
          .setData(userModel.toJson());
    } on Exception catch (e) {
      print(e);
    }
  }
}
