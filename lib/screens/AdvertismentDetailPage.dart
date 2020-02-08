import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:neeko/neeko.dart';
import 'package:smart_society_new/common/constant.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AdvertisemnetDetail extends StatefulWidget {
  var data;

  AdvertisemnetDetail(this.data);

  @override
  _AdvertisemnetDetailState createState() => _AdvertisemnetDetailState();
}

class _AdvertisemnetDetailState extends State<AdvertisemnetDetail> {
  GoogleMapController mapController;
  final LatLng _center = const LatLng(21.203510, 72.839233);
  //VideoPlayerController _controller;
  /*static const String beeUri =
      'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4';

  final VideoControllerWrapper videoControllerWrapper = VideoControllerWrapper(
      DataSource.network(
          'http://vfx.mtime.cn/Video/2019/03/09/mp4/190309153658147087.mp4',
          displayName: "displayName"));*/
  YoutubePlayerController _controller;
  String _playerStatus = '';

  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
      YoutubePlayer.convertUrlToId('https://youtu.be/_nBKxvQCsx0'),
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        forceHideAnnotation: true,
        loop: true,
      ),
    )..addListener(listener);
   //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
  void listener() {
    if (_isPlayerReady) {
      if (mounted && !_controller.value.isFullScreen) {
        setState(() {
          _playerStatus = _controller.value.playerState.toString();
        });
      }
    }
  }

  _openWhatsapp(mobile) {
    String whatsAppLink = constant.whatsAppLink;
    String urlwithmobile = whatsAppLink.replaceAll("#mobile", "91$mobile");
    String urlwithmsg = urlwithmobile.replaceAll("#msg", "");
    launch(urlwithmsg);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Advertise Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /*Row(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                            border: Border.all(color: Colors.grey, width: 0.4)),
                        width: 74,
                        height: 74,
                      ),
                      ClipOval(
                        child: widget.data["MemberImage"] != null &&
                                widget.data["MemberImage"] != ""
                            ? FadeInImage.assetNetwork(
                                placeholder: "images/image_loading.gif",
                                image:
                                    Image_Url + "${widget.data["MemberImage"]}",
                                width: 70,
                                height: 70)
                            : Image.asset(
                                "images/man.png",
                                width: 70,
                                height: 70,
                              ),
                      ),
                    ],
                    alignment: Alignment.center,
                  ),
                  Padding(padding: EdgeInsets.only(left: 7)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${widget.data["MemberName"]}",
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600),
                        ),
                        Text("${widget.data["ContactNo"]}",
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),*/
              Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    /*NeekoPlayerWidget(
                      onSkipPrevious: () {
                        print("skip");
                        videoControllerWrapper.prepareDataSource(DataSource.network(
                            "http://vfx.mtime.cn/Video/2019/03/12/mp4/190312083533415853.mp4",
                            displayName: "This house is not for sale"));
                      },
                      videoControllerWrapper: videoControllerWrapper,
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              print("share");
                            })
                      ],
                    ),*/
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.new_releases,
                            size: 15,
                            color: Colors.grey[600],
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Expanded(
                            child: Text(
                              "${widget.data["Title"]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(
                              Icons.message,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 4)),
                          Expanded(
                            child: Text(
                              "${widget.data["Description"]}",
                              style:
                                  TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                      height: 170,
                      viewportFraction: 1.0,
                      autoPlayAnimationDuration: Duration(milliseconds: 1500),
                      reverse: false,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlay: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 7),
                          child: Image.network(
                            Image_Url + widget.data["Image"],
                            fit: BoxFit.fill,
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(children: [
                        Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width,
                          child:YoutubePlayer(
                            controller: _controller,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: appPrimaryMaterialColor,
                            topActions: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  _controller.toggleFullScreenMode();
                                },
                              ),
                            ],
                            onReady: () {
                              _isPlayerReady = true;
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 27)),
                        ),
                      ]),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 8),
                        child: Text("Contact Information",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700])),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Name :",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Text(
                                "Website :",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${widget.data["MemberName"]}",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () {
                                  launch("http://itfuturz.com/");
                                },
                                child: Text(
                                  "http://itfuturz.com/",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              _openWhatsapp(widget.data["ContactNo"]);
                            },
                            child: Container(
                              color: Colors.green[400],
                              height: 30,
                              width: MediaQuery.of(context).size.width / 4.29,
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Image.asset(
                                "images/whatsapp.png",
                                width: 43,
                                height: 43,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch('mailto:sagartech9teen@gmail.com?subject=&body=');
                              //launch('mailto:${widget.data["Email"].toString()}?subject=&body=');
                            },
                            child: Container(
                              color: constant.appPrimaryMaterialColor,
                              height: 30,
                              width: MediaQuery.of(context).size.width / 4.29,
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Image.asset(
                                "images/mail.png",
                                width: 23,
                                height: 12,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("tel:${widget.data["ContactNo"]}");
                            },
                            child: Container(
                              color: Colors.green[400],
                              height: 30,
                              width: MediaQuery.of(context).size.width / 4.29,
                              padding: EdgeInsets.symmetric(vertical: 7),
                              child: Image.asset(
                                "images/call.png",
                                width: 23,
                                height: 23,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            color: constant.appPrimaryMaterialColor,
                            height: 30,
                            width: MediaQuery.of(context).size.width / 4.29,
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Image.asset(
                              "images/navigation.png",
                              width: 23,
                              height: 23,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 12.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
