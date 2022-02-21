import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaperfreak/Views/home.dart';

class FullScreenDisplay extends StatefulWidget {
  final int index;
  final String imageUrl;
  const FullScreenDisplay({Key? key, required this.imageUrl, required this.index})
      : super(key: key);

  @override
  _FullScreenDisplayState createState() => _FullScreenDisplayState();
}

class _FullScreenDisplayState extends State<FullScreenDisplay> {
  bool isLoading = false;
  bool isLoadingL = false;
  bool isLoadingB = false;

  Future<void> setWallpaper() async {
    String home = "Home Screen";
    Stream<String> progressString;

    progressString = Wallpaper.imageDownloadProgress(widget.imageUrl);
    progressString.listen((data) {
      setState(() {
        isLoading = true;
      });
    }, onDone: () async {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      home = await Wallpaper.homeScreen(
          options: RequestSizeOptions.RESIZE_EXACT,
          width: width,
          height: height);
      setState(() {
        isLoading = false;
        home = home;
      });
      Fluttertoast.showToast(
          msg: "Wallpaper set",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }, onError: (error) {
      setState(() {
        isLoading = false;
      });
  
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    });
  }

  Future<void> setLockscreen() async {
    String lock = "Lock Screen";
    Stream<String> progressString;
    progressString = Wallpaper.imageDownloadProgress(widget.imageUrl);
    progressString.listen((data) {
      setState(() {
        isLoadingL = true;
      });
    }, onDone: () async {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      lock = await Wallpaper.lockScreen(
          options: RequestSizeOptions.RESIZE_EXACT,
          width: width,
          height: height);
      setState(() {
        isLoadingL = false;
        lock = lock;
      });
      Fluttertoast.showToast(
          msg: "Lockscreen set",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }, onError: (error) {
      setState(() {
        isLoadingL = false;
      });
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    });
  }

  Future<void> setBoth() async {
    String both = "Set Both";
    Stream<String> progressString;
    progressString = Wallpaper.imageDownloadProgress(widget.imageUrl);
    progressString.listen((data) {
      setState(() {
        isLoadingB = true;
      });
    }, onDone: () async {
      var width = MediaQuery.of(context).size.width;
      var height = MediaQuery.of(context).size.height;
      await Wallpaper.homeScreen(
          options: RequestSizeOptions.RESIZE_EXACT,
          width: width,
          height: height);
      await Wallpaper.lockScreen(
          options: RequestSizeOptions.RESIZE_EXACT,
          width: width,
          height: height);
      setState(() {
        isLoadingB = false;
        both = both;
      });
      Fluttertoast.showToast(
          msg: "Both set",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }, onError: (error) {
      setState(() {
        isLoadingB = false;
      });
      Fluttertoast.showToast(
          msg: "Check your internet connection",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleText(context),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Hero(
              tag: widget.index.toString(),
              child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.grey,
                  child: CachedNetworkImage(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.9,
                    imageUrl: widget.imageUrl,
                    placeholder: (context, url) =>
                        Image.asset("assets/load.gif", fit: BoxFit.cover),
                    errorWidget: (context, url, error) => Container(),
                    fit: BoxFit.cover,
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          isLoading = true;
                        });
                        setWallpaper();
                      },
                      child: fullScreenButtons(
                          context, isLoading, "Set Wallpaper")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingL = true;
                        });
                        setLockscreen();
                      },
                      child: fullScreenButtons(
                          context, isLoadingL, "Set Lockscreen")),
                  InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingB = true;
                        });
                        setBoth();
                      },
                      child:
                          fullScreenButtons(context, isLoadingB, "Set Both")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget fullScreenButtons(BuildContext context, isLoadingL, ftext) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(25),
    child: Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.25,
      color: Colors.lightGreen,
      child: isLoadingL == true
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            )
          : Center(
              child: Text(
                ftext,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              ),
            ),
    ),
  );
}
