import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class WingDetail extends StatefulWidget {
  @override
  _WingDetailState createState() => _WingDetailState();
}

class _WingDetailState extends State<WingDetail> {
  int _currentindex;

  TextEditingController txtname = new TextEditingController();
  TextEditingController txtfloor = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wing - A"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Name",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "") {
                    return 'Please Enter Name';
                  }
                  return null;
                },
                controller: txtname,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Enter Name",
                    hintStyle: TextStyle(fontSize: 13)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Total Floor",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Total Floor';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtfloor,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Total Floor',
                    labelText: "Total Floor",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 5.0, left: 5.0),
            child: Row(
              children: <Widget>[
                Text("Maximum Unit",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0),
            child: SizedBox(
              height: 50,
              child: TextFormField(
                validator: (value) {
                  if (value.trim() == "" || value.length < 10) {
                    return 'Please Enter Maximum Unit';
                  }
                  return null;
                },
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: txtfloor,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    counterText: "",
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.only(top: 5, left: 10, bottom: 5),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 0, color: Colors.black)),
                    hintText: 'Enter Maximum Units',
                    labelText: "Maximum Units",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Choose Number Format",
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]))
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  itemCount: 6,
                  staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentindex = index;
                        });
                        print("wing select-> " + _currentindex.toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: _currentindex == index ?Border.all():null
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top:3.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "101",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "102",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "103",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:3.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "101",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "102",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "103",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "101",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "102",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left:3.0),
                                      child: Container(
                                        height: 30,
                                        width: 45,
                                        decoration:
                                        BoxDecoration(color: constant.appPrimaryMaterialColor[500]),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "103",
                                            style: TextStyle(color: Colors.white, fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    );
                  }),
            ),
          )



        ],
      ),

      bottomNavigationBar:  SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(),
          color: constant.appPrimaryMaterialColor[500],
          textColor: Colors.white,
          splashColor: Colors.white,
          child: Text("Create",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600)),
          onPressed: () {
            Navigator.pushNamed(context, '/WingFlat');
          },
        ),
      ),
    );
  }
}
