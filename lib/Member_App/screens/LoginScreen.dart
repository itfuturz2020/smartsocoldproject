import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart' as cnst;
import 'package:smart_society_new/Mall_App/Common/services.dart' as serv;
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/HomeScreen.dart';
import 'package:smart_society_new/Member_App/screens/OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _MobileNumber = new TextEditingController();
  bool isLoading = false;
  ProgressDialog pr;
  String sendOTP;
  List logindata = [];
  List mallLoginList = [];

  bool isFCMtokenLoading = false;
  String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    getOTPStatus();

    _firebaseMessaging.getToken().then((token) {
      setState(() {
        fcmToken = token;
      });
      print('----------->' + '${token}');
    });
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    permissionValidator.camera();
  }

  getOTPStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetOTPStatus();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              sendOTP = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              sendOTP = data;
            });
          }
          print("data: ${sendOTP}");
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  mallLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        cnst.Session.customerId, mallLoginList[0]["CustomerId"].toString());
    await prefs.setString(
        cnst.Session.CustomerName, mallLoginList[0]["CustomerName"]);
    await prefs.setString(
        cnst.Session.CustomerEmailId, mallLoginList[0]["CustomerEmailId"]);
    await prefs.setString(
        cnst.Session.CustomerPhoneNo, mallLoginList[0]["CustomerPhoneNo"]);
  }

  localdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        constant.Session.session_login, logindata[0]["ContactNo"].toString());
    await prefs.setString(
        constant.Session.Member_Id, logindata[0]["Id"].toString());
    await prefs.setString(
        constant.Session.SocietyId, logindata[0]["SocietyId"].toString());
    await prefs.setString(
        constant.Session.IsVerified, logindata[0]["IsVerified"].toString());
    await prefs.setString(
        constant.Session.Profile, logindata[0]["Image"].toString());
    await prefs.setString(constant.Session.ResidenceType,
        logindata[0]["ResidenceType"].toString());
    await prefs.setString(
        constant.Session.FlatNo, logindata[0]["FlatNo"].toString());
    await prefs.setString(
        constant.Session.Name, logindata[0]["Name"].toString());
    await prefs.setString(
        constant.Session.CompanyName, logindata[0]["CompanyName"].toString());
    await prefs.setString(
        constant.Session.Designation, logindata[0]["Designation"].toString());
    await prefs.setString(constant.Session.BusinessDescription,
        logindata[0]["BusinessDescription"].toString());
    await prefs.setString(
        constant.Session.BloodGroup, logindata[0]["BloodGroup"].toString());
    await prefs.setString(
        constant.Session.Gender, logindata[0]["Gender"].toString());
    await prefs.setString(constant.Session.DOB, logindata[0]["DOB"].toString());
    await prefs.setString(
        constant.Session.Address, logindata[0]["Address"].toString());
    await prefs.setString(
        constant.Session.isPrivate, logindata[0]["IsPrivate"].toString());
    await prefs.setString(
        constant.Session.Wing, logindata[0]["Wing"].toString());
    await prefs.setString(
        constant.Session.WingId, logindata[0]["WingId"].toString());
    await prefs.setString(
        constant.Session.ParentId, logindata[0]["ParentId"].toString());
    await prefs.setString(
        constant.Session.Profile, logindata[0]["Image"].toString());
  }

  _checkLogin() async {
    if (_MobileNumber.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            pr.show();
          });

          Services.MemberLogin(_MobileNumber.text).then((data) async {
            pr.hide();
            if (data != null && data.length > 0) {
              setState(() {
                logindata = data;
              });
              if (sendOTP == "0") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                        data[0]["ContactNo"].toString(),
                        data[0]["Id"].toString(), () {
                      localdata();
                      mallLocalData();
                    }),
                  ),
                );
                _MallLoginApi();
              } else {
                await localdata();
                // await mallLocalData();
                Navigator.pushAndRemoveUntil(context,
                    SlideLeftRoute(page: HomeScreen()), (route) => false);
                _MallLoginApi();

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/HomeScreen', (Route<dynamic> route) => false);
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Incorrect Mobile Number",
                  toastLength: Toast.LENGTH_LONG,
                  textColor: Colors.white,
                  gravity: ToastGravity.TOP,
                  backgroundColor: Colors.red);
            }
          }, onError: (e) {
            pr.hide();
            showHHMsg("Try Again.", "");
          });
        } else {
          setState(() {
            isLoading = false;
            pr.hide();
          });
          showHHMsg("No Internet Connection.", "");
        }
      } on SocketException catch (_) {
        pr.hide();
        showHHMsg("No Internet Connection.", "");
      }
    } else
      Fluttertoast.showToast(
          msg: "Enter Your Mobile Number",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  }

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _MallLoginApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData body = FormData.fromMap({
          "CustomerPhoneNo": _MobileNumber.text,
          "CutomerFCMToken": "${fcmToken}"
        });
        serv.Services.postforlist(apiname: 'signIn', body: body).then(
            (responseList) async {
          if (responseList.length > 0) {
            setState(() {
              mallLoginList = responseList;
              mallLocalData();
            });
            // mallLocalData();
          } else {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Data Not Found");
            //show "data not found" in dialog
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 110.0),
          child: Container(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset('images/applogo.png',
                                  width: 90, height: 90),
                            ],
                          ),
                        ),
                        Text("Welcome User",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                                color: constant.appPrimaryMaterialColor)),
                        Text("Login with Mobile Number to Continue",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: constant.appPrimaryMaterialColor)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 180.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
//                  Text(
//                    "Welcome to,\nMy Genie",
//                    style: TextStyle(
//                        fontWeight: FontWeight.w600,
//                        fontSize: 24,
//                        color: Color.fromRGBO(81, 92, 111, 1)),
//                  ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 10.0, right: 10.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 8.0, top: 6.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 50,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: _MobileNumber,
                                            maxLength: 10,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                counterText: "",
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: constant
                                                                .appPrimaryMaterialColor[
                                                            600])),
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          5.0),
                                                  borderSide: new BorderSide(),
                                                ),
                                                hintText: "Your Mobile Number",
                                                hintStyle:
                                                    TextStyle(fontSize: 13)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 18.0, left: 8, right: 8),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 45,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color:
                                          constant.appPrimaryMaterialColor[500],
                                      textColor: Colors.white,
                                      splashColor: Colors.white,
                                      child: Text("Login",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600)),
                                      onPressed: () {
                                        _checkLogin();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 35.0, bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't Have an Account?"),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/RegisterScreen');
                                    },
                                    child: Text("Register",
                                        style: TextStyle(
                                            color: constant
                                                .appPrimaryMaterialColor[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )));
  }
}
