import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;

class MyGuestlist extends StatefulWidget {
  @override
  _MyGuestlistState createState() => _MyGuestlistState();
}

class _MyGuestlistState extends State<MyGuestlist> {
  bool isLoading = false;
  List _GuestData = [];
  List _GuestList = [];
  List _VisitorList = [];

  _GetVisitorData() async {
    try {
      //check Internet Connection
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
              _GuestData = data;
            });
            _SetData(data);
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

  _SetData(var data) {
    for (int i = 0; i < data.length; i++) {
      if (data[i]["IsVerified"] == true) {
        _VisitorList.add(data[i]);
      } else
        _GuestList.add(data[i]);
    }
    print("Visitor list  ----" + _VisitorList.toString());
    print("Guest list  ----" + _GuestList.toString());
  }

  String Address;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      Address = prefs.getString(constant.Session.Address);
    });
  }

  @override
  void initState() {
    _GetVisitorData();
    _getLocaldata();
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
    }
    final_date = date == "" || date == null
        ? ""
        : "${tempDate[2].toString().substring(0, 2)}\n${setMonth(DateTime.parse(date))}"
            .toString();

    return final_date;
  }

  setMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "Jan";
        break;
      case 2:
        return "Feb";
        break;
      case 3:
        return "Mar";
        break;
      case 4:
        return "Apr";
        break;
      case 5:
        return "May";
        break;
      case 6:
        return "Jun";
        break;
      case 7:
        return "Jul";
        break;
      case 8:
        return "Aug";
        break;
      case 9:
        return "Sep";
        break;
      case 10:
        return "Oct";
        break;
      case 11:
        return "Nov";
        break;
      case 12:
        return "Dec";
        break;
    }
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
                          Share.share(
                              'http://smartsociety.itfuturz.com/QRCode.aspx?id=${_GuestList[index]["Id"]}' +
                                  "\n ${Address} ");
                        }),
                  )
                ],
              ),
            ],
          )),
    );
  }

  Widget _MyVisitorList(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0),
      child: Card(
          elevation: 2,
          child: Column(
            children: <Widget>[
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
                              Text("${_VisitorList[index]["Name"]}",
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
                              child: Text(
                                  "  ${_VisitorList[index]["ContactNo"]}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700])),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Center(
                        child: Text("  ${setDate(_VisitorList[index]["Date"])}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700])),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: constant.appPrimaryMaterialColor,
            icon: Icon(Icons.add),
            label: Text("Add Guest"),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/AddGuest');
            },
          ),
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                    icon: Text(
                  "My Guests",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
                Tab(
                    icon: Text(
                  "My Visitors",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
              ],
            ),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Visitor List',
                style: TextStyle(fontSize: 18),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          body: TabBarView(children: [
            Container(
              child: isLoading
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
            ),
            Container(
              child: isLoading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _VisitorList.length > 0
                      ? Container(
                          child: Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _VisitorList.length,
                              itemBuilder: _MyVisitorList,
                            ),
                          ),
                        )
                      : Container(
                          child: Center(child: Text("No Data Found")),
                        ),
            )
          ])),
    );
  }
}
