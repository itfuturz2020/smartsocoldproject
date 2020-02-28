import 'package:flutter/material.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:url_launcher/url_launcher.dart';

class OtherHelpComponent extends StatefulWidget {
  var data;

  OtherHelpComponent(this.data);

  @override
  _OtherHelpComponentState createState() => _OtherHelpComponentState();
}

class _OtherHelpComponentState extends State<OtherHelpComponent> {
  setTime(String datetime) {
    var time = datetime.split(" ");
    var t = time[1].split(":");
    var meridiam = "";
    if (int.parse(t[0]) > 12) {
      meridiam = "PM";
      t[0] = (int.parse(t[0]) - 12).toString();
    } else {
      meridiam = "AM";
    }
    return "${t[0]}:${t[1]} ${meridiam}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Row(
        children: <Widget>[
          widget.data["Image"] != null || widget.data["Image"] != ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                      child: /*widget._staffInSideList["Image"] == null && widget._staffInSideList["Image"] == '' ?*/
                          FadeInImage.assetNetwork(
                              placeholder: 'images/user.png',
                              image: "${Image_Url}${widget.data["Image"]}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill)))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipOval(
                    child: Image.asset(
                      'images/user.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${widget.data["Name"]}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                Text("${widget.data["Work"]}",
                    style: TextStyle(color: Colors.black)),
                widget.data["lastentry"].length > 0
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          Text(
                              "${setTime(widget.data["lastentry"][0]["InTime"])}"),
                          widget.data["lastentry"][0]["OutTime"] == null ||
                                  widget.data["lastentry"][0]["OutTime"] == ""
                              ? Container()
                              : Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                ),
                          widget.data["lastentry"][0]["OutTime"] == null ||
                                  widget.data["lastentry"][0]["OutTime"] == ""
                              ? Container()
                              : Text(
                                  "${setTime(widget.data["lastentry"][0]["OutTime"])}"),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.data["lastentry"].length > 0
                ? widget.data["lastentry"][0]["OutTime"] == null ||
                        widget.data["lastentry"][0]["OutTime"] == ""
                    ? Container(
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text('Inside',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 12))),
                        decoration: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                      )
                    : Container(
                        height: 20,
                        width: 60,
                        child: Center(
                            child: Text('OutSide',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: 12))),
                        decoration: BoxDecoration(
                            color: Colors.red[500],
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0))),
                      )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 9, right: 7),
            child: GestureDetector(
                onTap: () {
                  launch("tel://${widget.data["ContactNo"]}");
                },
                child: Icon(Icons.phone, color: Colors.green, size: 25)),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                launch("tel://${widget.data["EmergencyContactNo"]}");
              },
              child: Image.asset("images/emergancycall.png",
                  color: Colors.red, height: 25, width: 25),
            ),
          )
        ],
      ),
    );
  }
}
