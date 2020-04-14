import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Privacy Policy', style: TextStyle(fontSize: 18)),
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
                "Privacy policy",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "The Royal Society is committed to protecting and respecting your privacy"
                  "This Policy sets out how and why we (the Royal Society) use your personal data, and how we protect your privacy when doing so."
                  "Please read the following carefully to understand how we will use your 'personal data'. 'Personal data' means any information relating to you, through which you can be identified either directly or indirectly such as name and contact details, biographical information or information about your interests/qualifications."
                  "There are types of personal data that are more sensitive in nature and therefore require a higher level of protection; this type of data is classified as ‘special categories of personal data ’."
                  "(Examples of special categories of personal data include race; ethnic origin; political opinions; religious or philosophical beliefs; trade union membership; genetic data; biometric data used for identification purposes"),
              SizedBox(
                height: 7,
              ),
              Text(
                "Changes to this privacy policy",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "We keep this Policy under regular review and it may be modified from time to time. Please check back here for further updates. This policy was last updated on 25 February 2020."),
              SizedBox(
                height: 7,
              ),
              Text(
                "Candidates for Fellowship and Foreign Membership",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              Text(
                  "Candidates being elected for Fellowship or Foreign Membership are requested to acknowledge their nomination and will be informed of our intention to keep their personal details on file. Personal data that is provided to us for the purposes of the election process will be kept securely at the Society for seven years (from the initial year of nomination) in the case of a first nomination, and three years (from the initial year of nomination) in the case of any subsequent nominations."
                  "As part of the election process, your personal data will be supplied to third parties in a selected peer group chosen from the same scientific field or knowledge sector for the purposes of refereeing. These third parties will be mainly Fellows and Foreign Members of the Royal Society, however some non-Fellows within and outside of the EEA may also be approached. References that we receive about you will be retained in electronic format on our nomination system for two years after each election while you are a nominee. A complete set of references in hard copy will be transferred to our historical archives at the conclusion of every election. On election, or in the event of your nomination lapsing, your references will also be removed from the nominations system to our historical archives. Personal data stored in our archives will be held for the purpose of historical public and research interest and, in the case of nominations to the Fellowship, will not be made accessible until the death of all individuals involved.")
            ],
          ),
        ),
      ),
    );
  }
}
