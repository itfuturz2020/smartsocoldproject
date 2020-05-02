import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/component/MemberComponent.dart';
import 'package:smart_society_new/Member_App/Mall/Common/ExtensionMethods.dart';

class DirecotryScreen extends StatefulWidget {
  @override
  _DirecotryScreenState createState() => _DirecotryScreenState();
}

class _DirecotryScreenState extends State<DirecotryScreen> {
  List MemberData = new List();
  List FilterMemberData = new List();
  bool isLoading = false, isSelected = false;
  String SocietyId, selectedWing = "";

  TextEditingController _controller = TextEditingController();

  Widget appBarTitle = new Text(
    "Directory",
    style: TextStyle(fontSize: 18),
  );

  List searchMemberData = new List();
  List WingData = new List();
  bool _isSearching = false,
      isfirst = false,
      isFilter = false,
      isMemberLoading = false;

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    GetWingList();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  GetWingList() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetWingData(SocietyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              WingData = data;
              selectedWing = data[0]["Id"].toString();
            });
            GetMemberData(data[0]["Id"].toString());
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

  GetMemberData(selectedWing) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isMemberLoading = true;
        });
        Services.GetMemberByWing(SocietyId, selectedWing).then((data) async {
          setState(() {
            isMemberLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              MemberData = data;
            });
          } else {
            setState(() {
              MemberData = data;
            });
          }
        }, onError: (e) {
          setState(() {
            isMemberLoading = false;
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
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: <Widget>[
                  Container(
                    color: constant.appPrimaryMaterialColor,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    padding: EdgeInsets.only(left: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Members : ${MemberData.length}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < WingData.length; i++) ...[
                        GestureDetector(
                          onTap: () {
                            if (selectedWing != WingData[i]["Id"].toString()) {
                              setState(() {
                                selectedWing = WingData[i]["Id"].toString();
                              });
                              setState(() {
                                MemberData = [];
                                FilterMemberData = [];
                                searchMemberData = [];
                                isFilter = false;
                                _isSearching = false;
                              });
                              GetMemberData(WingData[i]["Id"].toString());
                            }
                          },
                          child: Container(
                            width: selectedWing == WingData[i]["Id"].toString()
                                ? 60
                                : 45,
                            height: selectedWing == WingData[i]["Id"].toString()
                                ? 60
                                : 45,
                            margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                            decoration: BoxDecoration(
                                color:
                                    selectedWing == WingData[i]["Id"].toString()
                                        ? constant.appPrimaryMaterialColor
                                        : Colors.white,
                                border: Border.all(
                                    color: constant.appPrimaryMaterialColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            alignment: Alignment.center,
                            child: Text(
                              "${WingData[i]["WingName"]}",
                              style: TextStyle(
                                  color: selectedWing ==
                                          WingData[i]["Id"].toString()
                                      ? Colors.white
                                      : constant.appPrimaryMaterialColor,
                                  fontSize: 19),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  FlatButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Filter",
                          style: TextStyle(
                              fontSize: 16,
                              color: constant.appPrimaryMaterialColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.filter_list,
                          size: 19,
                          color: constant.appPrimaryMaterialColor,
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return showFilterDailog(
                              onSelect: (gender, isOwned, isOwner, isRented) {
                                String owned = isOwned ? "Owned" : "";
                                String owner = isOwner ? "Owner" : "";
                                String rented = isRented ? "Rented" : "";
                                setState(() {
                                  isFilter = true;
                                  FilterMemberData.clear();
                                });
                                for (int i = 0; i < MemberData.length; i++) {
                                  if (MemberData[i]["MemberData"]["Gender"] ==
                                          gender ||
                                      MemberData[i]["MemberData"]
                                              ["ResidenceType"] ==
                                          owned ||
                                      MemberData[i]["MemberData"]
                                              ["ResidenceType"] ==
                                          owner ||
                                      MemberData[i]["MemberData"]
                                              ["ResidenceType"] ==
                                          rented) {
                                    FilterMemberData.add(MemberData[i]);
                                  }
                                }
                                setState(() {});
                              },
                            );
                          });
                    },
                  ).alignAtEnd(),
                  isMemberLoading
                      ? Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
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
                                  : isFilter
                                      ? FilterMemberData.length > 0
                                          ? ListView.builder(
                                              itemCount:
                                                  FilterMemberData.length,
                                              shrinkWrap: true,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return MemberComponent(
                                                    FilterMemberData[index]);
                                              },
                                            )
                                          : Container(
                                              child: Center(
                                                  child:
                                                      Text("No Member Found")),
                                            )
                                      : MemberData.length > 0 &&
                                              MemberData != null
                                          ? searchMemberData.length > 0
                                              ? ListView.builder(
                                                  itemCount:
                                                      searchMemberData.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return MemberComponent(
                                                        searchMemberData[
                                                            index]);
                                                  },
                                                )
                                              : _isSearching && isfirst
                                                  ? ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      itemCount:
                                                          searchMemberData
                                                              .length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return MemberComponent(
                                                            searchMemberData[
                                                                index]);
                                                      },
                                                    )
                                                  : ListView.builder(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      itemCount:
                                                          MemberData.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return MemberComponent(
                                                            MemberData[index]);
                                                      },
                                                    )
                                          : Container(
                                              child: Center(
                                                  child:
                                                      Text("No Member Found")),
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
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/HomeScreen");
          }),
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
        String mobile = MemberData[i]["MemberData"]["ContactNo"].toString();
        String bloodGroup =
            MemberData[i]["MemberData"]["BloodGroup"].toString();
        String designation =
            MemberData[i]["MemberData"]["Designation"].toString();
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            designation.toLowerCase().contains(searchText.toLowerCase()) ||
            mobile.toLowerCase().contains(searchText.toLowerCase()) ||
            bloodGroup.toLowerCase().contains(searchText.toLowerCase()) ||
            flat.toLowerCase().contains(searchText.toLowerCase())) {
          searchMemberData.add(MemberData[i]);
        }
      }
    }
    setState(() {});
  }
}

class showFilterDailog extends StatefulWidget {
  Function onSelect;

  showFilterDailog({this.onSelect});
  @override
  _showFilterDailogState createState() => _showFilterDailogState();
}

class _showFilterDailogState extends State<showFilterDailog> {
  String _gender;

  bool ownerSelect = false, rentedSelect = false, ownedSelect = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Filter Your Criteria"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Gender",
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Row(
              children: <Widget>[
                Radio(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                Text("Male", style: TextStyle(fontSize: 13)),
                Radio(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    }),
                Text("Female", style: TextStyle(fontSize: 13))
              ],
            ),
          ),
          Text(
            "Residential Type",
            style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600),
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: ownedSelect,
                  onChanged: (bool value) {
                    setState(() {
                      ownedSelect = value;
                    });
                  }),
              Text(
                "Owned",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: rentedSelect,
                  onChanged: (bool value) {
                    setState(() {
                      rentedSelect = value;
                    });
                  }),
              Text(
                "Rented",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Checkbox(
                  activeColor: Colors.green,
                  value: ownerSelect,
                  onChanged: (bool value) {
                    setState(() {
                      ownerSelect = value;
                    });
                  }),
              Text(
                "Owner",
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
            widget.onSelect(_gender, ownedSelect, ownerSelect, rentedSelect);
          },
          child: Text("Done"),
        )
      ],
    );
  }
}
