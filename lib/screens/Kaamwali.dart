import 'package:flutter/material.dart';
import 'package:smart_society_new/component/KaamwaliComponent.dart';

class KaamWaliList extends StatefulWidget {
  @override
  _KaamWaliListState createState() => _KaamWaliListState();
}

class _KaamWaliListState extends State<KaamWaliList> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/HomeScreen');
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Kamwali',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/HomeScreen');
              }),
        ),
        body: ListView.builder(itemBuilder: (BuildContext context,int index){
            return KaamwaliComponent();
         },
          itemCount: 10,
        ),
      ),
    );
  }
}
