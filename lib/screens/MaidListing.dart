import 'package:flutter/material.dart';
import 'package:smart_society_new/component/MaidComponent.dart';

class MaidListing extends StatefulWidget {
  @override
  _MaidListingState createState() => _MaidListingState();
}

class _MaidListingState extends State<MaidListing> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return MaidComponent();
    });
  }
}
