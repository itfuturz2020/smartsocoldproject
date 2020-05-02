import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Screens/EventDetailAdmin.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class EventsAdmin extends StatefulWidget {
  @override
  _EventsAdminState createState() => _EventsAdminState();
}

class _EventsAdminState extends State<EventsAdmin> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/Dashboard");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Events",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/Dashboard");
              }),
        ),
        body: ListView.separated(
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailAdmin(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Annual Party In Society",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Dec-2020 Annual Party In Society\nAll are Requested To Give Confirmation For Comming OR Not",
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "19-02-2020",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Total : 121",
                              style: TextStyle(
                                color: constant.appPrimaryMaterialColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 5,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: constant.appPrimaryMaterialColor,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/AddEvent');
          },
        ),
      ),
    );
  }
}
