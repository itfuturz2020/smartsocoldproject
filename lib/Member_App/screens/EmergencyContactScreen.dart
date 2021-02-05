import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatefulWidget {
  @override
  _EmergencyContactScreenState createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 18),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    // backgroundImage:
                    // Icon(Icons.local_police)
                    // AssetImage(
                    //   "images/automobile.png",
                    // ),
                    backgroundColor: appPrimaryMaterialColor[700],
                    radius: 35,
                    child: Icon(
                      Icons.local_police_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "POLICE",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "100",
                            style: TextStyle(
                              fontSize: 15,
                              color: appPrimaryMaterialColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      launch(('tel:// 100'));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.call,
                        size: 30,
                        color: appPrimaryMaterialColor,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      // backgroundImage:
                      // Icon(Icons.local_police)
                      // AssetImage(
                      //   "images/automobile.png",
                      // ),
                      backgroundColor: appPrimaryMaterialColor[700],
                      radius: 35,
                      child: Icon(
                        Icons.local_fire_department_sharp,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "FIRE STATION",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "101",
                              style: TextStyle(
                                fontSize: 15,
                                color: appPrimaryMaterialColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        launch(('tel:// 101'));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.call,
                          size: 30,
                          color: appPrimaryMaterialColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      // backgroundImage:
                      // Icon(Icons.local_police)
                      // AssetImage(
                      //   "images/automobile.png",
                      // ),
                      backgroundColor: appPrimaryMaterialColor[700],
                      radius: 35,
                      child: Icon(
                        Icons.local_hospital_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AMBULANCE",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "108",
                              style: TextStyle(
                                fontSize: 15,
                                color: appPrimaryMaterialColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        launch(('tel:// 108'));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.call,
                          size: 30,
                          color: appPrimaryMaterialColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
