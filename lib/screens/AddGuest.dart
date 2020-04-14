import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:smart_society_new/common/constant.dart' as cnst;
import 'package:smart_society_new/component/LoadingComponent.dart';

class AddGuest extends StatefulWidget {
  @override
  _AddGuestState createState() => _AddGuestState();
}

class _AddGuestState extends State<AddGuest> {
  TextEditingController txtVisitorName = new TextEditingController();
  TextEditingController txtMobile = new TextEditingController();
  TextEditingController purpose = new TextEditingController();
  TextEditingController txtCode = new TextEditingController();
  bool isLoading = false;
  ProgressDialog pr;

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.contacts
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      Navigator.pushNamed(context, "/ContactList");
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  _AddVisitor() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          pr.show();
        });
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String SocietyId = preferences.getString(Session.SocietyId);
        String memberID = preferences.getString(Session.Member_Id);
        String WingId = preferences.getString(Session.WingId);
        String FlatId = preferences.getString(Session.FlatNo);

        FormData formData = new FormData.fromMap({
          "Id": 0,
          "Name": txtVisitorName.text,
          "SocietyId": SocietyId,
          "ContactNo": txtMobile.text,
          "MSId": memberID,
          "CompanyName": "",
          "VisitorTypeId": "7",
          "Purpose": purpose.text,
          "VehicleNo": "",
          "WingId": WingId,
          "FlatId": FlatId,
          "AddedBy": "Member",
          "CompanyImage": "",
          "Image": null,
        });

        Services.AddVisitor(formData).then((data) async {
          pr.hide();
          if (data.Data != "0") {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(
                msg: "Visitor Added Successfully",
                backgroundColor: Colors.green,
                gravity: ToastGravity.TOP,
                textColor: Colors.white);

            await Share.share(
                'Please show the QR code in the follwing link at the gate for Entry Purpose\n\nhttp://smartsociety.itfuturz.com/QRCode.aspx?id=${data.Data}');
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/HomeScreen', (Route<dynamic> route) => false);
          } else {
            setState(() {
              isLoading = false;
            });
            showMsg(data.Message, title: "Error");
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.");
        });
      } else {
        setState(() {
          isLoading = false;
          pr.hide();
        });
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      pr.hide();
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'My Jini'}) {
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

  checkValidation() {
    if (txtVisitorName.text != "" && txtMobile.text != "") {
      _AddVisitor();
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All The Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/HomeScreen', (Route<dynamic> route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Guest"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/HomeScreen', (Route<dynamic> route) => false);
              }),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: isLoading
                ? LoadingComponent()
                : Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(100.0))),
                                width: 70,
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Image.asset("images/guest.png",
                                      width: 10, color: Colors.grey[400]),
                                )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Add Guest",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(81, 92, 111, 1)))
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0, top: 10),
                            child: Text(
                              "  Name*",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: txtVisitorName,
                                decoration: InputDecoration(
                                    counter: Text(""),
                                    hintText: "Guest Name",
                                    hintStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0, top: 1),
                            child: Text(
                              "  Mobile Number*",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                maxLength: 10,
                                controller: txtMobile,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    counter: Text(""),
                                    hintText: " Mobile Number",
                                    hintStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 9.0, top: 1),
                            child: Text(
                              "  Purpose*",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 1.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: purpose,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    counter: Text(""),
                                    hintText: "Enter Purpose",
                                    hintStyle: TextStyle(fontSize: 13)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: cnst.appPrimaryMaterialColor),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.6,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appprimarycolors[400],
                          onPressed: () {
                            requestPermission(PermissionGroup.contacts);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                Icons.contact_phone,
                                color: Colors.white,
                                size: 17,
                              ),
                              Text(
                                "Choose From Contact List",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 10),
                        height: 45,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          color: cnst.appPrimaryMaterialColor,
                          minWidth: MediaQuery.of(context).size.width - 20,
                          onPressed: () {
                            checkValidation();
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VistorQR()),
                            );*/
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.w600),
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
}
