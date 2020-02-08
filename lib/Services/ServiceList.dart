import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_society_new/Services/ServiceDetailScreen.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceList extends StatefulWidget {
  var ServiceData;

  ServiceList(this.ServiceData);

  @override
  _ServiceListState createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  bool isLoading = true;
  List _serviceListData = [];
  List _vendorData = [];

  @override
  void initState() {
    print("Service Id" + widget.ServiceData["Id"].toString());
    _getServiceData();
    _getVendorData();
  }

  _getServiceData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetServicesData(widget.ServiceData["Id"].toString()).then(
            (Data) async {
          setState(() {
            isLoading = false;
          });
          if (Data != null && Data.length > 0) {
            setState(() {
              _serviceListData = Data;
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

  _getVendorData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetVendorData(widget.ServiceData["Id"].toString()).then(
            (Data) async {
          setState(() {
            isLoading = false;
          });
          if (Data != null && Data.length > 0) {
            setState(() {
              _vendorData = Data;
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

  Widget _serviceWidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetail(_serviceListData[index]),
          ),
        );
      },
      child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FadeInImage.assetNetwork(
                      placeholder: "images/placeholder.png",
                      image: Image_Url + '${_serviceListData[index]["Image"]}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${_serviceListData[index]["Title"]}',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Container(
                            height: 1,
                            color: Colors.grey[200],
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        _serviceListData[index]["ServicePackagePrice"].length >
                                0
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    "₹" +
                                        " " +
                                        '${_serviceListData[index]["ServicePackagePrice"][0]["Price"]}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green)),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget _vendorWidget(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetail(_serviceListData[index]),
          ),
        );
      },
      child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: Card(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.grey, width: 0.4)),
                        width: 76,
                        height: 76,
                      ),
                      ClipOval(
                        child: _vendorData[index]["Image"] != "null" &&
                                _vendorData[index]["Image"] != ""
                            ? FadeInImage.assetNetwork(
                                placeholder: "images/image_loading.gif",
                                image: Image_Url +
                                    '${_vendorData[index]["Image"]}',
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "images/man.png",
                                width: 70,
                                height: 70,
                              ),
                      ),
                    ],
                    alignment: Alignment.center,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('${_vendorData[index]["Name"]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17)),
                          Text('${_vendorData[index]["ContactNo"]}',
                              style: TextStyle(
                                color: Colors.grey,
                              )),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.home,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Padding(padding: EdgeInsets.only(left: 4)),
                              Text('${_vendorData[index]["Address"]}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.comment,
                                color: Colors.grey,
                                size: 15,
                              ),
                              Padding(padding: EdgeInsets.only(left: 4)),
                              Text('${_vendorData[index]["About"]}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.call, color: Colors.green[700]),
                      onPressed: () {
                        launch("tel:${_vendorData[index]["ContactNo"]}");
                      }),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 120.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text('${widget.ServiceData["Title"]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        )),
                    background: Stack(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          placeholder: "",
                          image: Image_Url +
                              '${widget.ServiceData["BannerImage"]}',
                          fit: BoxFit.fill,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 175,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Services"),
                        Tab(text: "Vendors"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: isLoading
                ? Container(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : TabBarView(
                    children: <Widget>[
                      _serviceListData.length > 0
                          ? ListView.builder(
                              itemBuilder: _serviceWidget,
                              itemCount: _serviceListData.length,
                            )
                          : Container(
                              child: Center(child: Text("No Data Found")),
                            ),
                      _vendorData.length > 0
                          ? ListView.builder(
                              itemBuilder: _vendorWidget,
                              itemCount: _vendorData.length,
                            )
                          : Container(
                              child: Center(child: Text("No Data Found")),
                            ),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {},
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            color: Colors.blue[400],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("images/AMC.png",
                    height: 30, width: 30, color: Colors.white),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("GET AMC",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
