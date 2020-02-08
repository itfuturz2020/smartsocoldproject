import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/screens/updateMemberdetailform.dart';

class GetMyFamily extends StatefulWidget {
  @override
  _GetMyFamilyState createState() => _GetMyFamilyState();
}

class _GetMyFamilyState extends State<GetMyFamily> {
  List FmemberData = new List();
  bool isLoading = false;
  String SocietyId, MemberId, ParentId;

  @override
  void initState() {
    GetFamilyDetail();
    _getLocaldata();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
    MemberId = prefs.getString(constant.Session.Member_Id);
    if (prefs.getString(constant.Session.ParentId) == "null" ||
        prefs.getString(constant.Session.ParentId) == "")
      ParentId = "0";
    else
      ParentId = prefs.getString(constant.Session.ParentId);
  }

  GetFamilyDetail() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetFamilyMember(ParentId, MemberId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              FmemberData = data;
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


  _DeleteFamilyMember(String Id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.DeleteFamilyMember(Id).then((data) async {
          if (data.Data == "1") {
            setState(() {
              isLoading = false;
            });
            GetFamilyDetail();
          } else {
            isLoading = false;
            showHHMsg("Member Is Not Deleted", "");
          }
        }, onError: (e) {
          isLoading = false;
          showHHMsg("$e", "");
          isLoading = false;
        });
      } else {
        showHHMsg("No Internet Connection.", "");
      }
    } on SocketException catch (_) {
      showHHMsg("Something Went Wrong", "");
    }
  }

  void _showConfirmDialog(String Id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("My Jini"),
          content: new Text("Are You Sure You Want To Delete this Member ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
                _DeleteFamilyMember(Id);
              },
            ),
          ],
        );
      },
    );
  }



  Widget _FamilyMember(BuildContext context, int index) {
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 6.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        image: DecorationImage(
                            image: AssetImage("images/man.png")
                        )
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, left: 6.0),
                      child: Text("${FmemberData[index]["Name"]}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Color.fromRGBO(81,92,111,1)),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 6.0),
                      child: Text("${FmemberData[index]["ContactNo"]}",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,color: Colors.black54),),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text("    Gender:",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,color: Color.fromRGBO(81,92,111,1)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 6.0),
                    child: Text("${FmemberData[index]["Gender"]}",
                      style: TextStyle(fontSize: 14,color: Colors.black54),)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: Text(" Relation:",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,color: Color.fromRGBO(81,92,111,1)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0.0, left: 6.0),
                    child: Text("${FmemberData[index]["Relation"]}",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.black54),),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => updateFamilyMemberForm(FmemberData[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:4.0),
                    child: Container(
                      width: 70,
                      height: 35,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.edit,color: Colors.green,size: 20,),
                            Text("Edit",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.green,fontSize: 15),)
                          ],
                        )
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                     _showConfirmDialog(FmemberData[index]["Id"].toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom:4.0),
                    child: Container(
                      width: 70,
                      height: 35,
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.delete,color: Colors.red,size: 20,),
                              Text("Delete",style: TextStyle(fontWeight: FontWeight.w600,color: Colors.red,fontSize: 15),)
                            ],
                          )
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Family"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator(),),) : FmemberData
            .length > 0 ? ListView.builder(itemBuilder: _FamilyMember,
            itemCount: FmemberData.length,
            shrinkWrap: true
        ):Container(
          child: Center(child: Text("No FamilyMember Added")),
        )
    );
  }
}
