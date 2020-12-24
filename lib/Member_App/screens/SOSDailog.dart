import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class SOSDailog extends StatefulWidget {
  @override
  _SOSDailogState createState() => _SOSDailogState();
}

class _SOSDailogState extends State<SOSDailog> {
  String _selected = "Watchman";
  String phoneNumber1;

  TextEditingController txtMsg = new TextEditingController();
  ProgressDialog pr;
  List FmemberData = new List();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId;


  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    GetFamilyDetail();
    _getLocaldata();
  }


  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    if (prefs.getString(constant.Session.ParentId) == "null" ||
        prefs.getString(constant.Session.ParentId) == "")
      ParentId = "0";
    else
      ParentId = prefs.getString(constant.Session.ParentId);
  }

  GetFamilyDetail() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetFamilyMember(ParentId, MemberId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              FmemberData = data;
              //phoneNumber1 = data[0]["ContactNo"];
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
  _addSOS() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String MemberId = prefs.getString(constant.Session.Member_Id);
        var data = {
          "Id": MemberId,
          "": txtMsg.text,
        };
        pr.show();
        Services.AddSOS(data).then((data) async {
          pr.hide();
          if (data.Data != "0" && data.IsSuccess == true) {
          } else {
            showMsg("Something Went Wrong", "");
            pr.hide();
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Try Again.", "");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.", "");
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
                Navigator.pushReplacementNamed(context, "/LoginScreen");
              },
            ),
          ],
        );
      },
    );
  }
  Widget _FamilyMember(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${FmemberData[index]["Name"]}",
                style: TextStyle(
                    fontSize: 13,
                    color: constant.appPrimaryMaterialColor,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                "${FmemberData[index]["ContactNo"]}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(
              Icons.call,
              color: Colors.green[700],
            ),
            onPressed: () {
              launch(('tel:// ${FmemberData[index]["ContactNo"]}'));
            })
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 0),
      contentPadding: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10),
      title: SingleChildScrollView(
        child: Container(
          color: constant.appPrimaryMaterialColor,
          width: double.infinity,
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            "Emergency SOS",
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Radio(
                value: 'Watchman',
                groupValue: _selected,
                onChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
              ),
              Text(
                "Watchman",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
              Radio(
                value: 'Member',
                groupValue: _selected,
                onChanged: (value) {
                  setState(() {
                    _selected = value;
                  });
                },
              ),
              Text(
                "Family Member",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ],
          ),

          // for (int i = 0; i < 3; i++) ...[
          //   Row(
          //     children: <Widget>[
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: <Widget>[
          //             Text(
          //               "Chirag Mevada",
          //               style: TextStyle(
          //                   fontSize: 13,
          //                   color: constant.appPrimaryMaterialColor,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             Text(
          //               "7874319343",
          //               style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          //             ),
          //           ],
          //         ),
          //       ),
          //       IconButton(
          //           icon: Icon(
          //             Icons.call,
          //             color: Colors.green[700],
          //           ),
          //           onPressed: () {})
          //     ],
          //   )
          // ],
          isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
              : FmemberData.length > 0
              ? ListView.builder(
              itemBuilder: _FamilyMember,
              itemCount: FmemberData.length,
              shrinkWrap: true)
              : Container(
            child: Center(child: Text("No FamilyMember Added")),
          ),
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextFormField(
                controller: txtMsg,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: constant.appPrimaryMaterialColor[600])),
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                  labelText: "Any Message",
                  hintStyle: TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: SizedBox(
              width: 200,
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: constant.appPrimaryMaterialColor[600],
                textColor: Colors.white,
                splashColor: Colors.white,
                child: Text("Send",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
