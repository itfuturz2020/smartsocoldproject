import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/common/Classlist.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final List<String> _residentTypeList = ["Rented", "Owner", "Owned"];

  int selected_Index;
  bool isLoading = false, verify = false, valid = false;
  String SocietyId = "";
  bool _WingLoading = false;

  List<WingClass> _winglist = [];
  WingClass _wingClass;


  ProgressDialog pr;

  String Gender = "Male";

  TextEditingController CodeControler = new TextEditingController();
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtFlatNo = new TextEditingController();

  final FocusNode _Name = FocusNode();
  final FocusNode _Mobile = FocusNode();

  String codeValue = "";

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  _CodeVerification() async {
    if (CodeControler.text != "") {
      try {
        //check Internet Connection
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          Services.Societycodeverify(CodeControler.text).then((data) async {
            setState(() {
              isLoading = false;
              verify = true;
            });
            if (data.IsSuccess == true && data.Data != "0") {
              setState(() {
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
        } else {
          setState(() {
            isLoading = false;
          });
          showHHMsg("No Internet Connection.", "");
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
  }

  _Registration() async {
    if (txtname.text != "" && txtmobile.text != "" && txtFlatNo.text != "") {
      if (selected_Index != null) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            var data = {
              'Name': txtname.text.trim(),
              'MobileNo': txtmobile.text.trim(),
              'ResidenceType': _residentTypeList[selected_Index],
              'Gender': Gender,
              'SocietyId': SocietyId,
              'WingId': _wingClass.WingId,
              'Wing': _wingClass.WingName,
              'FlatNo': txtFlatNo.text.trim(),

            };
            pr.show();
            Services.Registration(data).then((data) async {
              pr.hide();
              if (data.Data != "0" && data.IsSuccess == true) {
                showHHMsg("Registration Successfully","");
              } else {
                showHHMsg("Mobile Number Already Exist !", "");
                pr.hide();
              }
            }, onError: (e) {
              pr.hide();
              showHHMsg("Try Again.", "");
            });
          } else {
            pr.hide();
            showHHMsg("No Internet Connection.", "");
          }
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

  showHHMsg(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
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
                          height: 50,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextFormField(
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
                          "  Gender *",
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
                        padding: const EdgeInsets.only(left: 9.0, top: 10),
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
                                            ? valid
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
                                            : Padding(
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
                                              ),
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
                              keyboardType: TextInputType.phone,
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 18.0, left: 8, right: 8, bottom: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: constant.appPrimaryMaterialColor[500],
                        textColor: Colors.white,
                        splashColor: Colors.white,
                        child: Text("Register",
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
