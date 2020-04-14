import 'package:flutter/material.dart';

class TermsAndConditions extends StatefulWidget {
  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Terms & Conditions', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  "The following Terms and Conditions govern the use of this Open Society Foundations (“the Foundations” or “OSF”) Site and any other site owned or operated by OSF that links to these Terms and Conditions (“the Foundations’ website” or “this Site”)."),
              SizedBox(
                height: 7,
              ),
              Text(
                "Use of Materials on this Site",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "In keeping with the Open Society Foundations’ goals and mission, virtually all of the materials posted on this Site, except for (a) images, and (b) materials that contain a copyright notice for a third party other than the Foundations or the Open Society Institute, are licensed to the public through the Creative Commons Attribution-Non-commercial-No Derivatives license"),
              SizedBox(
                height: 7,
              ),
              Text(
                "Information Submitted Through the Site",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "Be aware that your decision to send personally identifiable information through your use of this Site will subject such information to the privacy laws and standards of the United States. Your submission of information through the Site is governed by OSF's Privacy Policy, which is located at www.opensocietyfoundations.org/policies/privacy (the “Privacy Policy”). Your use of the Site is also subject to our Cookie Policy, which is located at https://www.opensocietyfoundations.org/policies/community-guidelines (the “Cookie Policy”). These Terms & Conditions incorporate by reference the terms and conditions of the Privacy Policy and Cookie Policy"),
              SizedBox(
                height: 7,
              ),
              Text(
                "Rules of Conduct",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "While using the Site you will comply with all applicable laws, rules, and regulations, and with our Community Guidelines, located at https://www.opensocietyfoundations.org/policies/community-guidelines. In addition, we expect users of the Site to respect the rights and dignity of others. Your use of the Site is conditioned on your compliance with the following rules of conduct.")
            ],
          ),
        ),
      ),
    );
  }
}
