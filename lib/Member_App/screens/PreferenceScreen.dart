import 'package:flutter/material.dart';
import 'package:smart_society_new/Admin_App/Common/Constants.dart';

class PreferenceScreen extends StatefulWidget {
  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool isEmailSwitched = false;
  bool isContactSwitched = false;
  bool isDOBSwitched = false;
  bool isAnniversarySwitched = false;

  void toggleEmailSwitch(bool value) {
    if (isEmailSwitched == false) {
      setState(() {
        isEmailSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isEmailSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleContactSwitch(bool value) {
    if (isContactSwitched == false) {
      setState(() {
        isContactSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isContactSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleDOBSwitch(bool value) {
    if (isDOBSwitched == false) {
      setState(() {
        isDOBSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isDOBSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  void toggleAnniversarySwitch(bool value) {
    if (isAnniversarySwitched == false) {
      setState(() {
        isAnniversarySwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isAnniversarySwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

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
          'Preference',
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
          padding:
              const EdgeInsets.only(left: 15, top: 20, bottom: 20, right: 15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                              //fontWeight: FontWeight.bold
                              ),
                        ),
                        Text(
                          "Choose to Show Email",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        onChanged: toggleEmailSwitch,
                        value: isEmailSwitched,

                        activeColor: appPrimaryMaterialColor,
                        activeTrackColor: appPrimaryMaterialColor[200],

                        // inactiveThumbColor: Colors.redAccent,
                        // inactiveTrackColor: Colors.orange,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Show Contact Details",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleContactSwitch,
                          value: isContactSwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of Birth",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Show Date of Birth",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleDOBSwitch,
                          value: isDOBSwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Anniversary",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.bold
                                ),
                          ),
                          Text(
                            "Choose to Show Anniversary",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          onChanged: toggleAnniversarySwitch,
                          value: isAnniversarySwitched,

                          activeColor: appPrimaryMaterialColor,
                          activeTrackColor: appPrimaryMaterialColor[200],

                          // inactiveThumbColor: Colors.redAccent,
                          // inactiveTrackColor: Colors.orange,
                        )),
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
