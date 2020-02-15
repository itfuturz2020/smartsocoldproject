import 'package:flutter/material.dart';

class MaidComponent extends StatefulWidget {
  @override
  _MaidComponentState createState() => _MaidComponentState();
}

class _MaidComponentState extends State<MaidComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
           Row(
             children: <Widget>[
               Padding(
                   padding: const EdgeInsets.only(top:8.0,left: 8.0,bottom: 8.0),
                   child: ClipOval(
                       child: /*widget._staffInSideList["Image"] == null && widget._staffInSideList["Image"] == '' ?*/
                       /*FadeInImage.assetNetwork(
                           placeholder: 'images/Logo.png',
                           image:
                           "${IMG_URL+widget._staffInSideList["Image"]}",
                           width: 50,
                           height: 50,
                           fit: BoxFit.fill)*/
                           Image.asset('images/user.png',width: 50,height: 50,)
                   )
               ),
             ],
           )
        ],
      )
    );
  }
}
