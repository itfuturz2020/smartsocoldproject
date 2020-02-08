import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/screens/DirectoryScreen.dart';
import 'package:smart_society_new/screens/MemberProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalMemberComponent extends StatefulWidget {
  var MemberData;

  GlobalMemberComponent(this.MemberData);

  @override
  _GlobalMemberComponentState createState() => _GlobalMemberComponentState();
}

_openWhatsapp(mobile) {
  String whatsAppLink = constant.whatsAppLink;
  String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
  String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
  launch(urlwithmsg);
}

class _GlobalMemberComponentState extends State<GlobalMemberComponent> {
  shareFile(String ImgUrl) async {
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient()
          .getUrl(Uri.parse("http://smartsociety.itfuturz.com/${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files('Share Profile', {'eyes.vcf': bytes}, 'image/pdf');
    }
  }

  bool isLoading = false;
  String Data = "";

  GetVcard() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetVcardofMember(widget.MemberData["Id"].toString()).then(
            (data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null) {
            setState(() {
              Data = data;
            });
            shareFile('${Data}');
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
      } else {
        setState(() {
          isLoading = false;
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
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
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
    return ExpansionTile(
      title: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 1.0, top: 1, bottom: 1),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: widget.MemberData["Image"] == null ||
                                widget.MemberData["Image"] == ""
                            ? AssetImage("images/man.png")
                            : NetworkImage(constant.Image_Url +
                                '${widget.MemberData["Image"]}'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(new Radius.circular(75.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.MemberData["Name"]}",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700])),
                    Text(
                        "${widget.MemberData["Wing"]}-${widget.MemberData["FlatNo"]}",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    widget.MemberData["IsPrivate"] == false ||
                            widget.MemberData["IsPrivate"] == null
                        ? Text('${widget.MemberData["ContactNo"]}')
                        : Text('${widget.MemberData["ContactNo"]}'
                            .replaceRange(0, 6, "******")),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${widget.MemberData["Designation"]}",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700])),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.business_center,
                        color: Colors.grey[400],
                        size: 15,
                      ),
                      Text(
                        "Business",
                        style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[400]),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  widget.MemberData["vehicle"].length > 0
                      ? Column(
                          children: <Widget>[
                            Text(
                                "${widget.MemberData["vehicle"][0]["VehicleNo"]}",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700]))
                          ],
                        )
                      : Container(
                          child: Text("No Vehicle Added"),
                        ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.directions_bike,
                        color: Colors.grey[400],
                        size: 15,
                      ),
                      Text(
                        "Vehicle",
                        style: TextStyle(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[400]),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 10,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.all(Radius.circular(3.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Image.asset("images/whatsapp.png", width: 30, height: 30),
                onPressed: () {
                  widget.MemberData["IsPrivate"] == true
                      ? Fluttertoast.showToast(
                          msg: "Profile is Private",
                          gravity: ToastGravity.TOP,
                          backgroundColor: Colors.red,
                          textColor: Colors.white)
                      : _openWhatsapp(widget.MemberData["ContactNo"]);
                },
              ),
              IconButton(
                  icon: Image.asset('images/call.png',
                      width: 20, height: 20, color: Colors.green),
                  onPressed: () {
                    widget.MemberData["IsPrivate"] == true
                        ? Fluttertoast.showToast(
                            msg: "Profile is Private",
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white)
                        : launch("tel://${widget.MemberData["ContactNo"]}");
                  }),
              IconButton(
                  icon: Icon(Icons.remove_red_eye, color: Colors.black54),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemberProfile(
                          widget.MemberData,
                        ),
                      ),
                    );
                  }),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    widget.MemberData["IsPrivate"] == true
                        ? Fluttertoast.showToast(
                            msg: "Profile is Private",
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.TOP,
                            textColor: Colors.white)
                        : GetVcard();
                  }),
            ],
          ),
        )
      ],
    );
  }
}
