import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_society_new/Member_App/common/constant.dart';
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

  var newDt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newDt = DateFormat.yMMMEd().format(DateTime.parse(widget.data["Date"]));
    newDt = "${newDt.toString().split(",")[1]}" +
        "${newDt.toString().split(",")[2]}";
    print(newDt);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Row(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child:
                    widget.data["Image"] != "null" || widget.data["Image"] != ""
                        ? FadeInImage.assetNetwork(
                            placeholder: 'images/user.png',
                            image: "${Image_Url}${widget.data["Image"]}",
                            width: 50,
                            height: 50,
                            fit: BoxFit.fill)
                        : Image.asset(
                            'images/user.png',
                            width: 50,
                            height: 50,
                          ),
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${widget.data["Name"]}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                Text("${widget.data["Role"]}",
                    style: TextStyle(color: Colors.black)),
                widget.data["lastentry"].length > 0
                    ? Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.green,
                          ),
                          Flexible(
                            child: Text(
                                "${setTime(widget.data["lastentry"][0]["InTime"])}"),
                          ),
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
                              : Flexible(
                                  child: Text(
                                      "${setTime(widget.data["lastentry"][0]["OutTime"])}"),
                                ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Text(
                      "${newDt.toString().split(" ")[2]}" +
                          " "
                              "${newDt.toString().split(" ")[1]}" +
                          " " +
                          "${newDt.toString().split(" ")[3]}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, bottom: 1),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.0))),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6.0))),
                                )
                          : Container(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: GestureDetector(
                          onTap: () {
                            launch("tel:${widget.data["ContactNo"]}");
                          },
                          child:
                              Icon(Icons.phone, color: Colors.green, size: 25)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          launch("tel:${widget.data["EmergencyContactNo"]}");
                        },
                        child: Image.asset("images/emergancycall.png",
                            color: Colors.red, height: 25, width: 25),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
