import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/join.dart';

class NotificationPopup extends StatefulWidget {
  var data;

  NotificationPopup(this.data);

  @override
  _NotificationPopupState createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  List NoticeData = new List();
  bool isLoading = false;
  String SocietyId;
  final List<String> _notifcationReplylist = [
    "APPROVED",
    "LEAVE AT GATE",
    "DENY"
  ];
  int selected_Index;

  @override
  void initState() {
    print(widget.data);
    AgoraentryId();
  }

  AgoraentryId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('data', widget.data["data"]["EntryId"]);
    print("smit member1 ${widget.data["data"]["EntryId"]}");
  }

  NotificationReply(String Msg, String EntryId, String WatchmanId) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.NotificationReply(Msg, EntryId, WatchmanId).then((data) async {
          setState(() {
            isLoading = false;
          });
          log("=============Notification${data.Message}");
          if (data.Data == "1" && data.IsSuccess == true) {
            // SharedPreferences preferences =
            //     await SharedPreferences.getInstance();
            // await preferences.setString('data', data.Data);

            Fluttertoast.showToast(
                msg: "Success !",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);

            log("=============Notification${data.Message}");
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

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Color.fromRGBO(18, 17, 17, 0.8),
//       child: Dialog(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Card(
//               child: Container(
//                   child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       child: Center(
//                           child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "Delivery Boy Waiting At Gate",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                       )),
//                       width: MediaQuery.of(context).size.width,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.all(Radius.circular(8.0))),
//                     ),
//                   ),
//                   widget.data["data"]["Image"] == null &&
//                           widget.data["data"]["Image"] == ""
//                       ? Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CircleAvatar(
//                             radius: 45.0,
//                             backgroundImage: NetworkImage(constant.Image_Url +
//                                 "${widget.data["data"]["Image"]}"),
//                             backgroundColor: Colors.transparent,
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.asset(
//                             'images/user.png',
//                             width: 100,
//                             height: 100,
//                           ),
//                         ),
//                   Column(
//                     children: <Widget>[
//                       Text(
//                         "${widget.data["data"]["Name"]}",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                             color: Colors.grey[800]),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(top: 20.0),
//                         child: Column(
//                           children: <Widget>[
//                             Image.network(
//                               constant.Image_Url +
//                                   '${widget.data["data"]["CompanyImage"]}',
//                               width: 85,
//                               height: 35,
//                             ),
//                             Text(
//                               "${widget.data["data"]["CompanyName"]}",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.grey[800],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         GestureDetector(
//                           onTap: () {
//                             NotificationReply(
//                                 _notifcationReplylist[0],
//                                 widget.data["data"]["EntryId"],
//                                 widget.data["data"]["WatchmanId"]);
//                             Get.back();
//                           },
//                           child: Column(
//                             children: <Widget>[
//                               Image.asset('images/success.png',
//                                   width: 40, height: 40),
//                               Text(
//                                 "APPROVE",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12),
//                               )
//                             ],
//                           ),
//                         ),
//                         Column(
//                           children: <Widget>[
//                             Image.asset('images/callvisitor.png',
//                                 width: 40,
//                                 height: 40,
//                                 color: constant.appPrimaryMaterialColor),
//                             Text("CALL",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 12))
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             NotificationReply(
//                                 _notifcationReplylist[1],
//                                 widget.data["data"]["EntryId"],
//                                 widget.data["data"]["WatchmanId"]);
//                             Get.back();
//                           },
//                           child: Column(
//                             children: <Widget>[
//                               Image.asset(
//                                 'images/leaveatgate.png',
//                                 width: 40,
//                                 height: 40,
//                               ),
//                               Text("Leave At Gate",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 12))
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             NotificationReply(
//                                 _notifcationReplylist[2],
//                                 widget.data["data"]["EntryId"],
//                                 widget.data["data"]["WatchmanId"]);
//                             Get.back();
//                           },
//                           child: Column(
//                             children: <Widget>[
//                               Image.asset('images/deny.png',
//                                   width: 40, height: 40),
//                               Text("DENY",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 12))
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               )),
//             ),
//             IconButton(
//                 icon: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                   size: 40,
//                 ),
//                 onPressed: () {
//                   Get.back();
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.fill,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context),
              ),
              Image.asset(
                'images/myginitext.png',
                height: 60,
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  contentBox(context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 65),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 5), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Text(
                "Guest is waiting At Gate",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //width: 130,
                    child: Flexible(
                      child: Text(
                        "${widget.data["data"]["Name"]}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.grey[800]),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: 30,
                  // ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Image.asset('images/telephone.png',
                                width: 40, height: 40),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: onJoin,
                        child: Column(
                          children: <Widget>[
                            Image.asset('images/video_call.png',
                                width: 40, height: 40),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
        widget.data["data"]["Image"] == null ||
                widget.data["data"]["Image"] == ""
            ? Positioned(
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 65,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(65),
                        ),
                        child: Image.asset(
                          "images/user.png",
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Positioned(
                left: 20,
                right: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 65,
                  backgroundImage: NetworkImage(
                    constant.Image_Url + "${widget.data["data"]["Image"]}",
                  ),
                ),
              ),
        //company image
        Positioned(
          top: 80,
          left: 20,
          right: -180,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            // maxRadius: 30,
            radius: 30,
            child: Container(
              // height: 60,
              // width: 60,
              child: Image.network(
                constant.Image_Url + '${widget.data["data"]["CompanyImage"]}',
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -45,
          left: 20,
          right: -180,
          child: GestureDetector(
            onTap: () {
              log("//=================#${_notifcationReplylist[0]}");
              NotificationReply(
                  _notifcationReplylist[0],
                  widget.data["data"]["EntryId"],
                  widget.data["data"]["WatchmanId"]);
              Get.back();
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(65)),
                      child: Image.asset("images/success.png")),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "APPROVE",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -45,
          left: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              NotificationReply(
                  _notifcationReplylist[1],
                  widget.data["data"]["EntryId"],
                  widget.data["data"]["WatchmanId"]);
              Get.back();
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(65)),
                      child: Image.asset("images/user.png")),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "LEAVE AT GATE",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -45,
          left: -180,
          right: 20,
          child: GestureDetector(
            onTap: () {
              NotificationReply(
                  _notifcationReplylist[2],
                  widget.data["data"]["EntryId"],
                  widget.data["data"]["WatchmanId"]);
              Get.back();
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 25,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(65)),
                      child: Image.asset("images/deny.png")),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "DENY",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onJoin() {
    // await for camera and mic permissions before pushing video page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinPage(),
      ),
    );
  }
}
