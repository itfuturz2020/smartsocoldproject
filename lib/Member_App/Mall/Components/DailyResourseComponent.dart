import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class DailyResourseComponent extends StatefulWidget {
  var dailyResourceData;
  Function onDelete;

  DailyResourseComponent({this.dailyResourceData, this.onDelete});

  @override
  _DailyResourseComponentState createState() => _DailyResourseComponentState();
}

class _DailyResourseComponentState extends State<DailyResourseComponent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _settingModalBottomSheet();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100.0))),
                              width: 80,
                              height: 80,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Image.asset("images/family.png",
                                    width: 40, color: Colors.grey[400]),
                              )),
                          Text(
                            "${widget.dailyResourceData['Name']}",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${widget.dailyResourceData['Role']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: appPrimaryMaterialColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.call_sharp,
                        size: 20,
                        color: Colors.black54,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Container(
                          color: Colors.grey,
                          width: 1,
                          height: 25,
                        ),
                      ),
                      Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDelete(
          deleteId: Id,
          onDelete: () {
            widget.onDelete();
          },
        );
      },
    );
  }

  DeleteDailyResource(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isLoading = true;
        // });
        Services.DeleteFamilyMember(Id).then((data) async {
          if (data.Data == "1") {
            // setState(() {
            //   isLoading = false;
            // });

            // Navigator.pushReplacement(
            //     context, SlideLeftRoute(page: CustomerProfile()));
            widget.onDelete();
          } else {
            // isLoading = false;
            showHHMsg("Member Is Not Deleted", "");
          }
        }, onError: (e) {
          //isLoading = false;
          showHHMsg("$e", "");
          //isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
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

  void _settingModalBottomSheet() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (builder) {
          return new Container(
              height: 240.0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        "Daily Resources",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                            //fontWeight: FontWeight.bold
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, right: 15, left: 25, bottom: 15),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/assets/profile.png'),
                            backgroundColor: appPrimaryMaterialColor,
                            radius: 45,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.dailyResourceData["Name"]}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "${widget.dailyResourceData["Role"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: appPrimaryMaterialColor,
                                    ),
                                  ),
                                  Text(
                                    "${widget.dailyResourceData["Mobile"]}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  print(
                                      '${widget.dailyResourceData["Id"].toString()}');
                                  _showConfirmDialog(widget
                                      .dailyResourceData["Id"]
                                      .toString());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Container(
                              color: appPrimaryMaterialColor,
                              width: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                  onPressed: () {
                                    launch(
                                        ('tel:// ${widget.dailyResourceData["Mobile"]}'));
                                  },
                                  child: Center(
                                    child: Text(
                                      "Call Now",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 0.0, top: 2),
                          //   child: Container(
                          //     color: appPrimaryMaterialColor,
                          //     width: MediaQuery.of(context).size.width / 2,
                          //     child: FlatButton(
                          //         onPressed: () {
                          //           Share.share(widget.familyData["ContactNo"],
                          //               subject:
                          //               'Name : ${widget.familyData["Name"]}');
                          //         },
                          //         child: Center(
                          //           child: Text(
                          //             "Invite to MyJini",
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         )),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}

class AlertDelete extends StatefulWidget {
  var deleteId;
  Function onDelete;

  AlertDelete({this.deleteId, this.onDelete});

  @override
  _AlertDeleteState createState() => _AlertDeleteState();
}

class _AlertDeleteState extends State<AlertDelete> {
  String SocietyId, FlatId, WingId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profile();
  }

  profile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      FlatId = prefs.getString(constant.Session.FlatNo);
      WingId = prefs.getString(constant.Session.WingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text("My Jini"),
      content: new Text("Are You Sure You Want To Delete this Member ?"),
      actions: <Widget>[
        new FlatButton(
          child: new Text("No",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Yes",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          onPressed: () {
            DeleteDailyResource(widget.deleteId, SocietyId, FlatId, WingId);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  DeleteDailyResource(
      String staffId, String societyId, String flatId, String wingId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isLoading = true;
        // });
        Services.DeleteDailyResource(staffId, societyId, flatId, wingId).then(
            (data) async {
          if (data.Data == "1") {
            // setState(() {
            //   isLoading = false;
            // });

            // Navigator.pushReplacement(
            //     context, SlideLeftRoute(page: CustomerProfile()));
            widget.onDelete();
          } else {
            // isLoading = false;
            showHHMsg("Daily Resource Is Not Deleted", "");
          }
        }, onError: (e) {
          //isLoading = false;
          showHHMsg("$e", "");
          //isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
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
}
