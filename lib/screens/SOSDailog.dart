import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;

class SOSDailog extends StatefulWidget {
  @override
  _SOSDailogState createState() => _SOSDailogState();
}

class _SOSDailogState extends State<SOSDailog> {
  String _selected = "Watchman";

  TextEditingController txtMsg = new TextEditingController();
  ProgressDialog pr;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(top: 0),
      contentPadding: EdgeInsets.only(top: 10, left: 7, right: 7, bottom: 10),
      title: Container(
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
