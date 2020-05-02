import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class EventDetail extends StatefulWidget {
  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Events Detail',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(
              "Annual Party In Society",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: constant.appPrimaryMaterialColor,
              ),
            ),
            leading: Icon(
              Icons.title,
              size: 20,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "19-02-2020",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: Icon(
              Icons.date_range,
              size: 20,
              color: Colors.grey,
            ),
          ),
          ListTile(
            title: Text(
              "Dec-2020 Annual Party In Society\nAll are Requested To Give Confirmation For Comming OR Not",
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            leading: Icon(
              Icons.info,
              size: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Text(
                    "Are You Going ?",
                    style: TextStyle(
                        color: constant.appPrimaryMaterialColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        onPressed: () {},
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RaisedButton(
                        color: Colors.red,
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        onPressed: () {},
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
