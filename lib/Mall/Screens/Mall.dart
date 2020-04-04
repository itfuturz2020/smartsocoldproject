import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:smart_society_new/Mall/Common/MallConstants.dart';
import 'package:smart_society_new/Mall/Common/MallServices.dart';
import 'package:smart_society_new/Mall/Common/ExtensionMethods.dart';
import 'package:smart_society_new/Mall/Screens/AllProducts.dart';
import 'package:smart_society_new/Mall/Screens/OtherProducts.dart';
import 'package:smart_society_new/common/constant.dart' as cnst;

class Mall extends StatefulWidget {
  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall> {
  List _bannerData = [];

  bool isLoading = false;
  int currentIndex = 0;

  @override
  void initState() {
    _getBanner();
  }

  _getBanner() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        MallServices.GetBanner().then((data) async {
          setState(() {
            isLoading = false;
          });
          if (data.success == "1" && data.data.length > 0) {
            setState(() {
              _bannerData = data.data;
            });
          }
        }, onError: (e) {
          setState(() {
            isLoading = false;
          });
          showMsg("Something Went Wrong");
        });
      }
    } on SocketException catch (_) {
      showMsg("No Internet Connection.");
    }
  }

  showMsg(String msg, {String title = 'My Jini'}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text(msg),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grocery Mall"),
      ),
      body: Column(
        children: <Widget>[
          _bannerData.length > 0
              ? CarouselSlider(
                  height: 180,
                  viewportFraction: 1.0,
                  autoPlayAnimationDuration: Duration(milliseconds: 1000),
                  reverse: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  autoPlay: true,
                  items: _bannerData.map((i) {
                    return Builder(builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(Mall_Image_Url + i["image"],
                                fit: BoxFit.fill)),
                      );
                    });
                  }).toList(),
                )
              : Container(),
          Expanded(
            child: currentIndex == 0 ? AllProducts() : OtherProducts(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: cnst.appPrimaryMaterialColor,
        unselectedItemColor: Colors.grey[600],
        unselectedIconTheme: IconThemeData(size: 20),
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("All"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            title: Text("Deals"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text("Top Sellers"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Most Liked"),
          ),
        ],
      ),
    );
  }
}
