import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall/Common/MallConstants.dart';
import 'package:smart_society_new/Mall/Common/MallServices.dart';

class Mall extends StatefulWidget {
  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall> {
  List _bannerData = [];

  bool isLoading = false;

  @override
  void initState() {
    _getBanner();
  }

  _getBanner() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        MallServices.GetBanner().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.success == "1" && data.data.length > 0) {
            setState(() {
              _bannerData = data.data;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery Mall"),
      ),
      body: _bannerData.length > 0
          ? CarouselSlider(
              height: 180,
              viewportFraction: 1.0,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              reverse: false,
              autoPlayCurve: Curves.fastOutSlowIn,
              autoPlay: true,
              items: _bannerData.map((i) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(Mall_Image_Url + i["image"],
                            fit: BoxFit.fill)),
                  );
                });
              }).toList(),
            )
          : Container(),
    );
  }
}
