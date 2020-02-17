import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/component/OtherHelpComponent.dart';
class OtherHelpListing extends StatefulWidget {
  @override
  _OtherHelpListingState createState() => _OtherHelpListingState();
}

class _OtherHelpListingState extends State<OtherHelpListing> {
  bool isLoading = true;
  List otherList = [];

  @override
  void initState() {
    super.initState();
    _getotherListing();
  }

  _getotherListing() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetOtherListing();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              otherList = data;

              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              otherList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("Something went worng!!!");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : otherList.length > 0
        ? ListView.builder(
        itemCount: otherList.length,
        itemBuilder: (BuildContext context, int index) {
          return OtherHelpComponent(otherList[index]);
        })
        : Container(
      child: Center(child: Text("No Data Found")),
    );
  }
}
