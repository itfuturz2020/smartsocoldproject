import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Mall_App/Common/Constant.dart' as cnst;
import 'package:smart_society_new/Mall_App/Common/services.dart' as serv;
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/LoginScreen.dart';

import 'HomeScreen.dart';
import 'OTP.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _residentTypeList = ["Rented", "Owner", "Owned"];

  int selected_Index;
  bool isLoading = false, verify = false, valid = false;
  String SocietyId = "";
  String selFlatHolderType = 'Select Residence Type';
  bool _WingLoading = false;

  List<WingClass> _winglist = [];
  List flatholdertypes=[],winglistClassList = [];
  WingClass _wingClass;

  ProgressDialog pr;

  String Gender = "";

  TextEditingController CodeControler = new TextEditingController();
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtFlatNo = new TextEditingController();

  final FocusNode _Name = FocusNode();
  final FocusNode _Mobile = FocusNode();

  String codeValue = "";
  bool isFCMtokenLoading = false;
  String fcmToken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _firebaseMessaging.getToken().then((token) {
      setState(() {
        fcmToken = token;
        print('fcm in register----------->' + '${token}');
      });
      print("fcmToken1");
      print(fcmToken);
    });
    getFlatType();
  }


  getFlatType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('madeAtleastOneWing') == "true"){
        Fluttertoast.showToast(
            msg: "Society Created Successfully",
            backgroundColor: Colors.red,
            gravity: ToastGravity.TOP,
            textColor: Colors.white);
      }
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getFlatType();
        res.then((data) async {
          if (data !=null) {
            setState(() {
              winglistClassList = data;
            });
            print("fcmToken2");
            print(fcmToken);
            for(int i=0;i<winglistClassList.length;i++){
              flatholdertypes.add(winglistClassList[i]["Type"]);
            }
            print("getFlatType=> " + winglistClassList.toString());
          }
        }, onError: (e) {
          showHHMsg("$e","");
        });
      } else {
        showHHMsg("No Internet Connection.","");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong","");
    }
  }


  _CodeVerification() async {
    if (CodeControler.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          Services.Societycodeverify(CodeControler.text).then((data) async {
            setState(() {
              isLoading = false;
            });
            if (data.IsSuccess == true && data.Data != "0") {
              setState(() {
                verify = true;
                SocietyId = data.Data;
                valid = true;
                _WingListData(data.Data);
              });
            } else {
              setState(() {
                valid = false;
              });
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
    }
  }

  _checkNumber(String mobileNo,String societyId) async {
    if (CodeControler.text != "") {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          pr.show();
          Services.checkNumber(mobileNo,societyId).then((data) async {
            setState(() {
              isLoading = false;
            });
            pr.hide();
            print(data);
            if (data["Data"].toString() == "1") {
              print("old number");
              setState(() {
                Fluttertoast.showToast(
                    msg: "Mobile Number Already Exist Please Login",
                    toastLength: Toast.LENGTH_LONG,
                backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white,
                );
              });
            } else {
              print("new number");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTP(
                      mobileNo: txtmobile.text.toString(),
                      onSuccess: () => _Registration(),
                    ),
                  ),
              );
            }
          }, onError: (e) {
            setState(() {
              isLoading = false;
            });
            showHHMsg("Something Went Wrong", "Error");
          });
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
    }
  }

  _WingListData(String SocietyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetWinglistData(SocietyId);
        setState(() {
          _WingLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _WingLoading = false;
              _winglist = data;
            });

          } else {
            setState(() {
              _WingLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _WingLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  _OnWingSelect(val) {
    setState(() {
      print(val.WingName);
      _wingClass = val;
    });
    print("_wingClass");
    print(_wingClass.WingId);
  }

  _Registration() async {
    if (txtname.text != "" && txtmobile.text != "" && txtFlatNo.text != "") {
      if (selFlatHolderType!="Select Residence Type") {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            String gen = Gender;
            if (Gender == "") {
              gen = "Male";
            }
            print("societyid inside registration");
            print(SocietyId);
            var data = {
              'Name': txtname.text.trim(),
              'MobileNo': txtmobile.text.trim(),
              'ResidenceType': selFlatHolderType,
              'Gender': gen,
              'SocietyId': SocietyId,
              'WingId': _wingClass.WingId,
              'Wing': _wingClass.WingName,
              'FlatNo': txtFlatNo.text.trim(),
            };
            print("Body: ${data}");
            //==============================
            pr.show();
            Services.Registration(data).then((data) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                print("txtname.text");
                print(fcmToken);
                prefs.setString(constant.Session.selFlatHolderType, selFlatHolderType);
                // showHHMsg("Registration Successfully", "");
                Fluttertoast.showToast(
                    msg: "Registration Successfully",
                    toastLength: Toast.LENGTH_LONG);
                _Mallregistration();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/LoginScreen', (route) => false);
              } else {
                showHHMsg("Mobile Number Already Exist !", "");
                pr.hide();
              }
            }, onError: (e) {
              pr.hide();
              showHHMsg("Try Again.", "");
            });
          }
          //===========================
        } on SocketException catch (_) {
          showHHMsg("No Internet Connection.", "");
        }
      } else {
        Fluttertoast.showToast(
            msg: "Please Select Resident Type", toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please fill all Fields", toastLength: Toast.LENGTH_LONG);
    }
  }

  //by rinki for registration for mall app

  saveDataToSession(var data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        cnst.Session.customerId, data["CustomerId"].toString());
    await prefs.setString(cnst.Session.CustomerName, data["CustomerName"]);
    await prefs.setString(
        cnst.Session.CustomerEmailId, data["CustomerEmailId"]);
    await prefs.setString(
        cnst.Session.CustomerPhoneNo, data["CustomerPhoneNo"]);
  }

  _Mallregistration() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        FormData body = FormData.fromMap({
          "CustomerName": txtname.text,
          "CustomerEmailId": "",
          "CustomerPhoneNo": txtmobile.text.toString(),
          "CutomerFCMToken": "${fcmToken}"
        });
        serv.Services.postforlist(apiname: 'addCustomer', body: body).then(
            (responselist) async {
          if (responselist.length > 0) {
            saveDataToSession(responselist[0]);
          } else {
            Fluttertoast.showToast(msg: " Registration fail");
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("error on call -> ${e.message}");
          Fluttertoast.showToast(msg: "something went wrong");
        });
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "No Internet Connection");
    }
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
                Navigator.pushReplacementNamed(context, "/LoginScreen");
              },
            ),
          ],
        );
      },
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // _getWingsBySocietyId() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty && CodeControler.text!="") {
  //       Future res = Services.GetWingsBySocietyId(CodeControler.text.toString());
  //       res.then((data) async {
  //         if (data != null && data.length > 0) {
  //           setState(() {
  //             winglistClassList = data;
  //           });
  //           for(int i=0;i<winglistClassList.length;i++){
  //           }
  //           print("servicelisttt=> " + winglistClassList.toString());
  //         }
  //       }, onError: (e) {
  //         showHHMsg("$e","");
  //         // setState(() {
  //         //   winglistLoading = false;
  //         // });
  //       });
  //     } else {
  //       showHHMsg("No Internet Connection.","");
  //     }
  //   } on SocketException catch (_) {
  //     showHHMsg("Something Went Wrong","");
  //     // setState(() {
  //     //   winglistLoading = false;
  //     // });
  //   }
  // }

  List logindata = [];
  List mallLoginList = [];
  String sendOTP;

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

  _MallLoginApi() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        FormData body = FormData.fromMap({
          "CustomerPhoneNo": txtmobile.text,
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
                // setState(() {
                //   isLoading = false;
                // });
                // Fluttertoast.showToast(msg: "Data Not Found");
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

  _checkLogin() async {
    if (txtmobile.text != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            pr.show();
          });
          Services.MemberLogin(txtmobile.text).then((data) async {
            pr.hide();
            if (data != null && data.length > 0) {
              setState(() {
                logindata = data;
              });
              // _MallLoginApi();
              if (sendOTP == "0") {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      data[0]["ContactNo"].toString(),
                      data[0]["Id"].toString(), () {
                      localdata();
                      mallLocalData();
                    },
                    ),
                  ),
                );*/
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

  bool mobileNoExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/applogo.png', width: 80, height: 80),
                  Text(
                    "Register Now",
                    style: TextStyle(
                        color: constant.appPrimaryMaterialColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 10),
                        child: Text(
                          "  Name *",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              focusNode: _Name,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context, _Name, _Mobile);
                              },
                              controller: txtname,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Your Full Name",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 15),
                        child: Text(
                          "  Mobile Number *",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 70,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
                              maxLength: 10,
                              textInputAction: TextInputAction.done,
                              focusNode: _Mobile,
                              controller: txtmobile,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Your Mobile Number",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 10),
                        child: Text(
                          "  Gender",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Row(
                      children: <Widget>[
                        Radio(
                            value: 'Male',
                            groupValue: Gender,
                            onChanged: (value) {
                              setState(() {
                                Gender = value;
                                print(Gender);
                              });
                            }),
                        Text("Male", style: TextStyle(fontSize: 13)),
                        Radio(
                            value: 'Female',
                            groupValue: Gender,
                            onChanged: (value) {
                              setState(() {
                                Gender = value;
                                print(Gender);
                              });
                            }),
                        Text("Female", style: TextStyle(fontSize: 13))
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 10,bottom: 7),
                        child: Text(
                          "  Select Residence Type *",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
/*
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      children:
                          List.generate(_residentTypeList.length, (index) {
                        return ChoiceChip(
                          backgroundColor: Colors.grey[200],
                          label: Text(_residentTypeList[index]),
                          selected: selected_Index == index,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selected_Index = index;
                                print(_residentTypeList[index]);
                              });
                            }
                          },
                        );
                      }),
                    ),
                  ),
*/
                  Padding(
                    padding: const EdgeInsets.only(left:16.0,right: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 8.0, top: 6.0),
                          child: DropdownButton<dynamic>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selFlatHolderType,
                            style: TextStyle(fontSize: 14),
                            ),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              setState(() {
                                selFlatHolderType = val;
                              });
                            },
                            //value: selCity,
                            items: flatholdertypes.map<DropdownMenuItem<dynamic>>(
                                    (dynamic value) {
                                  return DropdownMenuItem<dynamic>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: new TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 10),
                        child: Text(
                          "  Society Code *",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 6.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: CodeControler,
                              keyboardType: TextInputType.number,
                              onChanged: (text) {
                                setState(() {
                                  codeValue = text;
                                  _wingClass = null;
                                  _winglist = [];
                                  verify = false;
                                });
                                if(text.length == 5){
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _CodeVerification();
                                }
                              },
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Enter Society Code",
                                  hintStyle: TextStyle(fontSize: 13),
                                  suffixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              strokeWidth: 4,
                                            )
                                          : verify
                                              // ? valid
                                              ? Image.asset(
                                                  'images/success.png',
                                                  width: 18,
                                                  height: 18,
                                                )
                                              : Image.asset(
                                                  'images/error.png',
                                                  width: 20,
                                                  height: 20,
                                                )
                                      /*: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0, right: 8.0),
                                                child: GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                      _CodeVerification();
                                                    },
                                                    child: codeValue.length > 0
                                                        ? Text(
                                                            "Verify",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: constant
                                                                    .appPrimaryMaterialColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )
                                                        : Text("")),
                                              ),*/
                                      )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _WingLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        )
                      : _winglist.length > 0
                          ? Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 9.0, top: 15),
                                      child: Text(
                                        " Select Wing *",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18.0, top: 8),
                                        child: SizedBox(
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width) /
                                              2,
                                          height: 40,
                                          child: InputDecorator(
                                            decoration: new InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                fillColor: Colors.white,
                                                border: new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10),
                                                  //borderSide: new BorderSide(),
                                                )),
                                            child: DropdownButtonHideUnderline(
                                                child:
                                                    DropdownButton<WingClass>(
                                              hint: _winglist != null &&
                                                      _winglist != "" &&
                                                      _winglist.length > 0
                                                  ? Text("Select Wing",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w600))
                                                  : Text(
                                                      "Wing Not Found",
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                              value: _wingClass,
                                              onChanged: (val) {
                                                _OnWingSelect(val);
                                              },
                                              items: _winglist
                                                  .map((WingClass wingclass) {
                                                return new DropdownMenuItem<
                                                    WingClass>(
                                                  value: wingclass,
                                                  child: Text(
                                                    wingclass.WingName,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                );
                                              }).toList(),
                                            )),
                                          ),
                                        )),
                                  ],
                                )
                              ],
                            )
                          : Container(),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 9.0, top: 15),
                        child: Text(
                          "  Flat No *",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: txtFlatNo,
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(5.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  hintText: "Your Flat Number",
                                  hintStyle: TextStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /* Padding(
                    padding: const EdgeInsets.only(
                        top: 18.0, left: 8, right: 8, bottom: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: constant.appPrimaryMaterialColor[700],
                        textColor: Colors.white,
                        splashColor: Colors.white,
                        child: Text("Join Your Society",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        onPressed: valid
                            ? () {
//                                Navigator.pushReplacementNamed(
//                                    context, '/LoginScreen');
                                _Registration();
                              }
                            : null,
                      ),
                    ),
                  ),*/
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: constant.appPrimaryMaterialColor[500],
                        textColor: Colors.white,
                        splashColor: Colors.white,
                        child: Text(
                            "Join Your Society",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600,
                            ),
                        ),
                        onPressed: valid
                            ? () {
                          if(txtname.text != "" &&
                              txtmobile.text != "" &&
                              txtFlatNo.text != ""){
                            _checkNumber(txtmobile.text, SocietyId);
                          }
                          else{
                            Fluttertoast.showToast(
                                msg: "Fields Can't be empty",
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.white);
                          }
//                                Navigator.pushReplacementNamed(
//                                    context, '/LoginScreen');
                        }
                            : null,
                       /* onPressed: (){
                        valid
                              ?
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTP(
                                mobileNo: txtmobile.text,
                                onSuccess: () {
                                  _checkLogin();
                                },
                              ),
                            ),\

                          ):null;
                          () {
                             Navigator.pushReplacementNamed(
                                 context, '/LoginScreen');
                              _Registration();
                            }
                        }*/
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 8, right: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: constant.appPrimaryMaterialColor[500],
                        textColor: Colors.white,
                        splashColor: Colors.white,
                        child: Text("Create Your Society",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/CreateSociety');
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Aleady Have an Account?"),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/LoginScreen');
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    color:
                                        constant.appPrimaryMaterialColor[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
