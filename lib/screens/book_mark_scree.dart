import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formula_user/res/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../models/favorite_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';

class BookMarksScreen extends StatefulWidget {
  const BookMarksScreen({Key? key}) : super(key: key);

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  DBHelper? dbHelper;
  late Future<List<FavoriteModel>> bookMarkList;
  bool _isLoading = false;
  bool isInBookmark = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    dbHelper = DBHelper();
    loadData();
    super.initState();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    bookMarkList = dbHelper!.getFavoriteList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Book Marks", style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
      ),
      body: RepaintBoundary(
        key: scaffoldKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FutureBuilder(
                  future: bookMarkList,
                  builder: (context, AsyncSnapshot<List<FavoriteModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return  Center(child: Text('Error loading data',style: Styles.textWith16bold(Colours.red900),));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return  Center(child: Text('No data available',style: Styles.textWith16bold(Colours.greyLight700),));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration:  BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                    color: Colours.titleBackground
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8,right: 8,top: 4,bottom: 4),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                    textAlign: TextAlign.center,
                                                    maxLines: 5,
                                                    snapshot.data![index].title,
                                                    style:
                                                    Styles.textWith18withBold(Colours.white)),
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  isInBookmark = false;
                                                  await dbHelper!.deleteFromFavorite(snapshot.data![index].id.toString());

                                                  // Reload data
                                                  loadData();

                                                  // Trigger rebuild of widget tree
                                                  setState(() {});
                                                },
                                                child: SvgPicture.asset(
                                                  isInBookmark ? "assets/bookmark.svg" : "assets/bookmark_border.svg",
                                                  width: 30,
                                                  height: 30,
                                                  color: Colours.white,
                                                ),
                                              ),

                                           InkWell(
                                             onTap: (){
                                               SchedulerBinding.instance.addPostFrameCallback((_) {
                                                 requestStoragePermission(snapshot.data?[index]);
                                               });
                                             },
                                             child: SvgPicture.asset(
                                                      "assets/share_icon.svg",
                                                      width: 30,
                                                      height: 30,

                                                    color: Colours.white),
                                           ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.indigo, width: 1),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        // pushToNewRoute(
                                        //   context,
                                        // //  DetailedFormulaScreen(snapshot.data![index].image.toString(),snapshot.data![index].pdf),
                                        // );
                                      },
                                      child: Image.network(snapshot.data![index].image.toString()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void requestStoragePermission(FavoriteModel? data) async {

    var status = await Permission.mediaLibrary.request();
    var status2 = await Permission.storage.request();
    if (status.isGranted || status2.isGranted ) {
      checkDebugPaint(data);
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
    } else if (status.isPermanentlyDenied || status2.isGranted ) {
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

  checkDebugPaint(FavoriteModel? data) async {
    var debugNeedsPaint = false;

    RenderRepaintBoundary boundary = RenderRepaintBoundary();
    if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;

    if (debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return captureModifyAndShare(scaffoldKey,data);
    }
  }

  void captureModifyAndShare(GlobalKey<State<StatefulWidget>> key, FavoriteModel? data) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image capturedImage = await boundary.toImage(pixelRatio: 1);
      ByteData? byteData = await capturedImage.toByteData(format: ui.ImageByteFormat.png);
      GlobalKey<ScaffoldState> scaffoldKey = key as GlobalKey<ScaffoldState>;
      Uint8List originalImage = await captureScreenshot(scaffoldKey);

      // Debug prints
      print('Original Image dimensions: ${originalImage.length}');

      Uint8List modifiedImage = addWatermark(originalImage, "Formula");

      // Debug prints
      print('Modified Image dimensions: ${modifiedImage.length}');

      String imagePath = await saveImageLocally(modifiedImage);
      await Share.shareFiles([imagePath], text: 'formula of ${data?.title}');
    } catch (e) {
      print('Error capturing or sharing screenshot: $e');
    }
  }

  Future<String> saveImageLocally(Uint8List imageBytes) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String imagePath = "${appDocDir.path}/screenshot.png";
    File(imagePath).writeAsBytesSync(imageBytes);
    return imagePath;
  }

  Future<Uint8List> captureScreenshot(GlobalKey<State<StatefulWidget>> key) async {
    RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 1.0,);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List uint8List = byteData!.buffer.asUint8List();
    return uint8List;
  }

  Uint8List addWatermark(Uint8List imageBytes, String watermarkText) {
    img.Image image = img.decodeImage(imageBytes)!;
    print('Image dimensions before adding watermark: ${image.width} x ${image.height}');
    img.drawString(image, watermarkText, font: img.arial24, color: img.ColorRgb8(129, 133, 137));
    print('Image dimensions after adding watermark: ${image.width} x ${image.height}');
    return Uint8List.fromList(img.encodePng(image));
  }

}
