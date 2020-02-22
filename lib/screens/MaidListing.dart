import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/component/MaidComponent.dart';

class MaidListing extends StatefulWidget {
  @override
  _MaidListingState createState() => _MaidListingState();
}

class _MaidListingState extends State<MaidListing> {
  bool isLoading = true;
  List maidList = [];

  @override
  void initState() {
    super.initState();
    _getMaidListing();
  }

  _getMaidListing() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetMaidListing();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              maidList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              maidList = data;
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
        : maidList.length > 0
            ? ListView.builder(
                itemCount: maidList.length,
                itemBuilder: (BuildContext context, int index) {
                  return MaidComponent(maidList[index]);
                })
            : Container(
                child: Center(child: Text("No Data Found")),
              );
  }
}
