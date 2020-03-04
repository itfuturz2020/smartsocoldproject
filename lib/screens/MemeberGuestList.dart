import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;


class MemberGuestList extends StatefulWidget {
  @override
  _MemberGuestListState createState() => _MemberGuestListState();
}

class _MemberGuestListState extends State<MemberGuestList> {

  bool isLoading = false;
  List _GuestList = [];
  String Address;
  String Type = 'Visitor';


  @override
  void initState() {
    _GetVisitorData();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Address = prefs.getString(constant.Session.Address);
    });
  }


  _GetVisitorData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetGuestData().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _GuestList = data;
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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


  Widget _MyGuestlistCard(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Card(
          elevation: 2,
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                color: Colors.grey[200],
                width: MediaQuery.of(context).size.width / 1.1,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, bottom: 10.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage("images/man.png"),
                            fit: BoxFit.cover),
                        borderRadius:
                        BorderRadius.all(new Radius.circular(75.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text("${_GuestList[index]["Name"]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromRGBO(81, 92, 111, 1))),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 1.0, top: 3.0),
                              child: Text("  ${_GuestList[index]["ContactNo"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700])),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: IconButton(
                        icon: Icon(Icons.share, color: Colors.grey),
                        onPressed: () {
                          Share.share('http://smartsociety.itfuturz.com/QRCode.aspx?id=${_GuestList[index]["Id"]}&type=Visitor');
                        }
                        ),
                  )
                ],
              ),
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
          : _GuestList.length > 0
          ? Container(
        child: Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _GuestList.length,
            itemBuilder: _MyGuestlistCard,
          ),
        ),
      )
          : Container(
        child: Center(child: Text("No Data Found")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: constant.appPrimaryMaterialColor,
        icon: Icon(Icons.add),
        label: Text("Add Guest"),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/AddGuest');
        },
      ),
    );
  }
}