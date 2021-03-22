import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Services.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';
import 'package:smart_society_new/Admin_App/Component/StaffComponentBywing.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;

class StaffInOut extends StatefulWidget {
  @override
  _StaffInOutState createState() => _StaffInOutState();
}

class _StaffInOutState extends State<StaffInOut> {
  bool isLoading = false, isStaffLoading = false;
  List _StaffData = [];
  List _wingList = [];

  String month = "", selectedWing = "";
  String _format = 'yyyy-MMMM-dd';
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;
  DateTime _fromDate;
  DateTime _toDate;

  @override
  void initState() {
    _fromDate = DateTime.now();
    _toDate = DateTime.now();
    _getWing();
  }

  _getWing() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getVisitorCountByWing();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _wingList = data;
              isLoading = false;
              selectedWing = data[0]["Id"].toString();
            });
            getStaffData(DateTime.now().toString(), DateTime.now().toString(),
                data[0]["Id"].toString());
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
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
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  getStaffData(String fromDate, String toDate, wingId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getStaffByWing(wingId, fromDate, toDate);
        setState(() {
          isStaffLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _StaffData = data;
              isStaffLoading = false;
            });
          } else {
            setState(() {
              _StaffData = data;
              isStaffLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isStaffLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  void _showFromDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _fromDate = dateTime;
        });
      },
    );
  }

  void _showToDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text('Done', style: TextStyle(color: Colors.red)),
        cancel: Text('cancel', style: TextStyle(color: Colors.cyan)),
      ),
      initialDateTime: DateTime.now(),
      dateFormat: _format,
      locale: _locale,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _toDate = dateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Staffs",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          ),
        ),
        body: isLoading
            ? LoadingComponent()
            : Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < _wingList.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            if (selectedWing != _wingList[i]["Id"].toString()) {
                              setState(() {
                                selectedWing = _wingList[i]["Id"].toString();
                              });
                              setState(() {
                                _StaffData = [];
                              });
                              getStaffData(
                                _fromDate.toString(),
                                _toDate.toString(),
                                _wingList[i]["Id"].toString(),
                              );
                            }
                          },
                          child: Container(
                            width: selectedWing == _wingList[i]["Id"].toString()
                                ? 60
                                : 45,
                            height:
                                selectedWing == _wingList[i]["Id"].toString()
                                    ? 60
                                    : 45,
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            decoration: BoxDecoration(
                                color: selectedWing ==
                                        _wingList[i]["Id"].toString()
                                    ? cnst.appPrimaryMaterialColor
                                    : Colors.white,
                                border: Border.all(
                                    color: cnst.appPrimaryMaterialColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            alignment: Alignment.center,
                            child: Text(
                              "${_wingList[i]["WingName"]}",
                              style: TextStyle(
                                  color: selectedWing ==
                                          _wingList[i]["Id"].toString()
                                      ? Colors.white
                                      : cnst.appPrimaryMaterialColor,
                                  fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _showFromDatePicker();
                              },
                              child: Container(
                                height: 37,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Text(
                                      "${_fromDate.toString().substring(8, 10)}-${_fromDate.toString().substring(5, 7)}-${_fromDate.toString().substring(0, 4)}",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 5)),
                                    Container(
                                      width: 50,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: cnst.appPrimaryMaterialColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text("To ",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              height: 37,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    "${_toDate.toString().substring(8, 10)}-${_toDate.toString().substring(5, 7)}-${_toDate.toString().substring(0, 4)}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  GestureDetector(
                                    onTap: () {
                                      _showToDatePicker();
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: cnst.appPrimaryMaterialColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                      child: Icon(
                                        Icons.date_range,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Expanded(
                          child: RaisedButton(
                              color: cnst.appPrimaryMaterialColor,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                getStaffData(_fromDate.toString(),
                                    _toDate.toString(), selectedWing);
                              }),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  isStaffLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: _StaffData.length > 0
                              ? Container(
                                  child: AnimationLimiter(
                                    child: ListView.builder(
                                      itemCount: _StaffData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return StaffComponentBywing(
                                            _StaffData[index], index);
                                      },
                                    ),
                                  ),
                                )
                              : NoDataComponent(),
                        ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AddStaff');
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: cnst.appPrimaryMaterialColor,
        ),
      ),
    );
  }
}
