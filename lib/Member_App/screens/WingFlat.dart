import 'dart:developer';

import 'package:bidirectional_scroll_view/bidirectional_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;
import 'package:smart_society_new/Member_App/common/constant.dart' as constant;

class WingFlat extends StatefulWidget {
  var floorData, maxUnitData, formatData;

  WingFlat({this.floorData, this.formatData, this.maxUnitData});

  @override
  _WingFlatState createState() => _WingFlatState();
}

class _WingFlatState extends State<WingFlat> {
  Color color1;
  int rowscolumn = 0;
  List colors = [];

  List flatList = [];
  List flatColorsList = [
    constant.appPrimaryMaterialColor,
    Colors.grey,
    Colors.orange,
    Colors.black,
    Colors.blueAccent,
  ];

  @override
  void initState() {
    rowscolumn = int.parse(widget.floorData) * int.parse(widget.maxUnitData);
    color1 = constant.appPrimaryMaterialColor;
    /*for (int i = 0; i < rowscolumn; i++) {
      colors.add(color1);
    }*/
    print("=========================");
    print(widget.formatData);
    formatGrid();
  }

  formatGrid() {
    if (widget.formatData == 1) {
      int flatCount = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
          });
          flatCount++;
        }
      }
    } else if (widget.formatData == 0) {
      int flatCount = 101;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
          });
          flatCount++;
        }
        flatCount = flatCount + 100 - int.parse(widget.maxUnitData);
      }
    } else if (widget.formatData == 2) {
      int flatCount = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          if (i == 0) {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': "G" + flatCount.toString(),
            });
          } else {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': flatCount,
            });
          }
          flatCount++;
          print("================bb");
          print(flatCount);
        }
        flatCount = flatCount + 100 - int.parse(widget.maxUnitData);
      }
    } else if (widget.formatData == 3) {
      int flatCount = 1;
      int flatCountG = 1;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          if (i == 0) {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': "G" + flatCountG.toString(),
            });
            flatCountG++;
          } else {
            flatList.add({
              'flatTypeColor': flatColorsList[0],
              'flatNumber': flatCount,
            });
            flatCount++;
          }
          print("================aaaa");
          print(flatCount);
        }
        print("================");
        print(flatCount);
      }
    } else if (widget.formatData == 4) {
      int flatCount = 101;
      for (int i = 0; i < int.parse(widget.floorData); i++) {
        for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
          print("================");
          print(flatCount);
          flatList.add({
            'flatTypeColor': flatColorsList[0],
            'flatNumber': flatCount,
          });
          //flatCount++;
          flatCount += 100;
          print("================bb");
          print(flatCount);
        }
        flatCount = flatCount + 1 - int.parse(widget.maxUnitData) * 100;
      }
    }
  }

  getFloorAndFlat() {
    return GridView.count(
        crossAxisCount: int.parse(widget.maxUnitData),
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 8.0,
        children: List.generate(flatList.length, (index) {
          return GestureDetector(
            onTap: () {
              changeColor(index: index);
            },
            child: Container(
              height: MediaQuery.of(context).size.width /
                  int.parse(widget.maxUnitData),
              width: MediaQuery.of(context).size.width /
                  int.parse(widget.maxUnitData),
              color: flatList[index]["flatTypeColor"],
              alignment: Alignment.center,
              margin: EdgeInsets.all(5),
              child: Text(
                "${flatList[index]["flatNumber"]}",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }));

    // int flatNo = 1;
    //
    // List<Widget> columnList = [];
    // for (int i = 0; i < int.parse(widget.floorData); i++) {
    //   List<Widget> rowList = [];
    //   for (int j = 0; j < int.parse(widget.maxUnitData); j++) {
    //     rowList.add(
    //       Flexible(
    //         child: GestureDetector(
    //           onTap: () {
    //             changeColor();
    //           },
    //           child: Container(
    //             height: MediaQuery.of(context).size.width /
    //                 int.parse(widget.maxUnitData),
    //             width: MediaQuery.of(context).size.width /
    //                 int.parse(widget.maxUnitData),
    //             color: color1,
    //             alignment: Alignment.center,
    //             margin: EdgeInsets.all(5),
    //             child: Text(
    //               "$flatNo",
    //               style: TextStyle(color: Colors.white),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //     flatNo++;
    //   }
    //   columnList.add(Row(children: rowList));
    // }
    // return columnList;
  }

  changeColor({int index}) {
    setState(() {
      int colorIndex = flatColorsList.indexOf(flatList[index]["flatTypeColor"]);
      if (colorIndex <= 3)
        flatList[index]["flatTypeColor"] = flatColorsList[colorIndex + 1];
      else
        flatList[index]["flatTypeColor"] = flatColorsList[0];
    });
  }

  /*changeColor({int index}) {
    setState(() {
      if (colors[index] == constant.appPrimaryMaterialColor) {
        // color1 = Colors.grey;
        colors[index] = Colors.grey;
      } else if (colors[index] == Colors.grey) {
        // color1 = Colors.orange;
        colors[index] = Colors.orange;
      } else if (colors[index] == Colors.orange) {
        // color1 = Colors.black;
        colors[index] = Colors.black;
      } else if (colors[index] == Colors.black) {
        // color1 = Colors.blueAccent;
        colors[index] = Colors.blueAccent;
      } else if (colors[index] == Colors.blueAccent) {
        // color1 = constant.appPrimaryMaterialColor;
        colors[index] = constant.appPrimaryMaterialColor;
      } else {
        // color1 = constant.appPrimaryMaterialColor;
        colors[index] = constant.appPrimaryMaterialColor;
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wing"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: constant.appPrimaryMaterialColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Owner",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Closed",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.orange,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Rent",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Dead",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      height: 15,
                      width: 15,
                      color: Colors.blue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(
                      "Shop",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            /* Expanded(
              child: BidirectionalScrollViewPlugin(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: myRowChildren,
                ),
              ),
            ),*/
            Expanded(
              child:
                  // SingleChildScrollView(
                  //   child:
                  // Column(
                  //   children:
                  getFloorAndFlat(),
              // ),
              // ),
            )

            // Expanded(
            //   child: StaggeredGridView.countBuilder(
            //       physics: ScrollPhysics(),
            //       shrinkWrap: true,
            //       scrollDirection: Axis.vertical,
            //       crossAxisCount: 4,
            //       itemCount: 10,
            //       staggeredTileBuilder: (_) => StaggeredTile.fit(2),
            //       itemBuilder: (BuildContext context, int index) {
            //         return GestureDetector(
            //           onTap: (){
            //             Navigator.pushNamed(context, "/WingDetail");
            //           },
            //           child: SizedBox(
            //             height: 100,
            //             width: 100,
            //             child: Card(
            //               borderOnForeground: true,
            //               color: Colors.grey[200],
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //                 children: <Widget>[
            //                   Text(
            //                     "a",
            //                     style: TextStyle(
            //                       fontSize: 25.0,
            //                       fontWeight: FontWeight.w500,
            //                     ),
            //                     softWrap: true,
            //                     textAlign: TextAlign.center,
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // )
          ],
        ),
      ),
    );
  }
}
