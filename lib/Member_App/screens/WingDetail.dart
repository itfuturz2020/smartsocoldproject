import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/WingFlat.dart';
import '../common/Services.dart';
import 'dart:io';
import 'package:progress_dialog/progress_dialog.dart';

class WingDetail extends StatefulWidget {
  var wingName,wingId,societyId;
  WingDetail({this.wingName,this.wingId,this.societyId});
  @override
  _WingDetailState createState() => _WingDetailState();
}

class _WingDetailState extends State<WingDetail> {
  int _currentindex;
  ProgressDialog pr;
  List<List<String>> format = [
    ["301", "302", "303", "201", "202", "203", "101", "102", "103"],
    ["7", "8", "9", "4", "5", "6", "1", "2", "3"],
    ["201", "202", "203", "101", "102", "103", "G1", "G2", "G3"],
    ["4", "5", "6", "1", "2", "3", "G1", "G2", "G3"],
    ["103", "203", "303", "102", "202", "302", "101", "201", "301"]
  ];
  TextEditingController txtname = new TextEditingController();
  TextEditingController txtfloor = new TextEditingController();
  TextEditingController txtUnit = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.societyId);
    print(widget.wingId);
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: "Please Wait",
        borderRadius: 10.0,
        progressWidget: Container(
          padding: EdgeInsets.all(15),
          child: CircularProgressIndicator(),
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600));
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

  createNewWing(String WingName, String NoOfFloor, String FlatsPerFloor, String wingId, String societyId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        pr.show();
        Future res = Services.UpdateWingName(WingName,NoOfFloor,FlatsPerFloor,wingId,societyId);
        res.then((data) async {
          print("data");
          print(data);
          if (data.toString()=="1") {
            pr.hide();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => WingFlat(
                floorData: txtfloor.text,
                maxUnitData: txtUnit.text,
                formatData: _currentindex,
                societyId: widget.societyId,
                wingId: widget.wingId,
                wingName: widget.wingName,
              ),
            ),
            );
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("yes");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wing - " + widget.wingName),
        centerTitle: true,
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "") {
                    return 'Please Enter Name';
                  }
                  return null;
                },
                controller: txtname,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    // labelText: "Enter Name",
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Total Floor",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Total Floor';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtfloor,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Total Floor',
                    // labelText: "Total Floor",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Maximum Unit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Maximum Unit';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtUnit,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Maximum Units',
                    // labelText: "Maximum Units",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Choose Number Format",
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]))
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: format.length,
                  staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentindex = index;
                          });
                          print("wing select-> " + _currentindex.toString());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  _currentindex == index ? Border.all() : null),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][0]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][1]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][2]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][3]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][4]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][5]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][6]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][7]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 3.0),
                                        child: Container(
                                          height: 30,
                                          width: 45,
                                          decoration: BoxDecoration(
                                              color: constant
                                                      .appPrimaryMaterialColor[
                                                  500]),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "${format[index][8]}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
            ),
          )
        ],
      ),
      bottomNavigationBar: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(),
          color: constant.appPrimaryMaterialColor,
          textColor: Colors.white,
          splashColor: Colors.white,
          child: Text("Create",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          onPressed: () {
            if(txtname.text=="" || txtfloor.text == "" || txtUnit.text=="" || _currentindex == null){
              Fluttertoast.showToast(
                  msg: "Please Fill All Details",
                  backgroundColor: Colors.red,
                  gravity: ToastGravity.TOP,
                  textColor: Colors.white);
            }
            else{
              createNewWing(txtname.text, txtfloor.text, txtUnit.text, widget.wingId, widget.societyId);
            }
            // Navigator.pushNamed(context, '/WingFlat');
          },
        ),
      ),
    );
  }
}
