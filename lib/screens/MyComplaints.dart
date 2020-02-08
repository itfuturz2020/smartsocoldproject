import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/common/constant.dart';

class MyComplaints extends StatefulWidget {
  @override
  _MyComplaintsState createState() => _MyComplaintsState();
}

class _MyComplaintsState extends State<MyComplaints> {
  List ComplainData = new List();
  bool isLoading = false;
  String MemberId;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    MemberId = prefs.getString(constant.Session.Member_Id);
  }

  @override
  void initState() {
    GetComplaints();
    _getLocaldata();
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
        : "${tempDate[2].toString().substring(0, 2)}-${setMonth(DateTime.parse(date))}"
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

  GetComplaints() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetComplainByMember(MemberId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              ComplainData = data;
            });
          } else {
            setState(() {
              isLoading = false;
              ComplainData = data;
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

  Widget Pending() {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, right: 5.0, bottom: 5.0),
      child: Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text("Pending",
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child:
                        Icon(Icons.watch_later, size: 18, color: Colors.amber),
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(new Radius.circular(10.0)),
          )),
    );
  }

  Widget Completed() {
    return Padding(
      padding: const EdgeInsets.only(left: 11.0, right: 5.0, bottom: 5.0),
      child: Container(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text("Solved",
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(Icons.verified_user,
                        size: 18, color: Colors.green),
                  )
                ],
              ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(new Radius.circular(10.0)),
          )),
    );
  }

  _deleteComplaint(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteComplaint(Id).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            GetComplaints();
          } else {
            isLoading = false;
            showHHMsg("Complaint Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("My Jini"),
          content: new Text("Are You Sure You Want To Delete Your Notice ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteComplaint(Id);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _MyComplaint(BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 100,
        child: FadeInAnimation(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              elevation: 1,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: FadeInImage.assetNetwork(
                            placeholder: "images/placeholder.png",
                            image: Image_Url + '${ComplainData[index]["Image"]}',
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Wrap(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            "${ComplainData[index]["Title"]}",
                                            overflow: TextOverflow.visible,
                                            maxLines: 2,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, top: 2.0, bottom: 2.0),
                                    child: Container(
                                      width: 70,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0))),
                                      child: Center(
                                        child: Text(
                                            "${setDate(ComplainData[index]["Date"])}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54,
                                                fontSize: 14)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5.0, right: 2.0),
                                    child: Text(
                                      "${ComplainData[index]["Description"]}",
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          color: Colors.grey[700], fontSize: 14),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  ComplainData[index]["Status"] == 0
                                      ? Pending()
                                      : Completed()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  FlatButton(
                      onPressed: () {
                        _showConfirmDialog(ComplainData[index]["Id"].toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.delete, color: Colors.red),
                              Text(
                                "Delete",
                                style: TextStyle(
                                    color: Colors.red, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/HomeScreen");
            }),
        centerTitle: true,
        title: Text("Complaints"),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/HomeScreen');
        },
        child: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : ComplainData.length > 0
                ? AnimationLimiter(
                    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: ComplainData.length,
                    itemBuilder: _MyComplaint,
                  ))
                : Container(child: Center(child: Text("No Complaints Found"))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: constant.appPrimaryMaterialColor,
        icon: Icon(Icons.add),
        label: Text("Add Complaint"),
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/AddComplaints');
        },
      ),
    );
  }
}
