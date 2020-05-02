import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

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
          if (data.Data == "1" && data.IsSuccess == true) {
            Fluttertoast.showToast(
                msg: "Success !",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.TOP,
                toastLength: Toast.LENGTH_SHORT);
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
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              constant.Image_Url +
                                  '${widget.data["data"]["CompanyImage"]}',
                              width: 85,
                              height: 35,
                            ),
                            Text(
                              "${widget.data["data"]["CompanyName"]}",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            NotificationReply(
                                _notifcationReplylist[0],
                                widget.data["data"]["EntryId"],
                                widget.data["data"]["WatchmanId"]);
                            Get.back();
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/success.png',
                                  width: 40, height: 40),
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
                                width: 40,
                                height: 40,
                                color: constant.appPrimaryMaterialColor),
                            Text("CALL",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12))
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            NotificationReply(
                                _notifcationReplylist[1],
                                widget.data["data"]["EntryId"],
                                widget.data["data"]["WatchmanId"]);
                            Get.back();
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'images/leaveatgate.png',
                                width: 40,
                                height: 40,
                              ),
                              Text("Leave At Gate",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            NotificationReply(
                                _notifcationReplylist[2],
                                widget.data["data"]["EntryId"],
                                widget.data["data"]["WatchmanId"]);
                            Get.back();
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset('images/deny.png',
                                  width: 40, height: 40),
                              Text("DENY",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ],
                          ),
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
