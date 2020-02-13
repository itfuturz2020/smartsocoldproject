import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/screens/HomeScreen.dart';
import 'package:smart_society_new/screens/OtpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _MobileNumber = new TextEditingController();
  bool isLoading = false;
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  List logindata = [];

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
        //check Internet Connection
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OtpScreen(data[0]["ContactNo"].toString(),data[0]["Id"].toString(),(){
                    localdata();
                  }),
                ),
              );
              Navigator.pushNamed(context, '/OtpScreen');
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
                                      Navigator.pushReplacementNamed(
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
