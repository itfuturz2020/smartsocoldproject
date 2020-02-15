import 'package:flutter/material.dart';
import 'package:smart_society_new/component/MaidComponent.dart';
import 'package:smart_society_new/screens/MaidListing.dart';

class DailyHelp extends StatefulWidget {
  @override
  _DailyHelpState createState() => _DailyHelpState();
}

class _DailyHelpState extends State<DailyHelp> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child:DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text("Maid",style: TextStyle(fontWeight: FontWeight.w600),)),
                Tab(child: Text("Others",style: TextStyle(fontWeight: FontWeight.w600))),
              ],
            ),
            title: Text('Daily Help'),
          ),
          body: TabBarView(
            children: [
              MaidListing(),
              Container()
            ],
          ),
        ),
      ),
    );
  }
}
