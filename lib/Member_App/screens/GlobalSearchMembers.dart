import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/Services/ServiceList.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/component/GlobalMemberComponent.dart';

class GlobalSearchMembers extends StatefulWidget {
  String searchText;

  GlobalSearchMembers({this.searchText});

  @override
  _GlobalSearchMembersState createState() => _GlobalSearchMembersState();
}

class _GlobalSearchMembersState extends State<GlobalSearchMembers> {
  bool _isSearching = false, isfirst = false;
  TextEditingController _searchcontroller = new TextEditingController();
  String SocietyId, WingId = "0";
  bool isLoading = false;

  List searchMemberData = [];
  List serviceData = [];

  @override
  void initState() {
    if (widget.searchText != "" && widget.searchText != null) {
      setState(() {
        _searchcontroller.text = widget.searchText;
      });
      _getSearchData(widget.searchText);
    }
  }

  _getSearchData(String searchText) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetSearchData(searchText).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              searchMemberData = data[0];
              serviceData = data[1];
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
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              controller: _searchcontroller,
              keyboardType: TextInputType.text,
              cursorRadius: Radius.circular(3),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _getSearchData(_searchcontroller.text);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: Icon(
                        Icons.search,
                        color: constant.appPrimaryMaterialColor,
                        size: 23,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  hintText: "Search Here",
                  hintStyle: TextStyle(
                      fontSize: 13, color: Color.fromRGBO(255, 255, 255, 0.5))),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  searchMemberData.length > 0
                      ? Card(
                          child: Container(
                            height: serviceData.length > 0
                                ? MediaQuery.of(context).size.height / 2.2
                                : MediaQuery.of(context).size.height,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  color: Colors.grey,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Member Matches",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: searchMemberData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GlobalMemberComponent(
                                          searchMemberData[index]);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  serviceData.length > 0
                      ? Card(
                          child: Container(
                            height: searchMemberData.length > 0
                                ? MediaQuery.of(context).size.height / 2.2
                                : MediaQuery.of(context).size.height,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, left: 5, bottom: 5),
                                  color: Colors.grey,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Services Matches",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Expanded(
                                  child: ListView.separated(
                                    physics: BouncingScrollPhysics(),
                                    itemCount: serviceData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ServiceList(
                                                serviceData[index],"",""
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              FadeInImage.assetNetwork(
                                                placeholder: "",
                                                image: constant.Image_Url +
                                                    serviceData[index]
                                                        ["BannerImage"],
                                                width: 70,
                                                height: 70,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 12)),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    "${serviceData[index]["Title"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: constant
                                                            .appPrimaryMaterialColor),
                                                  ),
                                                  Text(
                                                    "${serviceData[index]["Description"]}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return Divider();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
