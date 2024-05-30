import 'dart:io';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:share_plus/share_plus.dart';
import '../models/content_item_model.dart';
import '../res/ads.dart';
import '../res/colours.dart';
import '../res/common.dart';
import '../res/db_helper.dart';
import '../res/styles.dart';
import '../subscription_manager.dart';
import 'list_items/content_list_item.dart';

class SearchBarScreen extends StatefulWidget {
  SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> searchResults = [];
  bool isShareLoading = false;
  DBHelper? dbHelper;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    bool isPrimeUser =
        Provider.of<SubscriptionManager>(context).isPrimeMember(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Search here",
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(color: Colours.white),
      ),
      body: RepaintBoundary(
        key: scaffoldKey,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      _performSearch(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: Styles.textWith16bold(Colours.black),
                      hintText: 'Search for items...',
                      hintStyle: Styles.textWith16bold(Colours.black),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: (isPrimeUser
                      ? searchResults.length
                      : searchResults.length +
                          (searchResults.length ~/
                              (Common.adDisplayInterval + 1))),
                  itemBuilder: (context, index) {
                    if (isPrimeUser) {
                      final contentItemModel =
                      ContentItemModel.fromJson(searchResults[index].data() as Map<String, dynamic>);
                      return ContentListItem(contentItemModel,dbHelper);
                    } else {
                      if (!isPrimeUser &&
                          (index + 1) % (Common.adDisplayInterval + 1) == 0) {
                        // Ads are available, show the ad widget after every specified interval
                        return const BannerAdWidget();
                      } else {
                        // Adjusted index to account for the inserted widgets
                        final adjustedIndex = !isPrimeUser
                            ? index - (index ~/ (Common.adDisplayInterval + 1))
                            : index;
                        final contentItemModel =
                        ContentItemModel.fromJson(searchResults[adjustedIndex].data() as Map<String, dynamic>);
                        return ContentListItem(contentItemModel,dbHelper);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _performSearch(String query) {
    final CollectionReference itemsCollection =
        FirebaseFirestore.instance.collection('contentItem');
    final String lowercaseQuery = query.toLowerCase();

    itemsCollection.get().then((querySnapshot) {
      setState(() {
        // Filter documents based on case-insensitive search
        searchResults = querySnapshot.docs
            .where((doc) =>
                doc['title'].toString().toLowerCase().contains(lowercaseQuery))
            .toList();
      });
    });
  }

  Future<Uint8List> captureScreenshot(
      GlobalKey<State<StatefulWidget>> key) async {
    RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(
      pixelRatio: 1.0,
    );
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8List = byteData!.buffer.asUint8List();
    return uint8List;
  }

  Uint8List addWatermark(Uint8List imageBytes, String watermarkText) {
    img.Image image = img.decodeImage(imageBytes)!;
    print(
        'Image dimensions before adding watermark: ${image.width} x ${image.height}');
    img.drawString(image, watermarkText,
        font: img.arial24, color: img.ColorRgb8(129, 133, 137));
    print(
        'Image dimensions after adding watermark: ${image.width} x ${image.height}');
    return Uint8List.fromList(img.encodePng(image));
  }

  void captureModifyAndShare(
      GlobalKey<State<StatefulWidget>> key, String title) async {
    try {
      GlobalKey<ScaffoldState> scaffoldKey = key as GlobalKey<ScaffoldState>;
      Uint8List originalImage = await captureScreenshot(scaffoldKey);

      // Debug prints
      print('Original Image dimensions: ${originalImage.length}');

      Uint8List modifiedImage = addWatermark(originalImage, "Formula");

      // Debug prints
      print('Modified Image dimensions: ${modifiedImage.length}');

      String imagePath = await saveImageLocally(modifiedImage);
      await Share.shareFiles([imagePath], text: 'formula of ${title}');
      setState(() {
        isShareLoading = false;
      });
    } catch (e) {
      setState(() {
        isShareLoading = false;
      });
      print('Error capturing or sharing screenshot: $e');
    }
  }

  Future<String> saveImageLocally(Uint8List imageBytes) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagePath = "${appDocDir.path}/screenshot.png";
    File(imagePath).writeAsBytesSync(imageBytes);
    return imagePath;
  }

  checkDebugPaint(String title) async {
    setState(() {
      isShareLoading = true;
    });
    var debugNeedsPaint = false;

    RenderRepaintBoundary boundary = RenderRepaintBoundary();
    if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;

    if (debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      captureModifyAndShare(scaffoldKey, title);
    }
  }

  void requestStoragePermission(String title) async {
    var status = await Permission.mediaLibrary.request();
    var status2 = await Permission.storage.request();
    if (status.isGranted || status2.isGranted) {
      checkDebugPaint(title);
      print("Storage permission granted");
    } else if (status.isDenied || status2.isGranted) {
      Fluttertoast.showToast(
        msg: "Storage permission denied please grant permission to share",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Storage permission denied");
    } else if (status.isPermanentlyDenied || status2.isGranted) {
      Fluttertoast.showToast(
        msg: "Storage permission permanently denied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Storage permission permanently denied");
      openAppSettings();
    }
  }
}
