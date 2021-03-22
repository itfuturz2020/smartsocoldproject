import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Admin_App/Common/Constants.dart' as cnst;
import 'package:smart_society_new/Member_App/screens/WingDetail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../screens/AddMyResidents.dart';
import '../common/constant.dart';

class SetupWings extends StatefulWidget {
  var wingData,societyId;
  String mobileNo;
  SetupWings({this.wingData,this.societyId,this.mobileNo});
  @override
  _SetupWingsState createState() => _SetupWingsState();
}

class _SetupWingsState extends State<SetupWings> {
  ProgressDialog pr;
  bool isLoading = false;
  String _stateDropdownError, _cityDropdownError;
  bool stateLoading = false;
  bool cityLoading = false;

  List<stateClass> stateClassList = [];
  stateClass _stateClass;

  List<cityClass> cityClassList = [];
  cityClass _cityClass;

  String Price_dropdownValue = 'Select';
  var filledOneWing = "";
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtmobile = new TextEditingController();
  TextEditingController txtwings = new TextEditingController();
  List<String> alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait..",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(
              //backgroundColor: cnst.appPrimaryMaterialColor,
              ),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));

    getState();
  }

  getState() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      filledOneWing = prefs.getString('madeAtleastOneWing');
      print("filledOneWing");
      print(filledOneWing);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          stateLoading = true;
        });
        Future res = Services.GetState();
        res.then((data) async {
          setState(() {
            stateLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              stateClassList = data;
            });
            getWingsId(widget.societyId.toString());
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            stateLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        stateLoading = false;
      });
    }
  }

  getCity(String id) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          cityLoading = true;
        });
        Future res = Services.GetCity(id);
        res.then((data) async {
          setState(() {
            cityLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              cityClassList = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            cityLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
      setState(() {
        cityLoading = false;
      });
    }
  }

  bool foundOneRegisteredBuilding = false;

  List winglistClassList = [];
  var wingfilled = "";
  getWingsId(String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetWingsBySocietyId(societyId.split(".")[0]);
        res.then((data) async {
          if (data !=null) {
            setState(() {
              winglistClassList = data;
            });
          for(int i=0;i<winglistClassList.length;i++){
            if(winglistClassList[i]["NoofFloor"].toString()!="0"){
              wingfilled = prefs.getString('madeAtleastOneWing');
              break;
            }
          }
          }
        }, onError: (e) {
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("Something Went Wrong");
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
        title: Text("Setup Wings"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Setup any wing and you will be on dashboard screen.",style: TextStyle(color:cnst.appPrimaryMaterialColor),),
                  ),
                  StaggeredGridView.countBuilder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 4,
                      //itemCount: int.parse(widget.wingData),
                      itemCount: int.parse(widget.wingData),
                      staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: (){
                            print(index);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => WingDetail(
                                  wingName:  "${alphabets[index].toString()}",
                                  wingId: "${winglistClassList[index]["Id"]}",
                                  societyId: "${winglistClassList[index]["SocietyId"]}",
                                )));
                            // Navigator.pushNamed(context, "/WingDetail");
                          },
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Card(
                              borderOnForeground: true,
                              color: Colors.grey[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "${alphabets[index]}",
                                    style: TextStyle(
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              child: FlatButton(
                height: 45,
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  print(prefs.getString('madeAtleastOneWing'));
                  prefs.getString('madeAtleastOneWing') == "true" ?
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             AddMyResidents(
                  //               mobileNo:widget.mobileNo,
                  //               isUpdate : true
                  //             ),
                  //     ),
                  // ):
                  Navigator.pushReplacementNamed(context, '/RegisterScreen')
                      :
                  Fluttertoast.showToast(
                      msg: "Please Submit Details of atleast 1 Wing",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.TOP,
                      textColor: Colors.white);
                  print(foundOneRegisteredBuilding);
                },
                child: const Text(
                  "Finish Setup",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: constant.appPrimaryMaterialColor,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
