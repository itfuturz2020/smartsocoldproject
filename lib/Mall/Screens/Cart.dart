import 'package:flutter/material.dart';
import 'package:smart_society_new/common/constant.dart' as cnst;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              int itemCount = 0;
              return Card(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "lib/Mall/Images/daawat.png",
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Daawat Biryani Basmati Rice Long",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13),
                            ),
                            Text(
                              "${cnst.Inr_Rupee}120/-",
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 36,
                              margin:
                                  EdgeInsets.only(top: 10, left: 5, bottom: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                      icon:
                                          Icon(Icons.remove, color: Colors.red),
                                      onPressed: () {}),
                                  Expanded(
                                    child: Text("1",
                                        style: TextStyle(
                                            color: cnst.appPrimaryMaterialColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.add, color: Colors.red),
                                      onPressed: () {}),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
