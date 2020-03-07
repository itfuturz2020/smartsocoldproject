import 'dart:io';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:smart_society_new/Services/ServiceList.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool isLoading = false;
  List ServiceData = new List();

  @override
  void initState() {
    _ServiceData();
  }

  _ServiceData() async {
    try {

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetServices().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              ServiceData = data;
              print(data);
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

  Widget _getServiceMenu(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      columnCount: 4,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 100,
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ServiceList(
                    ServiceData[index],
                  ),
                ),
              );
            },
            child: Card(
              elevation: 1,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8,left: 4,right: 4,bottom: 4),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                            placeholder: "images/placeholder.png",
                            image: Image_Url + '${ServiceData[index]["Image"]}',
                            width: 35,
                            height: 35),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 3),
                            child: Text(
                              '${ServiceData[index]["Title"]}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final _imageUrls = [
    "http://cashkaro.com/blog/wp-content/uploads/sites/5/2018/03/Housejoy-AC-Service-Offer.gif",
    "https://www.cleaningbyrosie.com/wp-content/uploads/2016/12/facebook-cover2-630x315.jpg",
    "https://i.ytimg.com/vi/FTguamlXGWs/maxresdefault.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/HomeScreen");
              }),
          centerTitle: true,
          title: Text(
            'Vendor Services',
            style: TextStyle(fontSize: 18),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Container(
                  child: CarouselSlider(
                height: 115,
                // aspectRatio: 16/5,
                viewportFraction: 0.8,
                initialPage: 0,
                // enlargeCenterPage: true,
                reverse: false,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlay: true,
                items: _imageUrls.map((i) {
                  return Builder(builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 4.0, right: 4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: FadeInImage.assetNetwork(
                          placeholder: "images/placeholder.png",
                          image: '$i',
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  });
                }).toList(),
              )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                      child: isLoading
                          ? Container(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : ServiceData.length > 0
                              ? GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: ServiceData.length,
                                  itemBuilder: _getServiceMenu,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
//                                childAspectRatio: MediaQuery.of(context)
//                                        .size
//                                        .width /
//                                    (MediaQuery.of(context).size.height /1.8),
                                  ))
                              : Container()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
