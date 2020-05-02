import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/PaymentWebView.dart';

class AdvertisementCreate extends StatefulWidget {
  @override
  _AdvertisementCreateState createState() => _AdvertisementCreateState();
}

class _AdvertisementCreateState extends State<AdvertisementCreate> {
  TextEditingController edtTitle = new TextEditingController();
  TextEditingController edtDescription = new TextEditingController();
  TextEditingController edtWebsiteURL = new TextEditingController();
  TextEditingController edtEmail = new TextEditingController();
  TextEditingController edtVideoLink = new TextEditingController();
  FocusNode myFocusNode;
  String selectedType;
  String selectedLocationType;
  String selectedLocations = "";
  int selected_package;
  File image;

  List _locationsData = [];
  List _packageAllList = [];
  List _packageList = [];
  List _selectedCheckList = [];
  List _paymentDetails = [];

  bool isLoading = false;
  ProgressDialog pr;
  String _lat = "", _long = "";
  bool invisible = true;

  @override
  void initState() {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
    myFocusNode = FocusNode();
    getPackages();
    getPaymentDetails();
    _getLocation();
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _lat = position.latitude.toString();
      _long = position.longitude.toString();
    });
    print(position);
  }

  Future getImage(ImageSource source) async {
    var newImage = await ImagePicker.pickImage(source: source);
    if (newImage != null) {
      setState(() {
        image = newImage;
      });
    }
  }

  getPackages() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPackages();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _packageAllList = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _packageAllList = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getPaymentDetails() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetPaymentDetails();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _paymentDetails = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _paymentDetails = data;
            });
          }
        }, onError: (e) {
          showMsg("Something Went Wrong.\nPlease Try Again");
          setState(() {
            isLoading = false;
          });
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  getLocationData(String selectedType) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (selectedType == "For Society")
          setState(() {
            selectedLocationType = "Society";
          });
        else if (selectedType == "For Area")
          setState(() {
            selectedLocationType = "Area";
          });
        else if (selectedType == "For City")
          setState(() {
            selectedLocationType = "City";
          });
        Future res = Services.GetAdvertiseFor(selectedLocationType);
        pr.show();
        res.then((data) async {
          pr.hide();
          if (data != null && data.length > 0) {
            setState(() {
              _locationsData = data;
            });
            setPackage();
          } else {
            setState(() {
              _locationsData = data;
            });
          }
        }, onError: (e) {
          pr.hide();
          showMsg("Something Went Wrong.\nPlease Try Again");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      pr.hide();
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

  setPackage() async {
    setState(() {
      _packageList.clear();
      selected_package = null;
    });

    for (int i = 0; i < _packageAllList.length; i++) {
      if (_packageAllList[i]["Type"] == selectedLocationType) {
        setState(() {
          _packageList.add(_packageAllList[i]);
        });
      }
    }
  }

  _makePayment() async {
    if (edtTitle.text != "" &&
        edtDescription.text != "" &&
        edtWebsiteURL.text != "" &&
        edtEmail.text != "") {
      final validCharacters =
          RegExp(r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
      //final validCharacters = RegExp(r'^[A-Z]{2}-[0-9]{2}-[A-Z]{2}-[0-9]{4}$');
      var validate = validCharacters.hasMatch(edtEmail.text);
      if (validate == false) {
        Fluttertoast.showToast(
            msg: "Please enter valid E-mail",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      } else {
        DateTime expiredDate = DateTime.now();

        expiredDate = expiredDate
            .add(Duration(days: _packageList[selected_package]["Duration"]));

        var data = {
          "key": "${_paymentDetails[0]["InstaMojoKey"]}",
          "token": "${_paymentDetails[0]["InstaMojoToken"]}",
          "amount": "${double.parse(
            (_packageList[selected_package]["Price"] *
                    _selectedCheckList.length)
                .toString(),
          )}",
          "title": "${edtTitle.text}",
          "desc": "${edtDescription.text}",
          "photo": image,
          "packageId": "${_packageList[selected_package]["Id"]}",
          "expiredDate": "${expiredDate.toString()}",
          "type": "${selectedLocationType}",
          "targetedId": "${selectedLocations}",
          "renew": "false",
          "WebsiteURL": edtWebsiteURL.text,
          "VideoLink": edtVideoLink.text,
          "Email": edtEmail.text,
          "GoogleMap": _lat + "," + _long,
        };

        print(data);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebView(data),
          ),
        );
      }
    } else
      Fluttertoast.showToast(
          msg: "Please Enter All Fields",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Make Promotion"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Advertisement Title",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtTitle,
                                        decoration: InputDecoration(
                                          hintText: "Title",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Description",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: constant.appPrimaryMaterialColor),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              margin: EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, right: 5.0, bottom: 4.0),
                                child: TextFormField(
                                  controller: edtDescription,
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter Description",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400])),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Website URL",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtWebsiteURL,
                                        decoration: InputDecoration(
                                          hintText: "URL",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("E-Mail",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtEmail,
                                        decoration: InputDecoration(
                                          hintText: "Enter E-Mail",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Youtube Video Link",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5.0, right: 5.0, top: 6.0),
                              child: Container(
                                height: 55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: TextFormField(
                                        controller: edtVideoLink,
                                        decoration: InputDecoration(
                                          hintText: "Enter Youtube Video Link",
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[400]),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            constant.appPrimaryMaterialColor),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6.0))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 8.0, left: 8.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Select Photo",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 10, right: 10, bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      color: constant.appPrimaryMaterialColor,
                                      onPressed: () {
                                        getImage(ImageSource.gallery);
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.photo_library,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4)),
                                          Expanded(
                                            child: Text(
                                              "Add from Gallery",
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 8)),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    height: 45,
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      color: Colors.grey[100],
                                      onPressed: () {
                                        getImage(ImageSource.camera);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.camera_alt,
                                            size: 20,
                                            color: constant
                                                .appPrimaryMaterialColor,
                                          ),
                                          Text(
                                            " Camera",
                                            style: TextStyle(
                                                color: constant
                                                    .appPrimaryMaterialColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          //Uploader(file:image),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            image != null
                                ? Image.file(
                                    File(image.path),
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0, right: 5.0, left: 5.0),
                              child: Row(
                                children: <Widget>[
                                  Text("Advertisement For",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                            Container(
                                height: 45,
                                margin: EdgeInsets.all(8.0),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                ),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                  isExpanded: true,
                                  value: selectedType,
                                  hint: Text("Select Type"),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue;
                                      _locationsData.clear();
                                      _selectedCheckList.clear();
                                      FocusScope.of(context)
                                          .requestFocus(myFocusNode);
                                    });
                                    getLocationData(newValue);
                                  },
                                  items: <String>[
                                    'For Society',
                                    'For Area',
                                    'For City',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))),
                            !invisible
                                ? TextFormField(
                                    focusNode: myFocusNode,
                                  )
                                : Container(),
                            _packageList.length > 0
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, right: 8.0, left: 8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text("Select Prefer Package",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500))
                                      ],
                                    ),
                                  )
                                : Container(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: List.generate(_packageList.length,
                                      (index) {
                                    return ChoiceChip(
                                      padding: EdgeInsets.only(
                                          top: 5,
                                          left: 10,
                                          bottom: 5,
                                          right: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      backgroundColor: Colors.grey[200],
                                      selectedColor: Colors.green[400],
                                      label: Column(
                                        children: <Widget>[
                                          Text(
                                            "${_packageList[index]["Title"]}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey[700]),
                                          ),
                                          Text(
                                            "${constant.Inr_Rupee}${_packageList[index]["Price"]}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey),
                                          ),
                                          Text(
                                            "${_packageList[index]["Duration"]} Days",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: selected_package == index
                                                    ? Colors.white
                                                    : Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      selected: selected_package == index,
                                      onSelected: (selected) {
                                        if (selected) {
                                          setState(() {
                                            selected_package = index;
                                            print(_packageList[index]["Title"]);
                                          });
                                        }
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 10)),
                            isLoading
                                ? Container()
                                : _locationsData.length > 0
                                    ? MultiSelectFormField(
                                        autovalidate: false,
                                        titleText:
                                            'Select $selectedLocationType',
                                        validator: (value) {
                                          if (value == null ||
                                              value.length == 0) {
                                            return 'Please select one or more options';
                                          }
                                        },
                                        dataSource: _locationsData,
                                        textField: 'Name',
                                        valueField: 'Id',
                                        okButtonLabel: 'OK',
                                        cancelButtonLabel: 'CANCEL',
                                        hintText:
                                            'Select $selectedLocationType',
                                        value: _selectedCheckList,
                                        onSaved: (value) {
                                          if (value == null) return;
                                          setState(() {
                                            _selectedCheckList = value;
                                            selectedLocations =
                                                _selectedCheckList
                                                    .toString()
                                                    .replaceAll("[", "");
                                            selectedLocations =
                                                selectedLocations
                                                    .toString()
                                                    .replaceAll("]", "");
                                            print(selectedLocations);
                                          });
                                        },
                                      )
                                    : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  _selectedCheckList.length > 0 && selected_package != null
                      ? MaterialButton(
                          height: 45,
                          minWidth: MediaQuery.of(context).size.width,
                          color: constant.appprimarycolors[600],
                          onPressed: () {
                            _makePayment();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Pay Now",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Padding(padding: EdgeInsets.only(left: 15)),
                              Text(
                                "${constant.Inr_Rupee} ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Text(
                                "${double.parse((_packageList[selected_package]["Price"] * _selectedCheckList.length).toString()).toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Padding(padding: EdgeInsets.only(right: 15))
                            ],
                          ))
                      : Container(),
                ],
              ));
  }
}
