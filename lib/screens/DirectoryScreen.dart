import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/component/MemberComponent.dart';
import 'package:smart_society_new/screens/MemberProfile.dart';

class DirecotryScreen extends StatefulWidget {
  String wingType, wingId;

  DirecotryScreen({this.wingType, this.wingId});

  @override
  _DirecotryScreenState createState() => _DirecotryScreenState();
}

class _DirecotryScreenState extends State<DirecotryScreen> {
  List MemberData = new List();
  bool isLoading = false;
  String SocietyId;

  TextEditingController _controller = TextEditingController();

  Widget appBarTitle = new Text(
    "Directory",
    style: TextStyle(fontSize: 18),
  );

  List searchMemberData = new List();
  bool _isSearching = false, isfirst = false;

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    GetMemberData();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  GetMemberData() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetMemberByWing(SocietyId, widget.wingId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              MemberData = data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: isLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : MemberData.length > 0 && MemberData != null
                          ? searchMemberData.length > 0
                              ? ListView.builder(
                                  itemCount: searchMemberData.length,
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MemberComponent(
                                        searchMemberData[index]);
                                  },
                                )
                              : _isSearching && isfirst
                                  ? ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: searchMemberData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MemberComponent(
                                            searchMemberData[index]);
                                      },
                                    )
                                  : ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      itemCount: MemberData.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return MemberComponent(
                                            MemberData[index]);
                                      },
                                    )
                          : Container(
                              child: Center(child: Text("No Member Found")),
                            ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(
          icon: icon,
          onPressed: () {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          },
        ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text('Member Directory');
      _isSearching = false;
      isfirst = false;
      searchMemberData.clear();
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchMemberData.clear();
    if (_isSearching != null) {
      isfirst = true;
      for (int i = 0; i < MemberData.length; i++) {
        String name = MemberData[i]["MemberData"]["Name"];
        String flat = MemberData[i]["MemberData"]["FlatNo"].toString();
        String bloodGroup =
            MemberData[i]["MemberData"]["BloodGroup"].toString();
        String designation =
            MemberData[i]["MemberData"]["Designation"].toString();
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            designation.toLowerCase().contains(searchText.toLowerCase()) ||
            bloodGroup.toLowerCase().contains(searchText.toLowerCase()) ||
            flat.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(MemberData[i]);
        }
      }
    }
    setState(() {});
  }
}
