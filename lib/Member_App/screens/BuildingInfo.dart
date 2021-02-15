import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class BuildingInfo extends StatefulWidget {
  var societyData;

  BuildingInfo({this.societyData});

  @override
  _BuildingInfoState createState() => _BuildingInfoState();
}

class _BuildingInfoState extends State<BuildingInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Building Information', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 3.5,
            child: widget.societyData["Image"] == null ?
           Image.asset("images/Building.png")
           : FadeInImage.assetNetwork(
              placeholder: "",
              image: "${constant.Image_Url}${widget.societyData["Image"]}",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${widget.societyData["Name"]},",
                  style: TextStyle(
                    fontSize: 24,
                    color: constant.appPrimaryMaterialColor,
                  ),
                ),
                Text(
                  "${widget.societyData["Address"]},",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(widget.societyData["CityName"] == null ? "VIP road"
                 : "${widget.societyData["AreaName"]},",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(widget.societyData["CityName"] == null ? "Surat"
                  :"${widget.societyData["CityName"]},",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(widget.societyData["CityName"] == null ? "Gujrat"
                  :"${widget.societyData["StateName"]},",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
