import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';

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

  // sign in without account
  Future signInAnon() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign up phone number
  Future <String> signUpUserWithPhone(String phone, BuildContext context, String userName, int tipeUser) {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((AuthResult result) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerHomePage()));
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
                    color: Colors.lightGreen,
                    child: Text("Submit"),
                    textColor: Colors.white,
                    onPressed: () {
                      var _credential = PhoneAuthProvider.getCredential(
                          verificationId: verificationId,
                          smsCode: _codeController.text.trim());
                      _auth
                          .signInWithCredential(_credential)
                          .then((AuthResult result) async {
                            String uid = await result.user.uid;
                            createUserToDatabase(uid, userName, phone, tipeUser);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerHomePage()));
                      }).catchError((e) {
                        return "error";
                      });
                    },
                  )
                ],
              ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
  }

  // register and sign in with phone number
  Future <String> signInUserWithPhone(String phone, BuildContext context) {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((AuthResult result) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerHomePage()));
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
                        color: Colors.lightGreen,
                        child: Text("Submit"),
                        textColor: Colors.white,
                        onPressed: () {
                          var _credential = PhoneAuthProvider.getCredential(
                              verificationId: verificationId,
                              smsCode: _codeController.text.trim());
                          _auth
                              .signInWithCredential(_credential)
                              .then((AuthResult result) async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerHomePage()));
                              }).catchError((e) {
                            return "error";
                          });
                        },
                      )
                    ],
                  ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          print(verificationId);
          print("Timeout");
        });
  }


  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void createUserToDatabase(String uidUser, String namaUser, String phoneUser, int tipeUser) async {

    UserModel userModel = new UserModel(uidUser, namaUser, phoneUser, tipeUser);

    try {
      await db.collection("userData").document(uidUser).collection("profileData").add(userModel.toJson());
    } on Exception catch (e) {
      print(e);
    }
  }

}
