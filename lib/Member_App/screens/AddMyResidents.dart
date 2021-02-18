import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:smart_society_new/Mall_App/transitions/slide_route.dart';
import 'package:smart_society_new/Member_App/screens/CustomerProfile.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class AddMyResidents extends StatefulWidget {
  @override
  _AddMyResidentsState createState() => _AddMyResidentsState();
}

class _AddMyResidentsState extends State<AddMyResidents> {
  String stataName, cityName, societyName, buildingName;
  String flatHolder;
  TextEditingController txtFloorNo = TextEditingController();
  TextEditingController txtFlatNo = TextEditingController();
  List stateandcities = [];
  List societyData = [];
  List wingData = [];
  List<String> societies = [];
  List<String> wings = [];
  List<String> states = [], cities = [];
  String selState = 'Select your State',
      selCity = 'Select your City',
      selSociety = 'Select your Society',
      selWing = 'Select your Building';
  bool isLoading = false;

  @override
  void initState() {
    getStatesCities();
    getSocietyList();
    getSocietyWingList();
  }

  getStatesCities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.getStatesCities().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != "") {
            print("statecitiesdata");
            stateandcities = data;
            for (int i = 0; i < stateandcities.length; i++) {
              if (!states.contains(stateandcities[i]["state"])) {
                states.add(stateandcities[i]["state"]);
                states.sort();
              }
            }
            print("states");
            print(states);
          } else {
            //showMsg(data.Message);
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Try Again.");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getSocietyList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetSocietyList().then((data) async {
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

  getSocietyWingList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String SocietyId = prefs.getString(constant.Session.SocietyId);

        Services.GetSocietyWingDetails(SocietyId).then((data) async {
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
              },
            ),
          ],
        );
      },
    );
  }

  showMsg(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pop(context);
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Icon(Icons.arrow_back_ios),
        //   ),
        // ),
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
      body: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
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
                            padding: const EdgeInsets.only(left:8.0),
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
                                for (int i = 0; i < stateandcities.length; i++) {
                                  if (stateandcities[i]["state"] ==
                                      val.toString()) {
                                    cities.add(stateandcities[i]["name"]);
                                    cities.sort();
                                  }
                                }
                                print("cities");
                                print(cities);
                                setState(() {
                                  selState = val;
                                });
                              },
                              //value: selState,
                              items: states
                                  .map<DropdownMenuItem<String>>((String value) {
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
                            padding: const EdgeInsets.only(left:8.0),
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              //isDense: true,
                              hint: new Text(selCity),
                              // value: _memberClass,
                              onChanged: (val) {
                                setState(() {
                                  selCity = val;
                                });
                              },
                              //value: selCity,
                              items: cities
                                  .map<DropdownMenuItem<String>>((String value) {
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
                            padding: const EdgeInsets.only(left:8.0),
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              //isDense: true,
                              hint: new Text(selSociety),
                              // value: _memberClass,
                              onChanged: (val) {
                                setState(() {
                                  selSociety = val;
                                });
                              },
                              //value: selCity,
                              items: societies
                                  .map<DropdownMenuItem<String>>((String value) {
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
                            padding: const EdgeInsets.only(left:8.0),
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              //isDense: true,
                              hint: new Text(selWing),
                              // value: _memberClass,
                              onChanged: (val) {
                                setState(() {
                                  selWing = val;
                                });
                              },
                              //value: selCity,
                              items: wings
                                  .map<DropdownMenuItem<String>>((String value) {
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
                    top: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Floor No.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 40,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: txtFloorNo,
                                validator: (pincode) {
                                  // Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                                  // RegExp regExp = new RegExp(pattern);
                                  if (pincode.length == 0) {
                                    return 'Please enter your Floor No';
                                  }
                                  return null;
                                },
                                style: TextStyle(fontSize: 15),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(5),
                                  hintText: 'Floor No ',
                                  hintStyle: TextStyle(fontSize: 17),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Flat No.',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.3,
                              height: 40,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: txtFlatNo,
                                validator: (pincode) {
                                  // Pattern pattern = r'(^(?:[+0]9)?[0-9]{10,}$)';
                                  // RegExp regExp = new RegExp(pattern);
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'Flat holder is',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
                ListTile(
                  title: Column(
                    children: <Widget>[
                      Container(
                        height: 40,
                        child: RadioListTile(
                          activeColor: appPrimaryMaterialColor,
                          groupValue: flatHolder,
                          title: Text('Owner',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          value: 'Owner',
                          onChanged: (val) {
                            setState(() {
                              flatHolder = val;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: 40,
                        child: RadioListTile(
                          activeColor: appPrimaryMaterialColor,
                          groupValue: flatHolder,
                          title: Text('Tenant',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                          value: 'Tenant',
                          onChanged: (val) {
                            setState(() {
                              flatHolder = val;
                            });
                          },
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
                          side: BorderSide(color: Colors.grey[300])),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
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
