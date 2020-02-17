import 'dart:async';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Model/ModelClass.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:smart_society_new/screens/GlobalSearchMembers.dart';

//import 'package:speech_recognition/speech_recognition.dart';
import 'package:draggable_fab/draggable_fab.dart';

import 'AdvertismentDetailPage.dart';

class HomeScreen extends StatefulWidget {
  String payload;
 // HomeScreen({this.payload});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  // SpeechRecognition _speechRecognition;

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";
  String searchedText = "";

  final List<Menu> _allMenuList = Menu.allMenuItems();

  bool dialVisible = true;
  int _current = 0;

  List _advertisementData = [];
  bool isLoading = true;

  TextEditingController resultText = new TextEditingController();
  PermissionStatus _permissionStatus = PermissionStatus.unknown;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    _getLocaldata();
    getAdvertisementData();
    // initSpeechRecognizer();
    if (Platform.isIOS) {
      iosSubscription =
          _firebaseMessaging.onIosSettingsRegistered.listen((data) {
        print("FFFFFFFF" + data.toString());
        saveDeviceToken();
      });
      _firebaseMessaging
          .requestNotificationPermissions(IosNotificationSettings());
    } else {
      saveDeviceToken();
    }
  }

  /*void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText.text = speech),
    );
    _speechRecognition.setRecognitionCompleteHandler(() {
      print("searched Text->" + resultText.text);
      if (resultText.text != "") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GlobalSearchMembers(
              searchText: resultText.text,
            ),
          ),
        );
      }
    });
  }*/

  getAdvertisementData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.GetAllAdvertisement();
        setState(() {
          isLoading = true;
        });
        res.then((data) async {
          if (data != null && data.length > 0) {
            setState(() {
              _advertisementData = data;
              isLoading = false;
            });
          } else {
            setState(() {
              isLoading = false;
              _advertisementData = data;
            });
          }
        }, onError: (e) {
          showMsg("$e");
          setState(() {
            isLoading = false;
          });
        });
      } else {
        showMsg("No Internet Connection.");
        setState(() {
          isLoading = false;
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
      setState(() {
        isLoading = false;
      });
    }
  }
/*
  getProfilePR() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        Services.GetProfilePer().then((data) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (data.Data != "0") {
            setState(() {
              isLoading = false;
            });
            await prefs.setString(constant.Session.ProfileUpdateFlag, "false");
            _showProfileUpdateDailog(data.Data);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }, onError: (e) {
          showMsg("$e");
        });
      } else {
        showMsg("No Internet Connection.");
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
      });
      showMsg("Something Went Wrong");
    }
  }
*/

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

/*
  _showProfileUpdateDailog(String pr) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: <Widget>[
              Image.asset(
                "images/profile_update.png",
                width: 60,
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  "Hello, $Name",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          titlePadding: EdgeInsets.only(top: 10),
          content: Text(
            "Your Profile Is ${100 - int.parse(pr)}% completed.\nPlease Complete Your Profile To Get Better Experience",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          actions: <Widget>[
            MaterialButton(
              minWidth: 100,
              child: Text(
                "Update",
                style: TextStyle(color: Colors.white),
              ),
              padding: EdgeInsets.only(left: 10, right: 10),
              color: constant.appPrimaryMaterialColor,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/MyProfile');
              },
            ),
            MaterialButton(
              minWidth: 100,
              child: Text(
                "Not Now",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.grey[600],
              padding: EdgeInsets.only(left: 10, right: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
*/

  Widget _getMenuItem(BuildContext context, int index) {
    return AnimationConfiguration.staggeredGrid(
      position: index,
      duration: const Duration(milliseconds: 375),
      columnCount: 4,
      child: SlideAnimation(
        child: ScaleAnimation(
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, '/${_allMenuList[index].IconName}');
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    //  bottom: BorderSide(width: ,color: Colors.black54),
                    top: BorderSide(width: 0.1, color: Colors.black)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(width: 0.2, color: Colors.grey[600]),
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "images/" + _allMenuList[index].Icon,
                        width: 25,
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _allMenuList[index].IconName,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("My JINI"),
          content: new Text("Are You Sure You Want To Exit?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, "/LoginScreen");
  }

  String SocietyId, Name, Wing, FlatNo, Profile;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      Name = prefs.getString(constant.Session.Name);
      Wing = prefs.getString(constant.Session.Wing);
      FlatNo = prefs.getString(constant.Session.FlatNo);
      Profile = prefs.getString(constant.Session.Profile);
    });
   /* if (prefs.getString(constant.Session.ProfileUpdateFlag) == "true")
      getProfilePR();*/
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press Back Again to Exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  saveDeviceToken() async {
    _firebaseMessaging.getToken().then((String token) {
      print("Original Token:$token");
      var tokendata = token.split(':');
      setState(() {
        fcmToken = token;
        sendFCMTokan(token);
      });
      print("FCM Token : $fcmToken");
    });
  }

  sendFCMTokan(var FcmToken) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Future res = Services.SendTokanToServer(FcmToken);
        res.then((data) async {}, onError: (e) {
          print("Error : on Login Call");
        });
      }
    } on SocketException catch (_) {}
  }

  Future<void> requestPermission(PermissionGroup permission) async {
    final List<PermissionGroup> permissions = <PermissionGroup>[
      PermissionGroup.microphone
    ];
    final Map<PermissionGroup, PermissionStatus> permissionRequestResult =
        await PermissionHandler().requestPermissions(permissions);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult[permission];
      print(_permissionStatus);
    });
    if (permissionRequestResult[permission] == PermissionStatus.granted) {
      setState(() {
        resultText.text = "";
      });
      // _voiceInput();
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

/*
  _voiceInput() async {
//    _speechRecognition.listen(locale: "en_US").then((result) {
//      print('$result');
//    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            "images/record.gif",
            height: 100,
            width: MediaQuery.of(context).size.width,
          ),
          titlePadding: EdgeInsets.only(bottom: 10, top: 10),
          content: Container(
            height: 70,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: Colors.grey)),
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: resultText,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/MyProfile');
                  },
                  child: Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                border:
                                    Border.all(color: Colors.grey, width: 0.4)),
                            width: 76,
                            height: 76,
                          ),
                          ClipOval(
                            child: Profile != "null" && Profile != ""
                                ? FadeInImage.assetNetwork(
                                    placeholder: "images/image_loading.gif",
                                    image: constant.Image_Url + '$Profile',
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
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Text("$Name",
                                    style: TextStyle(
                                        //color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 2, left: 0),
                                child: Text("$Wing" " - " "$FlatNo"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'My Visitor',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.person_pin,
                  color: constant.appPrimaryMaterialColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/MyGuestList");
                },
              ),
              ListTile(
                title: Text(
                  'Manage Advertisement',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.assessment,
                  color: constant.appPrimaryMaterialColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, "/AdvertisementManage");
                },
              ),
              ListTile(
                title: Text(
                  "Society Amenities",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.local_laundry_service,
                  color: constant.appPrimaryMaterialColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, "/Amenities");
                },
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                leading: Icon(
                  Icons.exit_to_app,
                  color: constant.appPrimaryMaterialColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showConfirmDialog();
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: constant.appPrimaryMaterialColor,
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.black,
                      blurRadius: 2.0,
                    ),
                  ]),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _scaffoldKey.currentState.openDrawer();
                          }),
                      Padding(padding: EdgeInsets.only(left: 4)),
                      Expanded(
                        child: Text(
                          "MY JINI",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.notifications,
                              color: Colors.white, size: 20),
                          onPressed: () {})
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/GlobalSearch");
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          top: 5, left: 15, right: 15, bottom: 10),
                      height: 40,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      //width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 15,
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Expanded(
                            child: Text(
                              "Search...",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          /*IconButton(
                              icon: Icon(
                                Icons.keyboard_voice,
                                color: constant.appPrimaryMaterialColor,
                              ),
                              onPressed: () {
                                requestPermission(PermissionGroup.microphone);
                              })*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            Expanded(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _advertisementData.length > 0
                              ? Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    CarouselSlider(
                                      height: 170,
                                      viewportFraction: 1.0,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1500),
                                      reverse: false,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      autoPlay: true,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                      items: _advertisementData.map((i) {
                                        return Builder(
                                            builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdvertisemnetDetail(
                                                    i,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.network(
                                                    Image_Url + i["Image"],
                                                    fit: BoxFit.fill)),
                                          );
                                        });
                                      }).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: map<Widget>(
                                        _advertisementData,
                                        (index, url) {
                                          return Container(
                                            width: 7.0,
                                            height: 7.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: _current == index
                                                    ? Colors.white
                                                    : Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[500], width: 0.3))),
                            child: AnimationLimiter(
                              child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: _getMenuItem,
                                itemCount: _allMenuList.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height /
                                              2.3),
                                ),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 10)),
                          _advertisementData.length > 0
                              ? Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    CarouselSlider(
                                      height: 170,
                                      viewportFraction: 1.0,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 1500),
                                      reverse: false,
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      autoPlay: true,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _current = index;
                                        });
                                      },
                                      items: _advertisementData.map((i) {
                                        return Builder(
                                            builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdvertisemnetDetail(
                                                    i,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Image.network(
                                                    Image_Url + i["Image"],
                                                    fit: BoxFit.fill)),
                                          );
                                        });
                                      }).toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: map<Widget>(
                                        _advertisementData,
                                        (index, url) {
                                          return Container(
                                            width: 7.0,
                                            height: 7.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: _current == index
                                                    ? Colors.white
                                                    : Colors.grey),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
            ),
            SafeArea(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.3))),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.home),
                              Text("Home",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        onTap: () {},
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person_pin),
                              Text("Add Visitor",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/MyGuestList");
                        },
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.new_releases),
                              Text("Advertisement",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11))
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/AdvertisementCreate');
                        },
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.person),
                              Text("Profile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/MyProfile');
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: DraggableFab(
          child: SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              onPressed: () {
                //   showDialog(context: context, child: OverlayScreen(''));
              },
              backgroundColor: Colors.red[200],
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(100.0)),
                  width: 40,
                  height: 40,
                  child: Center(
                      child: Text(
                    "SOS",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ))),
            ),
          ),
        ),
      ),
    );
  }
}
