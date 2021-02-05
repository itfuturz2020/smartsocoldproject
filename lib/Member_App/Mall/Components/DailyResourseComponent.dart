import 'package:flutter/material.dart';
import 'package:smart_society_new/Mall_App/Common/Colors.dart';

class DailyResourseComponent extends StatefulWidget {
  @override
  _DailyResourseComponentState createState() => _DailyResourseComponentState();
}

class _DailyResourseComponentState extends State<DailyResourseComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0))),
                            width: 80,
                            height: 80,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Image.asset("images/family.png",
                                  width: 40, color: Colors.grey[400]),
                            )),
                        Text(
                          "Baburao",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Cleaner",
                          style: TextStyle(
                            fontSize: 12,
                            color: appPrimaryMaterialColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.call_sharp,
                      size: 20,
                      color: Colors.black54,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                        color: Colors.grey,
                        width: 1,
                        height: 25,
                      ),
                    ),
                    Icon(
                      Icons.share,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
