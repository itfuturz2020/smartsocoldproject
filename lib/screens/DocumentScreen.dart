import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class DocumentScreen extends StatefulWidget {
  @override
  _DocumentScreenState createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  List DocumentData = new List();
  bool isLoading = false;
  String SocietyId;
  bool downloading = false;

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SocietyId = prefs.getString(constant.Session.SocietyId);
  }

  @override
  void initState() {
    GetSocietyRules();
    _getLocaldata();
  }

  String setDate(String date) {
    String final_date = "";
    var tempDate;
    if (date != "" || date != null) {
      tempDate = date.toString().split("-");
      if (tempDate[2].toString().length == 1) {
        tempDate[2] = "0" + tempDate[2].toString();
      }
      if (tempDate[1].toString().length == 1) {
        tempDate[1] = "0" + tempDate[1].toString();
      }
      final_date = date == "" || date == null
          ? ""
          : "${tempDate[2].toString().substring(0, 2)}-${tempDate[1].toString()}-${tempDate[0].toString()}"
              .toString();
    }

    return final_date;
  }

  GetSocietyRules() async {
    try {
      //check Internet Connection
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });

        Services.GetSocietyDocuments(SocietyId).then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data != null && data.length > 0) {
            setState(() {
              DocumentData = data;
            });
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

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _downloadFile(String url) async {
    var file = url.split('/');

    Dio dio = Dio();
    try {
      var dir = await getExternalStorageDirectory();
      print("${dir.path}/${file[3].toString()}");
      await dio.download(
          "http://smartsociety.itfuturz.com/${url.replaceAll(" ", "%20")}",
          "${dir.path}/${file[3].toString()}", onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
        setState(() {
          downloading = true;
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      Fluttertoast.showToast(
          msg: "Download Successfully",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    });
  }

  shareFile(String ImgUrl, String Extension) async {
    ImgUrl = ImgUrl.replaceAll(" ", "%20");
    if (ImgUrl.toString() != "null" && ImgUrl.toString() != "") {
      var request = await HttpClient()
          .getUrl(Uri.parse("http://smartsociety.itfuturz.com${ImgUrl}"));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.files(
          'Share Document', {'eyes.$Extension': bytes}, 'image/pdf');
    }
  }

  Widget _SocietyDocument(BuildContext context, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        verticalOffset: -100,
        duration: const Duration(milliseconds: 375),
        child: FadeInAnimation(
          child: Card(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset("images/file.png",
                          height: 20, width: 20, color: Colors.grey),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${DocumentData[index]["Title"]}",
                                softWrap: true,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              Text("${setDate(DocumentData[index]["Date"])}")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _launchURL("http://smartsociety.itfuturz.com" +
                            "${DocumentData[index]["File"]}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Colors.grey[200]),
                          child: Center(
                              child: Icon(
                            Icons.remove_red_eye,
                            color: Colors.grey,
                            size: 20,
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _downloadFile("${DocumentData[index]["File"]}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Colors.grey[200]),
                          child: Center(
                              child: Icon(
                            Icons.sd_card,
                            color: Colors.grey,
                            size: 20,
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        var array = DocumentData[index]["File"].split(".");
                        print(array[1].toString());
                        shareFile("${DocumentData[index]["File"]}", array[1]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              color: Colors.grey[200]),
                          child: Center(
                              child: Icon(
                            Icons.share,
                            color: Colors.black54,
                            size: 20,
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "/HomeScreen");
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/HomeScreen");
                }),
            centerTitle: true,
            title: Text(
              'Documents',
              style: TextStyle(fontSize: 18),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
          ),
          body: isLoading
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : DocumentData.length > 0
                  ? AnimationLimiter(
                      child: ListView.builder(
                          itemBuilder: _SocietyDocument,
                          itemCount: DocumentData.length),
                    )
                  : Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("images/file.png",
                                width: 70, height: 70, color: Colors.grey[300]),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text("No Document Found",
                                  style: TextStyle(color: Colors.grey[400])),
                            )
                          ],
                        ),
                      ),
                    ),
        ));
  }
}
