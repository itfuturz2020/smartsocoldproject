import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_society_new/Member_App/common/Services.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/ExtensionMethods.dart';
import 'package:smart_society_new/Member_App/screens/MemberProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberComponent extends StatefulWidget {
  var MemberData;

  MemberComponent(this.MemberData);

  @override
  _MemberComponentState createState() => _MemberComponentState();
}

_openWhatsapp(mobile) {
  String whatsAppLink = constant.whatsAppLink;
  String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
  String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
  launch(urlwithmsg);
}

class _MemberComponentState extends State<MemberComponent> {
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

        Services.GetVcardofMember(
                widget.MemberData["MemberData"]["Id"].toString())
            .then((data) async {
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        child: ExpansionTile(
          title: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 1.0, top: 1, bottom: 1),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                            image: widget.MemberData["MemberData"]["Image"] ==
                                        null ||
                                    widget.MemberData["MemberData"]["Image"] ==
                                        ""
                                ? AssetImage("images/man.png")
                                : NetworkImage(constant.Image_Url +
                                    '${widget.MemberData["MemberData"]["Image"]}'),
                            fit: BoxFit.cover),
                        borderRadius:
                            BorderRadius.all(new Radius.circular(75.0)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("${widget.MemberData["MemberData"]["Name"]}",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700])),
                          widget.MemberData["MemberData"]["IsPrivate"] ==
                                      false ||
                                  widget.MemberData["MemberData"]
                                          ["IsPrivate"] ==
                                      null
                              ? Text(
                                  '${widget.MemberData["MemberData"]["ContactNo"]}')
                              : Text(
                                  '${widget.MemberData["MemberData"]["ContactNo"]}'
                                      .replaceRange(0, 6, "******")),
                          Text(
                            "Flat No: ${widget.MemberData["MemberData"]["FlatNo"]}",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                          Text(
                            "${widget.MemberData["MemberData"]["ResidenceType"]}"
                                .checkForNull(),
                            style: TextStyle(
                                color: constant.appPrimaryMaterialColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 10,
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(3.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset("images/whatsapp.png",
                        width: 30, height: 30),
                    onPressed: () {
                      widget.MemberData["MemberData"]["IsPrivate"] == true
                          ? Fluttertoast.showToast(
                              msg: "Profile is Private",
                              backgroundColor: Colors.red,
                              textColor: Colors.white)
                          : _openWhatsapp(
                              widget.MemberData["MemberData"]["ContactNo"]);
                    },
                  ),
                  IconButton(
                      icon: Image.asset('images/call.png',
                          width: 20, height: 20, color: Colors.green),
                      onPressed: () {
                        widget.MemberData["MemberData"]["IsPrivate"] == true
                            ? Fluttertoast.showToast(
                                msg: "Profile is Private",
                                backgroundColor: Colors.red,
                                textColor: Colors.white)
                            : launch(
                                "tel:${widget.MemberData["MemberData"]["ContactNo"]}");
                      }),
                  IconButton(
                      icon: Icon(Icons.remove_red_eye, color: Colors.black54),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MemberProfile(
                              widget.MemberData["MemberData"],
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
                        GetVcard();
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
