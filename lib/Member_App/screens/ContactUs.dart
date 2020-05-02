import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Contact Us', style: TextStyle(fontSize: 18)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                launch('mailto:Myjini@gmail.com?subject=&body=');
              },
              child: ListTile(
                title: Text("Myjini@gmail.com"),
                subtitle: Text("Email"),
                leading: Icon(
                  Icons.email,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                launch('tel:9429828152');
              },
              child: ListTile(
                title: Text("9429828152"),
                subtitle: Text("Mobile Number"),
                leading: Icon(
                  Icons.call,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                _launchURL("https://www.google.com");
              },
              child: ListTile(
                title: Text("Myjini.com"),
                subtitle: Text("Website"),
                leading: Icon(
                  Icons.web,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launch("https://www.facebook.com/myjinismartsociety/");
              },
              child: ListTile(
                title: Text("myjinismartsociety"),
                subtitle: Text("Facebook"),
                leading: Icon(
                  Icons.account_box,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _launchURL("https://www.instagram.com/myjini_smartsociety/");
              },
              child: ListTile(
                title: Text("myjini_smartsociety"),
                subtitle: Text("Instagram"),
                leading: Icon(
                  Icons.account_box,
                  color: constant.appPrimaryMaterialColor,
                ),
              ),
            )
          ],
        ));
  }
}
