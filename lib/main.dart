import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:smart_society_new/Admin_App/Screens/AddEvent.dart';
import 'package:smart_society_new/Admin_App/Screens/DirectoryMember.dart';
import 'package:smart_society_new/Admin_App/Screens/EventsAdmin.dart';
import 'package:smart_society_new/Admin_App/Screens/RulesAndRegulations.dart';
import 'package:smart_society_new/Admin_App/Screens/VisitorByWing.dart';
import 'package:smart_society_new/IntroScreen.dart';
import 'package:smart_society_new/Member_App/DigitalCard/Screens/RegistrationDC.dart';
import 'package:smart_society_new/Member_App/Mall/Screens/Cart.dart';
import 'package:smart_society_new/Member_App/Mall/Screens/Mall.dart';
import 'package:smart_society_new/Member_App/Services/AdvertisementList.dart';
import 'package:smart_society_new/Member_App/Services/MyServiceRequests.dart';
import 'package:smart_society_new/Member_App/component/NotificationPopup.dart';
import 'package:smart_society_new/Member_App/screens/AddFamilyMember.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementCreate.dart';
import 'package:smart_society_new/Member_App/screens/AdvertisementManage.dart';
import 'package:smart_society_new/Member_App/screens/Amenities.dart';
import 'package:smart_society_new/Member_App/screens/BankDetails.dart';
import 'package:smart_society_new/Member_App/screens/Bills.dart';
import 'package:smart_society_new/Member_App/screens/BuildingInfo.dart';
import 'package:smart_society_new/Member_App/screens/Committees.dart';
import 'package:smart_society_new/Member_App/screens/ContactList.dart';
import 'package:smart_society_new/Member_App/screens/ContactUs.dart';
import 'package:smart_society_new/Member_App/screens/CreateSociety.dart';
import 'package:smart_society_new/Member_App/screens/DirectoryScreen.dart';
import 'package:smart_society_new/Member_App/screens/DocumentScreen.dart';
import 'package:smart_society_new/Member_App/screens/EventDetail.dart';
import 'package:smart_society_new/Member_App/screens/Events.dart';
import 'package:smart_society_new/Member_App/screens/GlobalSearchMembers.dart';
import 'package:smart_society_new/Member_App/screens/DailyHelp.dart';
import 'package:smart_society_new/Member_App/screens/MaintainanceScreen.dart';
import 'package:smart_society_new/Member_App/screens/MemberVehicleDetail.dart';
import 'package:smart_society_new/Member_App/screens/MyGuestList.dart';
import 'package:smart_society_new/Member_App/screens/FamilyMemberDetail.dart';
import 'package:smart_society_new/Member_App/screens/MySociety.dart';
import 'package:smart_society_new/Member_App/screens/MyWishList.dart';
import 'package:smart_society_new/Member_App/screens/NoRouteScreen.dart';
import 'package:smart_society_new/Member_App/screens/PollingScreen.dart';
import 'package:smart_society_new/Member_App/screens/PrivacyPolicy.dart';
import 'package:smart_society_new/Member_App/screens/SetupWings.dart';
import 'package:smart_society_new/Member_App/screens/Society_Rules.dart';
import 'package:smart_society_new/Member_App/screens/Splashscreen.dart';
import 'package:smart_society_new/Member_App/screens/LoginScreen.dart';
import 'package:smart_society_new/Member_App/screens/HomeScreen.dart';
import 'package:smart_society_new/Member_App/screens/ComplaintScreen.dart';
import 'package:smart_society_new/Member_App/screens/NoticeScreen.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/screens/MyComplaints.dart';
import 'package:smart_society_new/Member_App/screens/RegisterScreen.dart';
import 'package:smart_society_new/Member_App/screens/MyProfile.dart';
import 'package:smart_society_new/Member_App/screens/EmergencyNumber.dart';
import 'package:smart_society_new/Member_App/screens/Approval_Pending.dart';
import 'package:smart_society_new/Member_App/screens/Statistics.dart';
import 'package:smart_society_new/Member_App/screens/TermsAndConditions.dart';
import 'package:smart_society_new/Member_App/screens/GalleryScreen.dart';
import 'package:smart_society_new/Member_App/Services/ServicesScreen.dart';
import 'package:smart_society_new/Member_App/Services/SubServicesScreen.dart';
import 'package:smart_society_new/Member_App/screens/UpdateProfileScreen.dart';
import 'package:smart_society_new/Member_App/screens/AddGuest.dart';
import 'package:smart_society_new/Member_App/Services/ServiceDetailScreen.dart';

//admin App screens
import 'package:smart_society_new/Admin_App/Screens/AddGallary.dart';
import 'package:smart_society_new/Admin_App/Screens/AddRules.dart';
import 'package:smart_society_new/Admin_App/Screens/BalanceSheet.dart';
import 'package:smart_society_new/Admin_App/Screens/Complaints.dart';
import 'package:smart_society_new/Admin_App/Screens/Document.dart';
import 'package:smart_society_new/Admin_App/Screens/StaffInOut.dart';
import 'package:smart_society_new/Admin_App/Screens/Gallary.dart';
import 'package:smart_society_new/Admin_App/Screens/Expense.dart';
import 'package:smart_society_new/Admin_App/Screens/ExpenseByMonth.dart';
import 'package:smart_society_new/Admin_App/Screens/Income.dart';
import 'package:smart_society_new/Admin_App/Screens/IncomeByMonth.dart';
import 'package:smart_society_new/Admin_App/Screens/Dashboard.dart';
import 'package:smart_society_new/Admin_App/Screens/AddNotice.dart';
import 'package:smart_society_new/Admin_App/Screens/AddDocument.dart';
import 'package:smart_society_new/Admin_App/Screens/MemberProfile.dart';
import 'package:smart_society_new/Admin_App/Screens/Notice.dart';
import 'package:smart_society_new/Admin_App/Screens/Polling.dart';
import 'package:smart_society_new/Member_App/screens/ViewProducts.dart';
import 'package:smart_society_new/Member_App/screens/VisitorSuccess.dart';
import 'package:smart_society_new/Member_App/screens/WingDetail.dart';
import 'package:smart_society_new/Member_App/screens/WingFlat.dart';
import 'package:smart_society_new/VisitorRegister.dart';
import 'Admin_App/Screens/AddAMC.dart';
import 'Admin_App/Screens/AddExpense.dart';
import 'Admin_App/Screens/AddIncome.dart';
import 'Admin_App/Screens/AddPolling.dart';
import 'Admin_App/Screens/RulesAndRegulations.dart';
import 'Admin_App/Screens/amcList.dart';
import 'VisitorOtpScreen.dart';
import 'Member_App/screens/DirectoryProfileFamily.dart';
import 'Member_App/screens/DirectoryProfileVehicle.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String Title;
  String bodymessage;

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
  }

  @override
  void initState() {
    // this.initState();
    // initPlayer();
    setNotification();
  }

  void setNotification() async {
    //_messaging.getToken().then((token) {});

    _firebaseMessaging.configure(
      //when app is open
      onMessage: (Map<String, dynamic> message) async {
        Get.to(NotificationPopup(message));
        if (message["data"]["Type"] == 'Visitor') {
          Get.to(NotificationPopup(message));
          audioCache.play('Sound.mp3');
        } else {
          showNotification('$Title', '$bodymessage');
          audioCache.play('Sound.mp3');
        }
      },
      //when app is closed and user click on notification
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // _navigateToItemDetail(message);
        Get.to(NotificationPopup(message));
      },
      //when app is in background and user click on notification
      onResume: (Map<String, dynamic> message) async {
        print(
            "onResume:------------------- $message  --------------------------------");
        // _navigateToItemDetail(message);
        Get.to(NotificationPopup(message));
      },
    );

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
    flutterLocalNotificationsPlugin.initialize(initSetttings);
  }

  void _navigateToItemDetail(dynamic message) async {
    if (message["data"]["Type"] == 'Visitor') {
      Get.to(NotificationPopup(message));
    } else {
      showNotification('$Title', '$bodymessage');
      audioCache.play('Sound.mp3');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Get.key,
      // navigatorKey: navigatorKey,
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
        '/Directory': (context) => DirecotryScreen(),
        '/RegisterScreen': (context) => RegisterScreen(),
        '/MyProfile': (context) => MyProfileScreen(),
        '/Documents': (context) => DocumentScreen(),
        '/Emergency': (context) => EmergencyNumber(),
        '/Gallery': (context) => GalleryScreen(),
        '/UpdateProfile': (context) => UpdateProfile(),
        '/AddGuest': (context) => AddGuest(),
        '/MyGuestList': (context) => MyGuestList(),
        '/Rules': (context) => SocietyRules(),
        '/FamilyMemberDetail': (context) => FamilyMemberDetail(),
        '/AddFamily': (context) => AddFamilyMember(),
        '/GetMyVehicle': (context) => GetMyvehicle(),
        '/DirectoryProfileVehicle': (context) => DirectoryProfileVehicle(),
        '/DirectoryProfileFamily': (context) => DirectoryProfileFamily(),
        '/Polling': (context) => PollingScreen(),
        '/Maintainence': (context) => Maintainance(),
        '/GlobalSearch': (context) => GlobalSearchMembers(),
        '/AdvertisementCreate': (context) => AdvertisementCreate(),
        '/Vendors': (context) => ServicesScreen(),
        '/MyServiceRequests': (context) => MyServiceRequests(),
        '/AdvertisementList': (context) => AdvertisementList(),
        '/MyWishList': (context) => MyWishList(),
        '/IntroScreen': (context) => IntroScreen(),
        '/VisitorSuccess': (context) => VisitorSuccess(),
        '/CreateSociety': (context) => CreateSociety(),
        '/SetupWings': (context) => SetupWings(),
        '/WingDetail': (context) => WingDetail(),
        '/WingFlat': (context) => WingFlat(),

        '/AdvertisementManage': (context) => AdvertisementManage(),
        '/ContactList': (context) => ContactList(),
        '/Committee': (context) => Committees(),
        '/Amenities': (context) => Amenities(),
        '/DailyHelp': (context) => DailyHelp(),
        '/Mall': (context) => Mall(),
        '/Cart': (context) => Cart(),
        '/Bills': (context) => Bills(),
        '/TermsAndConditions': (context) => TermsAndConditions(),
        '/PrivacyPolicy': (context) => PrivacyPolicy(),
        '/Statistics': (context) => Statistics(),
        '/ContactUs': (context) => ContactUs(),
        '/MySociety': (context) => MySociety(),
        '/BankDetails': (context) => BankDetails(),
        '/BuildingInfo': (context) => BuildingInfo(),
        '/Events': (context) => Events(),
        '/EventDetail': (context) => EventDetail(),
        //---------------- Digital Card  -------------------------------
        '/RegistrationDC': (context) => RegistrationDC(),
        //----------------  Admin App    -----------------------------
        '/Dashboard': (context) => Dashboard(),
        '/AddNotice': (context) => AddNotice(),
        '/AddDocument': (context) => AddDocument(),
        '/DirectoryMember': (context) => DirectoryMember(),
        '/AllNotice': (context) => Notice(),
        '/Document': (context) => Document(),
        '/Visitor': (context) => VisitorByWing(),
        '/Staff': (context) => StaffInOut(),
        '/RulesAndRegulations': (context) => RulesAndRegulations(),
        '/AddRules': (context) => AddRules(),
        '/AllComplaints': (context) => Complaints(),
        '/MemberProfile': (context) => MemberProfile(),
        '/Gallary': (context) => Gallary(),
        '/AddGallary': (context) => AddGallary(),
        '/Income': (context) => Income(),
        '/Expense': (context) => Expense(),
        '/BalanceSheet': (context) => BalanceSheet(),
        '/ExpenseByMonth': (context) => ExpenseByMonth(),
        '/IncomeByMonth': (context) => IncomeByMonth(),
        '/AddIncome': (context) => AddIncome(),
        '/AddExpense': (context) => AddExpense(),
        '/AllPolling': (context) => Polling(),
        '/AddPolling': (context) => AddPolling(),
        '/amcList': (context) => amcList(),
        '/AddAMC': (context) => AddAMC(),
        '/StaffInOut': (context) => StaffInOut(),
        '/EventsAdmin': (context) => EventsAdmin(),
        '/AddEvent': (context) => AddEvent(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => NoRouteScreen(
                routeName: settings.name,
              )),
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
    await flutterLocalNotificationsPlugin.show(0, '$title', '$body', platform);
  }
}

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
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    ),
                  ),
                  widget.data["data"]["Image"] == null &&
                          widget.data["data"]["Image"] == ""
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundImage: NetworkImage(constant.Image_Url +
                                "${widget.data["data"]["Image"]}"),
                            backgroundColor: Colors.transparent,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'images/user.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                  Column(
                    children: <Widget>[
                      Text(
                        "${widget.data["data"]["Name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey[800]),
                      ),
                      Image.network(
                        constant.Image_Url +
                            '${widget.data["data"]["CompanyImage"]}',
                        width: 90,
                        height: 40,
                      )
                    ],
                  ),
                  Text(
                    "${widget.data["data"]["CompanyName"]}",
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/success.png',
                                  width: 45, height: 45),
                              Text(
                                "APPROVE",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
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
                                    fontWeight: FontWeight.w600, fontSize: 12))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Image.asset('images/deny.png',
                                width: 45, height: 45),
                            Text("DENY",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12))
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
                  Get.back();
                }),
          ],
        ),
      ),
    );
  }
}
