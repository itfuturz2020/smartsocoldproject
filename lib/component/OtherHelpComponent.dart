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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
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
                      ))),
              Container(
                width: MediaQuery.of(context).size.width / 1.63,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${widget.data["Name"]}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                    Text("${widget.data["Address"]}",
                        style: TextStyle(color: Colors.black)),
                    widget.data["lastentry"].length > 0
                        ? Row(
                            children: <Widget>[
                              Text(
                                  "${widget.data["lastentry"][0]["VehicleNo"]}",
                                  style: TextStyle(color: Colors.black)),
                              widget.data["lastentry"][0]["OutTime"] != null &&
                                      widget.data["lastentry"][0]["OutTime"] !=
                                          ""
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 10),
                                          child: Text("Inside",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : Container(),
                    Text("${widget.data["Work"]}",
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
