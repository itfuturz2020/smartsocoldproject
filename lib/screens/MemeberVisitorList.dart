import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:smart_society_new/common/constant.dart' as constant;

class MemberVisitorList extends StatefulWidget {
  @override
  _MemberVisitorListState createState() => _MemberVisitorListState();
}

class _MemberVisitorListState extends State<MemberVisitorList> {
  bool isLoading = false;
  List _VisitorList = [];

  @override
  void initState() {
    _GetVisitorData();
  }

  _GetVisitorData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetMyVisitorList().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _VisitorList = data;
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

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }
    return final_date;
  }

  Widget _MyGuestlistCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Card(
          elevation: 2,
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 10.0, left: 10.0, bottom: 10.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: _VisitorList[index]["Image"] == "" ||
                                _VisitorList[index]["Image"] == null
                            ? AssetImage("images/man.png")
                            : NetworkImage(
                                Image_Url + _VisitorList[index]["Image"]),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(new Radius.circular(75.0)),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("${_VisitorList[index]["Name"]}",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(81, 92, 111, 1))),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                      child: Text("  ${_VisitorList[index]["ContactNo"]}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700])),
                    )
                  ],
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "${setDate(_VisitorList[index]["Date"])}",
                  style: TextStyle(
                      fontSize: 13,
                      color: constant.appPrimaryMaterialColor,
                      fontWeight: FontWeight.w600),
                ),
              )*/
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : _VisitorList.length > 0
              ? Container(
                  child: Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _VisitorList.length,
                      itemBuilder: _MyGuestlistCard,
                    ),
                  ),
                )
              : Container(
                  child: Center(child: Text("No Data Found")),
                ),
    );
  }
}
