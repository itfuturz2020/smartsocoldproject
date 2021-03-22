import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Admin_App/Screens/Dashboard.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
// import 'package:smart_society_new/Member_App/common/constant.dart';

class AddMyResidents extends StatefulWidget {
  Function onAddMyResidents;
  String mobileNo;
  bool isUpdate=false;
  AddMyResidents({this.onAddMyResidents,this.mobileNo,this.isUpdate});
  @override
  _AddMyResidentsState createState() => _AddMyResidentsState();
}

class _AddMyResidentsState extends State<AddMyResidents> {
  String stataName, cityName, societyName, buildingName,memberId;
  String flatHolder;
  TextEditingController txtFloorNo = TextEditingController();
  TextEditingController txtFlatNo = TextEditingController();
  List stateData = [];
  String stateId;
  List cityData = [];
  String cityId;
  List societyData = [];
  String societyId;
  List wingData = [],memberDetails = [];
  List<String> societies = [];
  String wingId;
  List flatData = [];
  List<String> wings = [];
  List<String> flats = [];
  String flatId;
  List<String> states = [], cities = [],flatholdertypes = [];
  String selState = 'Select your State',
      selCity = 'Select your City',
      selSociety = 'Select your Society',
      selWing = 'Select your Building',
      selFlat = 'Select your Flat Number',
      selFlatHolderType = 'Select flat type';
  bool isLoading = false;


  @override
  void initState() {
    getStateList();
    print("widget.isUpdate");
    print(widget.isUpdate);
    widget.isUpdate == null ? null:_showDialog();
    getFlatType();
    // getSocietyList();
    // getSocietyWingList();
  }

  List winglistClassList = [];

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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

  getFlatType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getFlatType();
        res.then((data) async {
          if (data !=null) {
            setState(() {
              winglistClassList = data;
            });
            for(int i=0;i<winglistClassList.length;i++){
              flatholdertypes.add(winglistClassList[i]["Type"]);
            }
            print("getFlatType=> " + winglistClassList.toString());
          }
        }, onError: (e) {
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
    }
  }

  TextEditingController txtSocietyId = new TextEditingController();

  _showDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: new Text("My Jini"),
            content:  TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your society code',
              ),
              keyboardType: TextInputType.number,
              onEditingComplete: (){
                if(txtSocietyId.text==""){
                  Fluttertoast.showToast(
                      msg: "Please enter society code",
                      backgroundColor: Colors.green,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                }
                else{
                  getSocietyDetails(txtSocietyId.text);
                }
              },
              controller: txtSocietyId,
            ),
          ),
        );
      },
    );
  }


  getStateList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetStates().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              stateData = data;
              for (int i = 0; i < stateData.length; i++) {
                states.add(stateData[i]['Name']);
                states.sort();
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  getCityList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetCities(stateId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              cityData = data;
              for (int i = 0; i < cityData.length; i++) {
                cities.add(cityData[i]['Name']);
                cities.sort();
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  getSocietyList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetSocietyList(cityId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              societyData = data;
              for (int i = 0; i < societyData.length; i++) {
                societies.add(societyData[i]['Name']);
                societies.sort();
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  List list = [];

  _getFlatNumber(wingid,societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetFlatNumber(societyId, wingid);
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              list = data;
              isLoading = false;
            });
            print("GetSocietyName => " + list.toString());
          } else {
            setState(() {
              list = [];
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          print("Error : on GetSocietyName Data Call $e");
          showMsg("$e");
        });
      } else {
        showMsg("Something went Wrong!");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getSocietyWingList({String Idsociety}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetSocietyWingDetails(Idsociety==null ? societyId:Idsociety).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              wingData = data;
              for (int i = 0; i < wingData.length; i++) {
                wings.add(wingData[i]['WingName']);
                wings.sort();
              }
            });
            widget.isUpdate != null ? Navigator.of(context).pop():null;
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }


  getSocietyDetails(String societycode) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetSocietymemberDetails(societycode).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              memberDetails = data;
              selSociety = memberDetails[0]["Name"];
              selState = memberDetails[0]["State"];
              selCity = memberDetails[0]["City"];
              societyId = memberDetails[0]["Id"];
            });
            getSocietyWingList(Idsociety :memberDetails[0]["Id"] );
            print(selSociety);
            print("memberDetails");
            print(memberDetails);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  getSocietyFlatList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetSocietyFlatDetails(wingId, societyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              flatData = data;
              for (int i = 0; i < flatData.length; i++) {
                flats.add(flatData[i]['FlatNo'].toString());
                flats.sort();
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  addMemberDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String name, mobile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        name = prefs.getString(constant.Session.Name);
        mobile = prefs.getString(constant.Session.session_login);
        Services.InsertMemberData(
                name, mobile, txtFlatNo.text, wingId, societyId, flatHolder)
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data == "1") {
            showHHMsg("Data Updated Successfully", "");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
    }
  }

  List logindata=[];

  _checkLogin() async {
    if (widget.mobileNo != '') {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          Services.MemberLogin(widget.mobileNo).then((data) async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (data != null && data.length > 0) {
              setState(() {
                memberId = data[0]["Id"].toString();
                logindata = data;
              });
              print('data[0]["Name"]');
              print(data[0]["Name"]);
              widget.isUpdate != null ? updateMemberDetails(
                logindata[0]["SocietyId"].toString(),
                  data[0]["Name"],
                logindata[0]["ContactNo"],
                logindata[0]["FlatNo"],
                logindata[0]["WingId"].toString(),
                selFlatHolderType,
                logindata[0]["Id"].toString(),
                fcmToken: ""
              ):
              addMemberDetails();
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

  updateMemberDetails(String societyId,String name,String mobileNo,String flatNo,String wingId,String flatType,String memberId,{String fcmToken}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String mobile;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        mobile = prefs.getString(constant.Session.session_login);
        Services.updateMemberDetails(
            societyId, name, mobileNo, flatNo, wingId,selFlatHolderType,memberId,fcmToken: "")
            .then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data == "1") {
            showHHMsg("Data Updated Successfully", "");
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showHHMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showHHMsg("No Internet Connection.", "");
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
                Navigator.of(context).pop();
                widget.onAddMyResidents();
              },
            ),
          ],
        );
      },
    );
  }

  // showMsg(String msg) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: new Text("Error"),
  //         content: new Text(msg),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text("Okay"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: Text(
          'Add Flat/Villa',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select State",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showStateDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               stataName == "" || stataName == null
                    //                   ? "Select State "
                    //                   : stataName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selState),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              cities = [];
                              for (int i = 0; i < stateData.length; i++) {
                                if (stateData[i]["Name"] == val.toString()) {
                                  stateId = stateData[i]["Id"].toString();
                                }
                              }
                              print('state id${stateId}');
                              setState(() {
                                selState = val;
                              });
                              getCityList();
                            },
                            //value: selState,
                            items: states.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select City",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showCityDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               cityName == "" || cityName == null
                    //                   ? "Select City "
                    //                   : cityName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selCity),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              societies = [];
                              for (int i = 0; i < cityData.length; i++) {
                                if (cityData[i]["Name"] == val.toString()) {
                                  cityId = cityData[i]["Id"].toString();
                                }
                              }
                              print('city id${cityId}');
                              setState(() {
                                selCity = val;
                              });
                              getSocietyList();
                            },
                            //value: selCity,
                            items: cities.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Society",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showSocietyDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               societyName == "" || societyName == null
                    //                   ? "Select Society  "
                    //                   : societyName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selSociety),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              wings = [];
                              for (int i = 0; i < societyData.length; i++) {
                                if (societyData[i]["Name"] ==
                                    val.toString()) {
                                  societyId = societyData[i]["Id"].toString();
                                }
                              }
                              print('society id${societyId}');
                              setState(() {
                                selSociety = val;
                              });
                              getSocietyWingList();
                            },
                            //value: selCity,
                            items: societies.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Building",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showBuildingDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               buildingName == "" || buildingName == null
                    //                   ? "Select Building "
                    //                   : buildingName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selWing),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              flats = [];
                              for (int i = 0; i < wingData.length; i++) {
                                if (wingData[i]["WingName"] ==
                                    val.toString()) {
                                  wingId = wingData[i]["Id"].toString();
                                }
                              }
                              print('wing id${wingId}');
                              setState(() {
                                selWing = val;
                              });
                              getSocietyFlatList();
                            },
                            //value: selCity,
                            items: wings.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
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
                  ],
                ),
              ),
/*
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat No.",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 40,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: txtFlatNo,
                          validator: (pincode) {
                            if (pincode.length == 0) {
                              return 'Please enter your flatNo';
                            }
                            return null;
                          },
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(5),
                            hintText: 'Flat No ',
                            hintStyle: TextStyle(fontSize: 16),
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
*/
              // Padding(
              //   padding: const EdgeInsets.only(
              //     top: 10.0,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text(
              //             'Floor No.',
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.w600),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 5.0),
              //             child: Container(
              //               width: MediaQuery.of(context).size.width / 2.3,
              //               height: 40,
              //               child: TextFormField(
              //                 keyboardType: TextInputType.text,
              //                 controller: txtFloorNo,
              //                 validator: (pincode) {
              //                   // Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
              //                   // RegExp regExp = new RegExp(pattern);
              //                   if (pincode.length == 0) {
              //                     return 'Please enter your Floor No';
              //                   }
              //                   return null;
              //                 },
              //                 style: TextStyle(fontSize: 15),
              //                 decoration: InputDecoration(
              //                   contentPadding: const EdgeInsets.all(5),
              //                   hintText: 'Floor No ',
              //                   hintStyle: TextStyle(fontSize: 17),
              //                   fillColor: Colors.white,
              //                   enabledBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.grey),
              //                   ),
              //                   errorBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.red),
              //                   ),
              //                   focusedErrorBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.red),
              //                   ),
              //                   focusedBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.grey),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: <Widget>[
              //           Text(
              //             'Flat No.',
              //             style: TextStyle(
              //                 fontSize: 15, fontWeight: FontWeight.w600),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 5.0),
              //             child: Container(
              //               width: MediaQuery.of(context).size.width / 2.3,
              //               height: 40,
              //               child: TextFormField(
              //                 keyboardType: TextInputType.text,
              //                 controller: txtFlatNo,
              //                 validator: (pincode) {
              //                   // Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
              //                   // RegExp regExp = new RegExp(pattern);
              //                   if (pincode.length == 0) {
              //                     return 'Please enter your flatNo';
              //                   }
              //                   return null;
              //                 },
              //                 style: TextStyle(fontSize: 15),
              //                 decoration: InputDecoration(
              //                   contentPadding: const EdgeInsets.all(5),
              //                   hintText: 'Flat No ',
              //                   hintStyle: TextStyle(fontSize: 16),
              //                   fillColor: Colors.white,
              //                   enabledBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.grey),
              //                   ),
              //                   errorBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.red),
              //                   ),
              //                   focusedErrorBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.red),
              //                   ),
              //                   focusedBorder: OutlineInputBorder(
              //                     borderRadius:
              //                         BorderRadius.all(Radius.circular(5.0)),
              //                     borderSide: BorderSide(color: Colors.grey),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 15.0),
              //   child: Text(
              //     'Flat holder is',
              //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              //   ),
              // ),
              // ListTile(
              //   title: Column(
              //     children: <Widget>[
              //       Container(
              //         height: 40,
              //         child: RadioListTile(
              //           activeColor: appPrimaryMaterialColor,
              //           groupValue: flatHolder,
              //           title: Text('Owner',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 16,
              //               )),
              //           value: 'Owner',
              //           onChanged: (val) {
              //             setState(() {
              //               flatHolder = val;
              //             });
              //           },
              //         ),
              //       ),
              //       Container(
              //         height: 40,
              //         child: RadioListTile(
              //           activeColor: appPrimaryMaterialColor,
              //           groupValue: flatHolder,
              //           title: Text('Tenant',
              //               style: TextStyle(
              //                 color: Colors.black,
              //                 fontSize: 16,
              //               )),
              //           value: 'Tenant',
              //           onChanged: (val) {
              //             setState(() {
              //               flatHolder = val;
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat No.",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showCityDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               cityName == "" || cityName == null
                    //                   ? "Select City "
                    //                   : cityName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selFlat),
                            // value: _memberClass,
                            onChanged: (val) {
                              setState(() {
                                selFlat = val;
                              });
                            },
                            //value: selCity,
                            items: flats.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Flat Holder Type",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       await _showCityDialog(context);
                    //     },
                    //     child: Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       height: 50,
                    //       decoration: BoxDecoration(
                    //         border: Border.all(
                    //           color: Colors.grey,
                    //           // width: 2,
                    //         ),
                    //         borderRadius: BorderRadius.circular(5),
                    //       ),
                    //       child: Row(
                    //         children: [
                    //           Expanded(
                    //               child: Padding(
                    //             padding: const EdgeInsets.only(left: 8.0),
                    //             child: Text(
                    //               cityName == "" || cityName == null
                    //                   ? "Select City "
                    //                   : cityName,
                    //               style: TextStyle(fontSize: 18),
                    //             ),
                    //           )),
                    //           Padding(
                    //             padding: const EdgeInsets.only(right: 8.0),
                    //             child: Icon(
                    //               Icons.arrow_drop_down,
                    //               size: 30,
                    //             ),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: DropdownButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            //isDense: true,
                            hint: new Text(selFlatHolderType),
                            // value: _memberClass,
                            onChanged: (val) {
                              print(val);
                              setState(() {
                                selFlatHolderType = val;
                              });
                            },
                            //value: selCity,
                            items: flatholdertypes.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
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
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12, top: 20, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: FlatButton(
                    color: appPrimaryMaterialColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Add Flat/Villa",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.grey[300],
                        ),
                    ),
                    onPressed: () {
                      if (selState == "Select your State" ||
                          selCity == 'Select your City' ||
                          selSociety == 'Select your Society' ||
                          selWing == 'Select your Building' ||
                          selFlat == 'Select your Flat Number' ||
                          flatHolder == "") {
                        Fluttertoast.showToast(
                          msg: "Fields can't be empty",
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.purple,
                          textColor: Colors.white,
                        );
                      } else {
                        // _checkLogin();
                        widget.isUpdate != null ? updateMemberDetails(
                            logindata[0]["SocietyId"].toString(),
                            logindata[0]["Name"],
                            logindata[0]["ContactNo"],
                            logindata[0]["FlatNo"],
                            logindata[0]["WingId"].toString(),
                            selFlatHolderType,
                            logindata[0]["Id"].toString(),
                            fcmToken: ""
                        ):
                        addMemberDetails();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //show dialog for select state
  _showStateDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertStateDialog(
          onState: (String funStataName) {
            setState(() {
              stataName = funStataName;
            });
          },
        );
      },
    );
  }

  //dialog for city
  _showCityDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertCityDialog(
          onCity: (String funCityName) {
            setState(() {
              cityName = funCityName;
            });
          },
        );
      },
    );
  }

  //dialog for Society
  _showSocietyDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertSocietyDialog(
          onSociety: (String funSocietyName) {
            setState(() {
              societyName = funSocietyName;
            });
          },
        );
      },
    );
  }

  //dialog for building
  _showBuildingDialog(BuildContext context) {
    //show alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertBuildingDialog(
          onBuilding: (String funBuildName) {
            setState(() {
              buildingName = funBuildName;
            });
          },
        );
      },
    );
  }
}

class AlertStateDialog extends StatefulWidget {
  Function onState;

  AlertStateDialog({this.onState});

  @override
  _AlertStateDialogState createState() => _AlertStateDialogState();
}

class _AlertStateDialogState extends State<AlertStateDialog> {
  List stateList = ["Gujarat", "Bihar", "Andhra Pradesh", "Arunachal Pradesh"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select State",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text(
            'Cancel',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(
            'Ok',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: stateList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onState("${stateList[index]}");
            Navigator.of(context).pop("${stateList[index]}");
          },
          child: ListTile(
            title: Text('${stateList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertCityDialog extends StatefulWidget {
  Function onCity;

  AlertCityDialog({this.onCity});

  @override
  _AlertCityDialogState createState() => _AlertCityDialogState();
}

class _AlertCityDialogState extends State<AlertCityDialog> {
  List cityList = ["Surat", "Udhana", "Kim", "Baroda"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select City",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: cityList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onCity("${cityList[index]}");
            Navigator.of(context).pop("${cityList[index]}");
          },
          child: ListTile(
            title: Text('${cityList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertSocietyDialog extends StatefulWidget {
  Function onSociety;

  AlertSocietyDialog({this.onSociety});

  @override
  _AlertSocietyDialogState createState() => _AlertSocietyDialogState();
}

class _AlertSocietyDialogState extends State<AlertSocietyDialog> {
  List socList = ["abc", "xyz", "def", "sqa"];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select Society Name",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          child: new Text(
            'Cancel',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text(
            'Ok',
            style: TextStyle(color: appPrimaryMaterialColor, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: socList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onSociety("${socList[index]}");
            Navigator.of(context).pop("${socList[index]}");
          },
          child: ListTile(
            title: Text('${socList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}

class AlertBuildingDialog extends StatefulWidget {
  Function onBuilding;

  AlertBuildingDialog({this.onBuilding});

  @override
  _AlertBuildingDialogState createState() => _AlertBuildingDialogState();
}

class _AlertBuildingDialogState extends State<AlertBuildingDialog> {
  List buildingList = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L"
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(
        "Select Building",
        style: TextStyle(
            fontSize: 22,
            color: appPrimaryMaterialColor,
            fontWeight: FontWeight.w400),
      ),
      content: stateListview(),
    );
  }

  Widget stateListview() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: buildingList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            widget.onBuilding("${buildingList[index]}");
            Navigator.of(context).pop("${buildingList[index]}");
          },
          child: ListTile(
            title: Text('${buildingList[index]}'),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
      ),
    );
  }
}
