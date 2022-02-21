import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:wallpaperfreak/Views/fullscreen.dart';
import 'package:wallpaperfreak/Views/home.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final String searchQuery;
  final bool searchBar;
  final String urlImage;
  const SearchScreen(
      {Key? key,
      required this.searchQuery,
      required this.searchBar,
      this.urlImage = ""})
      : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var pImages = [];
  int rPage = 0;
  bool isLoading = true;

  bool isLoadingC = true;
  @override
  void initState() {
    super.initState();
    searchController.text = widget.searchQuery;
    getSearchWallpaper(widget.searchQuery);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore(widget.searchQuery);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    _scrollController.dispose();
  }

  getSearchWallpaper(String query) async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=" +
            query +
            "&per_page=80&page=" +
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
    if (jsonData["photos"].length == 0) {
      Fluttertoast.showToast(
          msg: "No results found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 12.0);
    }
  }

  loadMore(String query) async {
    rPage = rPage + 1;
    setState(() {
      isLoading = true;
    });
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=" +
            query +
            "&per_page=80&page=" +
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
        margin: const EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.02),
        child: Column(
          children: [
            (widget.searchBar == true)
                ? categoryCardSearch(
                    context, searchController.text, widget.urlImage)
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(25)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                hintText: widget.searchQuery,
                                border: InputBorder.none),
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                              getSearchWallpaper(value);
                            },
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              getSearchWallpaper(searchController.text);
                            },
                            child: const Icon(Icons.search))
                      ],
                    ),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Divider(
              thickness: 3,
              color: Colors.grey,
              indent: MediaQuery.of(context).size.width * 0.3,
              endIndent: MediaQuery.of(context).size.width * 0.3,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            (isLoading == true && isLoadingC == true)
                ? Container()
                : Expanded(
                    child: GridView.builder(
                        controller: _scrollController,
                        itemCount: pImages.length,
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
            (isLoading == true && isLoadingC == true)
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
                            height: MediaQuery.of(context).size.height * 0.045,
                            child: const CircularProgressIndicator())
                        : null),
          ],
        ),
      ),
    );
  }
}

Widget categoryCardSearch(BuildContext context, imageText, imageUrl) {
  var sizeW = MediaQuery.of(context).size.width * 0.8;
  var sizeH = MediaQuery.of(context).size.height * 0.14;
  var sizeF = MediaQuery.of(context).size.width * 0.08;

  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
            width: sizeW,
            height: sizeH,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(),
            )),
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: sizeW,
          height: sizeH,
          alignment: Alignment.center,
          child: Text(
            imageText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: sizeF),
          ),
          color: Colors.black26,
        ),
      )
    ],
  );
}
