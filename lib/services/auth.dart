import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hehe/model/user.dart';
import 'package:hehe/screens/home_customer.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  // void _userFirebase (FirebaseUser user) async {
  //   final FirebaseUser user = await _auth.currentUser();
  //   final uid = user.uid;
  // }

  Stream<String> get onAuthStateChanged => _auth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);
  // // auth change user stream
  // Stream<UserModel> get user {
  //   return _auth.onAuthStateChanged.map((_userFirebase));
  //     //(FirebaseUser user) => _userFirebase(user));
  // }

  // sign in without account
  Future signInAnon() async {
    try {
      return await _auth.signInAnonymously();
      // FirebaseUser user = result.user;
      // return await _userFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register and sign in with phone number
  Future verificationUserWithPhone(String phone, BuildContext context) {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 0),
        verificationCompleted: (AuthCredential authCredential) {
          _auth.signInWithCredential(authCredential).then((AuthResult result) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerHomePage()));
          }).catchError((e) {
            print("error");
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
                              .then((AuthResult result) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerHomePage()));
                          }).catchError((e) {
                            print("error");
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

  // get UID
  Future<String> getCurrentUID() async {
    return (await _auth.currentUser()).uid;
  }

  // get current user
  Future getCurrentUser() async {
    return await _auth.currentUser();
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
