import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Classlist.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
import '../common/constant.dart' as constant;

class AddStaff extends StatefulWidget {
  @override
  _AddStaffState createState() => _AddStaffState();
}

class _AddStaffState extends State<AddStaff> {
  List<staffClass> _staffTypeList = [];
  staffClass _staffClass;
  bool isLoading = false;
  File image;
  ProgressDialog pr;
  int wingflatcount = 0;
  File _image;
  String Gender;

  TextEditingController txtName = TextEditingController();
  TextEditingController txtaddress = TextEditingController();
  TextEditingController txtagencyname = TextEditingController();
  TextEditingController txtContactNo = TextEditingController();
  TextEditingController txtvoterId = TextEditingController();
  TextEditingController txtwingflatcount = TextEditingController();
  TextEditingController vehiclenotext = TextEditingController();
  TextEditingController adharnumbertxt = TextEditingController();
  TextEditingController worktext = TextEditingController();
  TextEditingController purposetext = TextEditingController();
  TextEditingController txtemergencyNo = TextEditingController();
  TextEditingController txtusername = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  List<WingClass> wingclasslist = [];
  String SelectType;
  String SocietyId,fcmToken;
  WingClass wingClass;
  bool _WingLoading = false;
  List FlatData = [];
  List _selectedFlatlist = [];
  StaffType staffType;
  bool _StaffLoading = false;
  List<StaffType> stafftypelist = [];

  List finalSelectList = [];
  List allFlatList = [];
  List allWingList = [];

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    _StaffType();
    _getLocaldata();
    _WingListData();
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  DateTime SelectedDOB = DateTime.now();
  DateTime SelectedDOJ = DateTime.now();

  Future<Null> _selectDOB(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOB,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOB)
      setState(() {
        SelectedDOB = picked;
      });
  }

  Future<Null> _selectedDOJ(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: SelectedDOJ,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2050));
    if (picked != null && picked != SelectedDOJ)
      setState(() {
        SelectedDOJ = picked;
      });
  }

  _WingListData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetWinglistData(SocietyId);
        setState(() {
          _WingLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _WingLoading = false;
              wingclasslist = data;
            });
          } else {
            setState(() {
              _WingLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _WingLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  _StaffType() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.getRoleType();
        setState(() {
          _StaffLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _StaffLoading = false;
              stafftypelist = data;
            });
          } else {
            setState(() {
              _StaffLoading = false;
            });
          }
        }, onError: (e) {
          setState(() {
            _StaffLoading = false;
          });
          Fluttertoast.showToast(
              msg: "Something Went Wrong", toastLength: Toast.LENGTH_LONG);
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _WingLoading = false;
      });
      Fluttertoast.showToast(
          msg: "No Internet Access", toastLength: Toast.LENGTH_LONG);
    }
  }

  showMsg(String msg, {String title = 'My JINI'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  GetFlatData(String WingId) async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          pr.show();
        });

        Services.getFlatData(WingId).then((data) async {
          setState(() {
            pr.hide();
          });
          if (data != null && data.length > 0) {
            setState(() {
              FlatData = data;
            });
            print("----->" + data.toString());
          } else {
            setState(() {
              pr.hide();
            });
          }
        }, onError: (e) {
          setState(() {
            pr.hide();
          });
          showHHMsg("Try Again.", "");
        });
      } else {
        setState(() {
          pr.hide();
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
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              color: Colors.grey[100],
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

  _SaveStaff(
      String societyId,
      String memberName,
      String mobileNo,
      String username,
      String password,
      String fcmToken,
      String roleId) async {
    if (txtusername.text != "" && txtpassword.text != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          pr.show();
          Services.AddStaff(
              societyId,
              memberName,
              mobileNo,
              username,
              password,
              fcmToken,
              roleId).then((data) async {
            pr.hide();
            if (data.Data != "0" && data.IsSuccess == true) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Dashboard', (Route<dynamic> route) => false);
            } else {
              pr.hide();
              showMsg(data.Message, title: "Error");
            }
          }, onError: (e) {
            pr.hide();
            showMsg("Try Again.");
          });
        }
      } on SocketException catch (_) {
        pr.hide();
        showMsg("No Internet Connection.");
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Fill All Fields",
          backgroundColor: Colors.red,
          gravity: ToastGravity.TOP,
          textColor: Colors.white);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
      });
      print("FCM Token : $fcmToken");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Add Staff",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _image == null
                              ? Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: AssetImage(
                                        'images/user.png'),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5,
                                    color: Colors.white)),
                          )
                              : Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                                image: new DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.all(
                                    new Radius.circular(75.0)),
                                border: Border.all(
                                    width: 2.5,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 4.0, top: 10.0),
                        child: Text(
                          "Select StaffType",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius:
                              BorderRadius.all(Radius.circular(6.0))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton<StaffType>(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                  ),
                                  hint: stafftypelist.length > 0
                                      ? Text("Select Staff Type",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))
                                      : Text(
                                    "staff Type Not Found",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: staffType,
                                  onChanged: (val) {
                                    print(val.TypeName);
                                    setState(() {
                                      staffType = val;
                                    });
                                  },
                                  items: stafftypelist
                                      .map((StaffType stafftype) {
                                    return new DropdownMenuItem<StaffType>(
                                      value: stafftype,
                                      child: Text(
                                        stafftype.TypeName,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );
                                  }).toList(),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtName,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "Staff Name",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtContactNo,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            counterText: "",
                            labelText: "Contact Number",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtusername,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "User Name",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      height: 50,
                      child: TextFormField(
                        controller: txtpassword,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            labelText: "Password",
                            hasFloatingPlaceholder: true,
                            labelStyle: TextStyle(fontSize: 13)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SizedBox(
          height: 45,
          child: MaterialButton(
            color: constant.appPrimaryMaterialColor,
            minWidth: MediaQuery.of(context).size.width - 20,
            onPressed: () {
              if(txtName.text=="" || txtContactNo.text.length!=10 || txtusername.text=="" || txtpassword.text==""){
                Fluttertoast.showToast(
                    msg: "Please fill all the fields",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.BOTTOM,
                    textColor: Colors.white);
              }
              else{
                _SaveStaff(
                    SocietyId,
                    txtName.text,
                    txtContactNo.text,
                    txtusername.text,
                    txtpassword.text,
                    fcmToken,staffType.TypeId,
                );
              }
            },
            child: Text(
              "Add Staff",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
