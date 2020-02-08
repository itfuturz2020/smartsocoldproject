import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Services.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/component/MyAnswerComponent.dart';

class AnswerList extends StatefulWidget {
  var PollingData;
  int index;

  Function onchange;

  AnswerList(this.PollingData, this.index, this.onchange);

  @override
  _AnswerListState createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  int _selectedIndex;
  String Answer;
  ProgressDialog pr;
  bool _submited = false;
  int answerIndex;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  String SocietyId, MemberId;

  @override
  void initState() {
    _getLocaldata();
    _checkanswer();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Please Wait');
  }

  _checkanswer() {
    for (int i = 0; i < widget.PollingData["PollingOptionList"].length; i++) {
      if (widget.PollingData["PollingOptionList"][i]["IsSelected"] == true) {
        setState(() {
          _submited = true;
          answerIndex = i;
        });
        break;
      }
    }
  }

  _getLocaldata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      SocietyId = prefs.getString(constant.Session.SocietyId);
      MemberId = prefs.getString(constant.Session.Member_Id);
    });
  }

  _PollingAnswerSave() async {
    if (_selectedIndex != null) {
      try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          var data = {
            'Id': 0,
            'PollingOptionId': Answer,
            'MemberId': MemberId,
            'IsSelected': true
          };
          pr.show();
          Services.SavePollingAnswer(data).then((data) async {
            pr.hide();
            if (data.Data != "0" && data.IsSuccess == true) {
              showHHMsg("Answer Saved Successfully", "");
              widget.onchange();
            } else {
              showHHMsg("Your Answer is Already Submited", "");
              pr.hide();
            }
          }, onError: (e) {
            pr.hide();
            showHHMsg("Try Again.", "");
          });
        } else {
          pr.hide();
          showHHMsg("No Internet Connection.", "");
        }
      } on SocketException catch (_) {
        showHHMsg("No Internet Connection.", "");
      }
    } else {
      Fluttertoast.showToast(
          msg: "Please Select Your Answer", toastLength: Toast.LENGTH_LONG);
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
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 2.0),
      child: Card(
        elevation: 2,
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 9.0, top: 9),
              child: Text(
                  "${widget.index}) " +
                      "${widget.PollingData["PollingData"]["Title"]}",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(81, 92, 111, 1))),
            ),
            _submited
                ? MyAnswerComponent(widget.PollingData, answerIndex)
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 4.0, bottom: 6.0, top: 4),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            widget.PollingData["PollingOptionList"].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: _selectedIndex != null &&
                                          _selectedIndex == index
                                      ? Colors.grey[100]
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0))),
                              child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _onSelected(index);
                                      Answer = widget
                                          .PollingData["PollingOptionList"]
                                              [index]["Id"]
                                          .toString();
                                      print(widget
                                              .PollingData["PollingOptionList"]
                                          [index]);
                                    });
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      _selectedIndex != null &&
                                              _selectedIndex == index
                                          ? Image.asset(
                                              'images/success.png',
                                              width: 20,
                                            )
                                          : Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Colors.grey)),
                                            ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "${widget.PollingData["PollingOptionList"][index]["Title"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _selectedIndex != null
                    ? SizedBox(
                        width: 100,
                        child: FlatButton(
                            onPressed: () {
                              _PollingAnswerSave();
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: constant.appPrimaryMaterialColor),
                            )),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
