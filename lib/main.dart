import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smart_society_new/screens/AddFamilyMember.dart';
import 'package:smart_society_new/screens/AdvertisementCreate.dart';
import 'package:smart_society_new/screens/AdvertisementManage.dart';
import 'package:smart_society_new/screens/Amenities.dart';
import 'package:smart_society_new/screens/Committees.dart';
import 'package:smart_society_new/screens/ContactList.dart';
import 'package:smart_society_new/screens/DocumentScreen.dart';
import 'package:smart_society_new/screens/GlobalSearchMembers.dart';
import 'package:smart_society_new/screens/DailyHelp.dart';
import 'package:smart_society_new/screens/MaintainanceScreen.dart';
import 'package:smart_society_new/screens/MemberVehicleDetail.dart';
import 'package:smart_society_new/screens/MyGuestList.dart';
import 'package:smart_society_new/screens/FamilyMemberDetail.dart';
import 'package:smart_society_new/screens/PollingScreen.dart';
import 'package:smart_society_new/screens/Society_Rules.dart';
import 'package:smart_society_new/screens/Splashscreen.dart';
import 'package:smart_society_new/screens/LoginScreen.dart';
import 'package:smart_society_new/screens/OtpScreen.dart';
import 'package:smart_society_new/screens/HomeScreen.dart';
import 'package:smart_society_new/screens/ComplaintScreen.dart';
import 'package:smart_society_new/screens/NoticeScreen.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/screens/MyComplaints.dart';
import 'package:smart_society_new/screens/RegisterScreen.dart';
import 'package:smart_society_new/screens/MyProfile.dart';
import 'package:smart_society_new/screens/EmergencyNumber.dart';
import 'package:smart_society_new/screens/Approval_Pending.dart';
import 'package:smart_society_new/screens/WinglistScreen.dart';

import 'package:smart_society_new/screens/GalleryScreen.dart';
import 'package:smart_society_new/Services/ServicesScreen.dart';
import 'package:smart_society_new/Services/ServiceList.dart';
import 'package:smart_society_new/screens/UpdateProfileScreen.dart';
import 'package:smart_society_new/screens/AddGuest.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  AudioPlayer advancedPlayer;
  AudioCache audioCache;

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      Get.to(OverlayScreen(message));
      audioCache.play('Sound.mp3');
      print("onMessage  $message");
    }, onResume: (Map<String, dynamic> message) {
      print("onResume");
      print(message);
    }, onLaunch: (Map<String, dynamic> message) {
      print("onLaunch");
      print(message);
    });

    //For Ios Notification
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Setting reqistered : $settings");
    });

    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    debugPrint("payload : $payload");
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new OverlayScreen("hello")));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      title: "My JINI",
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/LoginScreen': (context) => LoginScreen(),
        '/HomeScreen': (context) => HomeScreen(),
        '/Notice': (context) => NoticeScreen(),
        '/WaitingScreen': (context) => Approval_admin(),
        '/Complaints': (context) => MyComplaints(),
        '/AddComplaints': (context) => ComplaintScreen(),
        '/Directory': (context) => WingListItem(),
        '/RegisterScreen': (context) => RegisterScreen(),
        '/MyProfile': (context) => MyProfileScreen(),
        '/Documents': (context) => DocumentScreen(),
        '/Emergency': (context) => EmergencyNumber(),
        '/Gallery': (context) => GalleryScreen(),
        '/UpdateProfile': (context) => UpdateProfile(),
        '/AddGuest': (context) => AddGuest(),
        '/MyGuestList': (context) => MyGuestList(),
        '/Rules': (context) => SocietyRules(),
        '/GetMyFamily': (context) => GetMyFamily(),
        '/AddFamily': (context) => AddFamilyMember(),
        '/GetMyVehicle': (context) => GetMyvehicle(),
        '/Polling': (context) => PollingScreen(),
        '/Maintainence': (context) => Maintainance(),
        '/GlobalSearch': (context) => GlobalSearchMembers(),
        '/AdvertisementCreate': (context) => AdvertisementCreate(),
        '/Vendors': (context) => ServicesScreen(),
        '/AdvertisementManage': (context) => AdvertisementManage(),
        '/ContactList': (context) => ContactList(),
        '/Committee': (context) => Committees(),
        '/Amenities': (context) => Amenities(),
        '/DailyHelp': (context) => DailyHelp(),
      },
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: constant.appPrimaryMaterialColor,
      ),
    );
  }

  showNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max, playSound: false);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform,
        payload: 'MY JINI');
  }
}

/*
  onSelectNotification() {
    showDialog(
      context: context,
      builder: (_) => new Dialog(
          elevation: 10.0, backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Delivery Boy Waiting At Gate",style: TextStyle(fontSize: 16),),
                      )),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 45.0,
                      backgroundImage:
                      NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQE4-uDm61plRUuMRwIbT0QFf3qLTf5P54CB5MCk68Ww8uhj1VB"),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Amit Patel",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.grey[800]),),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:25.0,bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[

                        Column(
                          children: <Widget>[
                            Image.asset('images/success.png',width: 45,height: 45),
                            Text("APPROVE",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12),)
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('images/callvisitor.png',width: 45,height: 45,color: constant.appPrimaryMaterialColor),
                            Text("CALL",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12))

                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('images/deny.png',width: 45,height: 45),
                            Text("DENY",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 12))

                          ],
                        ) ,

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
*/

class OverlayScreen extends StatefulWidget {
  var data;

  OverlayScreen(this.data);

  @override
  _OverlayScreenState createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  @override
  void initState() {
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
     color: Color.fromRGBO(18, 17, 17, 0.8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Delivery Boy Waiting At Gate",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              )),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(8.0))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 45.0,
                          backgroundImage: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQE4-uDm61plRUuMRwIbT0QFf3qLTf5P54CB5MCk68Ww8uhj1VB"),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            "Amit Patel",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.grey[800]),
                          ),
                          Image.network('https://i.ya-webdesign.com/images/dominos-pizza-logo-png-4.png',width: 90,height: 55,)
                        ],
                      ),
                      Text(
                        "GJ-05-KP-5555",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[800]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){

                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset('images/success.png',
                                      width: 45, height: 45),
                                  Text(
                                    "APPROVE",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Image.asset('images/callvisitor.png',
                                    width: 45,
                                    height: 45,
                                    color: constant.appPrimaryMaterialColor),
                                Text("CALL",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Image.asset('images/deny.png',
                                    width: 45, height: 45),
                                Text("DENY",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12))
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
            IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}
