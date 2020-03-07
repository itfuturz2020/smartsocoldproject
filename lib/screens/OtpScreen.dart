import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/component/LoadingComponent.dart';

class OtpScreen extends StatefulWidget {
  String MobileNo, Id;
  Function onsuccess;

  OtpScreen(this.MobileNo, this.Id, this.onsuccess);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController controller = new TextEditingController();
  var rndnumber = "";
  bool isLoading = false;

  @override
  void initState() {
    _getLocaldata();
  }

  _getLocaldata() async {
    _sendVerificationCode(widget.MobileNo);
  }

  _sendVerificationCode(String Mobile) async {
    try {
      var rnd = new Random();
      setState(() {
        rndnumber = "";
      });
      for (var i = 0; i < 4; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      print(rndnumber);
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.SendVerficationCode(Mobile, rndnumber).then((data) async {
          if (data.Data == "ok" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("My Jini ", "Try again");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on otp $e");
          showMsg("My Jini ", "Try again");
          setState(() {});
        });
      } else {
        showMsg("My Jini ", "No internet connection");
      }
    } on SocketException catch (_) {
      showMsg("My Jini ", "No internet connection");
    }
  }

  _MemberVerification() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.Checkverification(widget.Id).then((data) async {
          if (data.Data == "1" && data.IsSuccess == true) {
            setState(() {
              isLoading = false;
            });
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(constant.Session.IsVerified, "true");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/HomeScreen', (Route<dynamic> route) => false);
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg("My Jini ", "Try again");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on otp $e");
          showMsg("My Jini ", "Try again");
          setState(() {});
        });
      } else {
        showMsg("My Jini ", "No internet connection");
      }
    } on SocketException catch (_) {
      showMsg("My Jini ", "No internet connection");
    }
  }

  showMsg(String title, String msg) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? LoadingComponent()
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Image.asset('images/verify.png', width: 100),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Verifying Your Number !",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600))),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("We Have Sent an OTP on Your number",
                              style: TextStyle(fontSize: 17))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: PinCodeTextField(
                        autofocus: false,
                        controller: controller,
                        highlight: true,
                        highlightColor: constant.appPrimaryMaterialColor[500],
                        defaultBorderColor: Colors.grey,
                        hasTextBorderColor:
                            constant.appPrimaryMaterialColor[500],
                        maxLength: 4,
                        onDone: (text) {
                          setState(() {
                            controller.text = text;
                          });
                          print("DONE ${controller.text}");
                        },
                        wrapAlignment: WrapAlignment.center,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                        pinTextStyle: TextStyle(fontSize: 30.0),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: 100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "If you didn't receive a code ?",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              _sendVerificationCode(widget.MobileNo);
                            },
                            child: Text(" Resend",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    color: constant.appPrimaryMaterialColor)),
                          ),
                        ],
                      ),
                    ),
//              Padding(
//                padding: const EdgeInsets.only(top: 20.0,bottom: 10),
//                child: SizedBox(
//                  width: MediaQuery.of(context).size.width/2,
//                  height: 50,
//                  child: RaisedButton(
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(5)),
//                    color: constant.appPrimaryMaterialColor[500],
//                    textColor: Colors.white,
//                    child: Text("Verify",
//                        style: TextStyle(
//                            fontSize: 18, fontWeight: FontWeight.w600)),
//                    onPressed: () {
//
//                      Navigator.pushReplacementNamed(context, '/HomeScreen');
//
//                    },
//                  ),
//                ),
//              ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          if (controller.text == rndnumber) {
                            widget.onsuccess();
                            _MemberVerification();
                          } else
                            Fluttertoast.showToast(
                                msg: "Wrong OTP..",
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.red);
                        },
                        child: Container(
                          child: Center(
                            child: Text("Verify",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white)),
                          ),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                              color: constant.appPrimaryMaterialColor[700],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
