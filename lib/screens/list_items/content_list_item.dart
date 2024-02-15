import 'dart:io';
import 'dart:typed_data';
import 'dart:ui'as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formula_user/models/content_item_model.dart';
import 'package:formula_user/res/db_helper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/favorite_model.dart';
import '../../res/colours.dart';
import '../../res/styles.dart';
import '../../utilities.dart';
import '../detailed_formula_screen.dart';


class ContentListItem extends StatefulWidget {
  ContentItemModel contentItemModel;
  DBHelper? dbHelper;
  ContentListItem(this.contentItemModel, this.dbHelper);



  @override
  State<ContentListItem> createState() => _ContentListItemState();
}



class _ContentListItemState extends State<ContentListItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInBookmark = false;
  @override
  void initState() {
    super.initState();
   checkIfBookMark();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: scaffoldKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colours.buttonColor2,
                      Colours.buttonColor2,
                      Colours.buttonColor1,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                  widget.contentItemModel.title,
                                  style:
                                  Styles.textWith18withBold(Colours.white)),
                            ),
                            IconButton(
                                onPressed: (){
                                  if(isInBookmark){
                                  widget.dbHelper!.deleteFromFavorite(widget.contentItemModel.id);
                                  setState(() {
                                    isInBookmark = false;
                                  });
                                  }else{
                                    widget.dbHelper!.insert(
                                        FavoriteModel(
                                            id: widget.contentItemModel.id,
                                            title: widget.contentItemModel.title,
                                            image: widget.contentItemModel.imageUrl,
                                            pdf: widget.contentItemModel.pdfUrl
                                        )).then((value){
                                      setState(() {
                                        isInBookmark = true;
                                      });
                                    }).onError((error, stackTrace){
                                      print(error.toString());
                                    });
                                  }


                                },
                                icon:  isInBookmark ? Icon(Icons.favorite):Icon(Icons.favorite_border),
                                color: isInBookmark ? Colours.white : Colours.white ),
                            IconButton(
                                onPressed: (){
                                  SchedulerBinding.instance.addPostFrameCallback((_) {
                                    requestStoragePermission();
                                  });
                                },
                                icon: const Icon(Icons.share),
                                color: Colours.white),
                          ],
                        ),
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
                        bottomRight: Radius.circular(16))
                  // borderRadius: BorderRadius.circular(16)
                ),
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16)),
                    child: GestureDetector(
                        onTap: (){
                          pushToNewRoute(context,  DetailedFormulaScreen(widget.contentItemModel.imageUrl,widget.contentItemModel.pdfUrl));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colours.white
                          ),
                            child: Image.network(widget.contentItemModel.imageUrl)))))
          ],
        ),
      ),
    );
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


  checkDebugPaint() async {
    var debugNeedsPaint = false;

    RenderRepaintBoundary boundary = RenderRepaintBoundary();
    if (kDebugMode) debugNeedsPaint = boundary.debugNeedsPaint;

    if (debugNeedsPaint) {
      print("Waiting for boundary to be painted.");
      await Future.delayed(const Duration(milliseconds: 20));
      return captureModifyAndShare(scaffoldKey);
    }
  }

  void captureModifyAndShare(GlobalKey<State<StatefulWidget>> key) async {
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
      await Share.shareFiles([imagePath], text: 'formula of ${widget.contentItemModel.title}');
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

  Future<void> checkIfBookMark() async {
    // Wait for the result before setting the icon color
    isInBookmark = (await widget.dbHelper?.isInBookMark(widget.contentItemModel.id))!;

    // Set the icon color based on the result
    setState(() {});
  }

  void requestStoragePermission() async {

    var status = await Permission.mediaLibrary.request();
    var status2 = await Permission.storage.request();
    if (status.isGranted || status2.isGranted ) {
      checkDebugPaint();
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


}
