import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/Model/ModelClass.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart';
import 'package:smart_society_new/Member_App/screens/SOSDailog.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AdvertismentDetailPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription iosSubscription;
  String fcmToken = "";
  String searchedText = "";
  String SocietyId,
      Name,
      Wing,
      FlatNo,
      Profile,
      ContactNo,
      Address,
      ResidenceType,
      BloodGroup;

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
    initPlayer();
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

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      Name = prefs.getString(constant.Session.Name);
      Wing = prefs.getString(constant.Session.Wing);
      FlatNo = prefs.getString(constant.Session.FlatNo);
      Profile = prefs.getString(constant.Session.Profile);
      ContactNo = prefs.getString(constant.Session.session_login);
      Address = prefs.getString(constant.Session.Address);
      ResidenceType = prefs.getString(constant.Session.ResidenceType);
    });
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
    } else
      Fluttertoast.showToast(
          msg: "Permission Not Granted",
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "MY JINI",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add_to_home_screen),
                onPressed: () {
                  Navigator.pushNamed(context, "/Dashboard");
                })
          ],
          bottom: PreferredSize(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/GlobalSearch");
                },
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
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
                          "Search Member or Services..",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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
              preferredSize: Size.fromHeight(40.0)),
        ),
        drawer: Drawer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100)),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.4)),
                                  width: 76,
                                  height: 76,
                                ),
                                ClipOval(
                                  child: Profile != "null" && Profile != ""
                                      ? FadeInImage.assetNetwork(
                                          placeholder:
                                              "images/image_loading.gif",
                                          image:
                                              constant.Image_Url + '$Profile',
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
                                      padding: const EdgeInsets.only(
                                          top: 2, left: 0),
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
                        'Manage Promotions',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(
                        Icons.assessment,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                            context, "/AdvertisementManage");
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
                        'Terms & Conditions',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(
                        Icons.priority_high,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/TermsAndConditions");
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Privacy Policy',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(
                        Icons.label,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/PrivacyPolicy");
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Share My Address',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(
                        Icons.add_to_home_screen,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Share.share(
                            "Hello, My Name is $Name\nI Am $ResidenceType At $FlatNo - $Wing ,$Address\n"
                            "My Contact Number is $ContactNo , Please Contact Me if You Have Any Query.");
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Contact Us',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(
                        Icons.perm_contact_calendar,
                        color: constant.appPrimaryMaterialColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/ContactUs");
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
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    Divider(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              launch("tel:9023803870");
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/call.png",
                                    height: 24, width: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Call",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch(
                                  "https://www.facebook.com/myjinismartsociety/");
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/facebook.png",
                                    height: 24, width: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Facebook",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch(
                                  "https://www.instagram.com/myjini_smartsociety/");
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/instagram.png",
                                    height: 24, width: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Instagram",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("http://www.myjini.in/");
                            },
                            child: Column(
                              children: <Widget>[
                                Image.asset("images/applogo.png",
                                    height: 24, width: 24),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text("Website",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        body: isLoading
            ? Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: <Widget>[
                  _advertisementData.length > 0
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            CarouselSlider(
                              height: 180,
                              viewportFraction: 1.0,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 1000),
                              reverse: false,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              autoPlay: true,
                              onPageChanged: (index) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              items: _advertisementData.map((i) {
                                return Builder(builder: (BuildContext context) {
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.network(
                                            Image_Url + i["Image"],
                                            fit: BoxFit.fill)),
                                  );
                                });
                              }).toList(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: map<Widget>(
                                _advertisementData,
                                (index, url) {
                                  return Container(
                                    width: 7.0,
                                    height: 7.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
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
                  Padding(padding: EdgeInsets.all(4.0)),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: <Widget>[
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
                          Padding(padding: EdgeInsets.all(8.0)),
                          _advertisementData.length > 0
                              ? Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    CarouselSlider(
                                      height: 140,
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
                  )
                ],
              ),
        bottomNavigationBar: Container(
          height: 54,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(top: BorderSide(color: Colors.grey, width: 0.3))),
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
                        Icon(
                          Icons.home,
                          size: 22,
                        ),
                        Text("Home",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11))
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
                        Icon(Icons.person_pin, size: 22),
                        Text("Add Visitor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11))
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
                        Icon(Icons.new_releases, size: 22),
                        Text("Promote",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11))
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
                        Icon(Icons.shopping_cart, size: 22),
                        Text("Mall",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11))
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/Mall');
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
                        Icon(Icons.person, size: 22),
                        Text("Profile",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11))
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
        floatingActionButton: DraggableFab(
          child: SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              onPressed: () {
                //Get.to(OverlayScreen({}));
                showDialog(context: context, child: SOSDailog());
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
