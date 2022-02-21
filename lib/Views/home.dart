import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wallpaperfreak/Views/searchscreen.dart';
import 'package:wallpaperfreak/Views/fullscreen.dart';
import 'package:wallpaperfreak/data/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pImages = [];
  bool isLoading = true;
  var page = Random();
  int rPage = 0;
  TextEditingController searchQuery = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isLoadingC = true;

  bool netConnection = false;

  bool isLoadingB = false;
  void getTrendingWallpapers() async {
    rPage = page.nextInt(85);
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=" +
            rPage.toString()),
        headers: {
          "Authorization":
              "563492ad6f9170000100000114f5a397a9a1479d887af67fa8a5e727"
        });
    Map jsonData = jsonDecode(response.body);
    setState(() {
      pImages = jsonData["photos"];
    });
    setState(() {
      isLoading = false;
      isLoadingC = false;
    });
  }

//-------------------------------init state--------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    checkInternet();
    getTrendingWallpapers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchQuery.dispose();
    _scrollController.dispose();
  }

  loadMore() async {
    rPage = rPage + 1;
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=" +
            rPage.toString()),
        headers: {
          "Authorization":
              "563492ad6f9170000100000114f5a397a9a1479d887af67fa8a5e727"
        });
    Map jsonData = jsonDecode(response.body);
    setState(() {
      pImages.addAll(jsonData["photos"]);
    });
    setState(() {
      isLoading = false;
    });
    if (jsonData["photos"].length == 0) {
      Fluttertoast.showToast(
          msg: "No further results found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }
  }

//---------------------------Check Internet--------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
  void checkInternet() async {
    try {
      final net = await InternetAddress.lookup('example.com');
      if (net.isNotEmpty && net[0].rawAddress.isNotEmpty) {
        setState(() {
          netConnection = true;
        });
        netConnection = true;
      }
    } on SocketException catch (_) {
      setState(() {
        netConnection = false;
      });
      netConnection = false;
    }
  }
//-------------------------------------Reload state-----------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

  bool stateReload(BuildContext context, isLoading) {
    checkInternet();
    return isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: titleText(context),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.02),
          color: Colors.white,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(25)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        controller: searchQuery,
                        decoration: const InputDecoration(
                            hintText: "Search", border: InputBorder.none),
                        onSubmitted: (value) {
                          if (value == "") {
                            Fluttertoast.showToast(
                                msg: "Type something to search ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 12.0);
                          } else if (netConnection == false) {
                            Fluttertoast.showToast(
                                msg: "Connect to an internet connection first",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 12.0);
                          } else {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                            searchQuery: value,
                                            searchBar: false)))
                                .then((_) => searchQuery.text = "");
                          }
                        },
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          if (searchQuery.text == "") {
                            Fluttertoast.showToast(
                                msg: "Type something to search ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 12.0);
                          } else if (netConnection == false) {
                            Fluttertoast.showToast(
                                msg: "Connect to an internet connection first",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 12.0);
                          } else {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchScreen(
                                            searchQuery: searchQuery.text,
                                            searchBar: false)))
                                .then((_) => searchQuery.text = "");
                          }
                        },
                        child: const Icon(Icons.search))
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.builder(
                    itemCount: categoryData.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: categoryCards(context, categoryData[index][0],
                            categoryData[index][1], netConnection),
                      );
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Divider(
                thickness: 2,
                color: Colors.grey,
                indent: MediaQuery.of(context).size.width * 0.2,
                endIndent: MediaQuery.of(context).size.width * 0.2,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              (netConnection == false)
                  ? Image.asset(
                    "assets/nonet.png",
                    height: MediaQuery.of(context).size.height * 0.35,
                  )
                  : (isLoading == true && isLoadingC == true)
                      ? Container()
                      : Expanded(
                          child: GridView.builder(
                              controller: _scrollController,
                              itemCount: pImages.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      crossAxisCount: 3,
                                      childAspectRatio: 4 / 6,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            child: FullScreenDisplay(
                                              imageUrl: pImages[index]["src"]
                                                  ["portrait"],
                                              index: index,
                                            )));
                                  },
                                  child: Hero(
                                    tag: index.toString(),
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      color: Colors.black38,
                                      child: CachedNetworkImage(
                                        imageUrl: pImages[index]["src"]
                                            ["portrait"],
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          "assets/load.gif",
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
              (netConnection == false)
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isLoadingB = true;
                          isLoadingB = stateReload(context, isLoadingB);
                        });
                      },
                      child:
                          fullScreenButtons(context, isLoadingB, "Reload"))
                  : (isLoading == true && isLoadingC == true)
                      ? Expanded(
                          child: Container(
                              alignment: Alignment.center,
                              child: (isLoading == true)
                                  ? const CircularProgressIndicator()
                                  : null),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: (isLoading == true)
                              ? Container(
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  height: MediaQuery.of(context).size.height *
                                      0.045,
                                  child: const CircularProgressIndicator())
                              : null),
            ],
          ),
        ),
      ),
    );
  }
}

Widget titleText(BuildContext context) {
  return RichText(
    text: TextSpan(children: [
      TextSpan(
          text: "Wallpaper",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06)),
      TextSpan(
          text: "Freak",
          style: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06))
    ]),
  );
}

Widget categoryCards(BuildContext context, imageText, imageUrl, netConnection) {
  return InkWell(
    onTap: () {
      if (netConnection == false) {
        Fluttertoast.showToast(
            msg: "Connect to an internet connection first",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 12.0);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchScreen(
                      searchQuery: imageText,
                      searchBar: true,
                      urlImage: imageUrl,
                    )));
      }
    },
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.1,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(),
              )),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.1,
            alignment: Alignment.center,
            child: Text(
              imageText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.04),
            ),
            color: Colors.black26,
          ),
        )
      ],
    ),
  );
}
