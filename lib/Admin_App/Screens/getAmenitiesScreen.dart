import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:smart_society_new/Admin_App/Component/LoadingComponent.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;



class getAmenitiesScreen extends StatefulWidget {
  @override
  _getAmenitiesScreenState createState() => _getAmenitiesScreenState();
}

class _getAmenitiesScreenState extends State<getAmenitiesScreen> {
  List _aminitiesData = new List();
  bool isLoading = false;

  @override
  void initState() {
    _getAmenities();
  }

  _getAmenities() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetAmenities().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              _aminitiesData = data;
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Amenities',
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navigator.pushNamed(context, "/AddNotice");
            Navigator.pushReplacementNamed(context, '/AddAmenitiesScreen');
          },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: cnst.appPrimaryMaterialColor,
        ),
        body: isLoading
            ? LoadingComponent()
            : _aminitiesData.length > 0
            ? Container(
          child: Swiper(
            itemBuilder: (BuildContext, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FadeInImage.assetNetwork(
                      placeholder: "images/placeholder.png",
                      image: Image_Url +
                          '${_aminitiesData[index]["Photo"]}',
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    ),
                    Padding(padding: EdgeInsets.only(top: 15)),
                    Text(
                      "${_aminitiesData[index]["Name"]}",
                      style: TextStyle(
                          fontSize: 20,
                          color: constant.appPrimaryMaterialColor,
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 17.0, left: 30, right: 30),
                      /*child: Text(
                                  "A swimming pool, swimming bath, wading pool, paddling pool, or simply pool is a structure designed to hold water to enable swimming or other leisure activities",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: constant.appprimarycolors[400],
                                  ),
                                ),*/
                    ),
                    Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: <Widget>[
                              Text("${_aminitiesData[index]["Type"]}",
                                  style: TextStyle(
                                      color: _aminitiesData[index]
                                      ["Type"]
                                          .toString()
                                          .toLowerCase() ==
                                          "free"
                                          ? Colors.green
                                          : Colors.orange,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700)),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.verified_user,
                                    size: 18,
                                    color: _aminitiesData[index]
                                    ["Type"]
                                        .toString()
                                        .toLowerCase() ==
                                        "free"
                                        ? Colors.green
                                        : Colors.orange),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              new Radius.circular(10.0)),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _aminitiesData[index]["Description"] ==
                          "" ||
                          _aminitiesData[index]["Description"] ==
                              null
                          ? Container()
                          : Text(_aminitiesData[index]["Description"],
                          textAlign: TextAlign.center),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Avaliable Timing",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "${_aminitiesData[index]["AvailableTimeSlot"]}",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: _aminitiesData.length,
            pagination: new SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.grey[400],
                )),
//                      control: new SwiperControl(size: 17),
          ),
        )
            : Container(
          child: Center(child: Text("No Data Found")),
        ),
      ),
    );
  }
}
