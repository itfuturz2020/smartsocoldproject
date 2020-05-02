import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/Admin_App/Common/Services.dart';
import 'package:smart_society_new/Admin_App/Component/ComplaintComponent.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Admin_App/Component/NoDataComponent.dart';

class Complaints extends StatefulWidget {
  @override
  _ComplaintsState createState() => _ComplaintsState();
}

class _ComplaintsState extends State<Complaints> {
  List _complaintData = [];
  bool isLoading = false;

  @override
  void initState() {
    _getComplaints();
  }

  _getComplaints() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getComplaints();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _complaintData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              _complaintData = data;
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong Please Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Complaints",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/Dashboard");
            },
          ),
        ),
        body: Container(
          color: Colors.grey[200],
          child: isLoading
              ? LoadingComponent()
              : _complaintData.length > 0
                  ? AnimationLimiter(
                      child: ListView.builder(
                        itemCount: _complaintData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ComplaintComponent(
                              _complaintData[index], index, (type) {
                            if (type == "false")
                              _getComplaints();
                            else if (type == "loading")
                              setState(() {
                                isLoading = true;
                              });
                          });
                        },
                      ),
                    )
                  : NoDataComponent(),
        ),
      ),
    );
  }
}
