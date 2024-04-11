import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formula_user/models/content_item_model.dart';
import 'package:formula_user/res/db_helper.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/favorite_model.dart';
import '../../res/colours.dart';
import '../../res/common.dart';
import '../../res/styles.dart';
import '../../subscription_manager.dart';

class ContentListItem extends StatefulWidget {
  ContentItemModel contentItemModel;
  DBHelper? dbHelper;
  ContentListItem(this.contentItemModel, this.dbHelper, {super.key});

  @override
  State<ContentListItem> createState() => _ContentListItemState();
}

class _ContentListItemState extends State<ContentListItem> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInBookmark = false;
  RewardedAd? _rewardedAd;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';


  @override
  void initState() {
    super.initState();
    checkIfBookMark();
    _loadRewardedAd();

  }

  @override
  Widget build(BuildContext context) {
    bool isPrimeMember = Provider.of<SubscriptionManager>(context).isPrimeMember(context);
    return RepaintBoundary(
      key: scaffoldKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colours.itemCardBackground,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0,right: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
                        child: Text(
                          widget.contentItemModel.title,
                          style: Styles.textWith16bold(Colours.white),
                          /*scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          startPadding: 10.0,
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.easeInCirc,
                          decelerationDuration: const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,*/
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if(isPrimeMember){
                          _addToBookmarks();
                        }else{
                          if (_rewardedAd != null) {
                            _showRewardedAd();
                          } else {
                            print('Rewarded ad not available yet. Please try again later.');
                            // Alternatively, you can call _addToBookmarks() directly here if rewarded ad is not available
                          }
                        }
                      },
                      child: SvgPicture.asset(
                        isInBookmark
                            ? "assets/bookmark.svg"
                            : "assets/bookmark_border.svg",
                        width: 22,
                        height: 22,
                        color: Colours.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          requestStoragePermission();
                        });
                      },
                      child: Padding(
                          padding:
                          const EdgeInsets.only(left: 2, right: 8.0),
                          child: SvgPicture.asset("assets/share_icon.svg",
                              width: 22, height: 22, color: Colours.white)),
                    ),
                  ],
                ),
              ),
            ),
            /*Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colours.itemCardBackground,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                                textAlign: TextAlign.start,
                                maxLines: 5,
                                widget.contentItemModel.title,
                                style: Styles.textWith14(Colours.buttonColor2)),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isInBookmark) {
                              widget.dbHelper!.deleteFromFavorite(
                                  widget.contentItemModel.id);
                              setState(() {
                                isInBookmark = false;
                              });
                            } else {
                              widget.dbHelper!
                                  .insert(FavoriteModel(
                                id: widget.contentItemModel.id,
                                title: widget.contentItemModel.title,
                                image: widget.contentItemModel.imageUrl,
                                pdf: widget.contentItemModel.pdfUrl,
                              ))
                                  .then((value) {
                                setState(() {
                                  isInBookmark = true;
                                });
                              }).onError((error, stackTrace) {
                                print(error.toString());
                              });
                            }
                          },
                          child: SvgPicture.asset(
                            isInBookmark
                                ? "assets/bookmark.svg"
                                : "assets/bookmark_border.svg",
                            width: 20,
                            height: 20,
                            color: Colours.white,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              requestStoragePermission();
                            });
                          },
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 2, right: 8.0),
                              child: SvgPicture.asset("assets/share_icon.svg",
                                  width: 20, height: 20, color: Colours.white)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),*/
            Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colours.itemCardBackground, width: 1),
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
                        // onTap: (){
                        //   pushToNewRoute(context,  DetailedFormulaScreen(widget.contentItemModel.imageUrl,widget.contentItemModel.pdfUrl));
                        // },
                        child: Container(
                            decoration: BoxDecoration(color: Colours.white),
                            child: Image.network(
                                widget.contentItemModel.imageUrl)))))
          ],
        ),
      ),
    );
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
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image capturedImage = await boundary.toImage(pixelRatio: 1);
      ByteData? byteData =
          await capturedImage.toByteData(format: ui.ImageByteFormat.png);
      GlobalKey<ScaffoldState> scaffoldKey = key as GlobalKey<ScaffoldState>;
      Uint8List originalImage = await captureScreenshot(scaffoldKey);

      // Debug prints
      print('Original Image dimensions: ${originalImage.length}');

      Uint8List modifiedImage = addWatermark(originalImage, "Formula");

      // Debug prints
      print('Modified Image dimensions: ${modifiedImage.length}');

      String imagePath = await saveImageLocally(modifiedImage);
      await Share.shareFiles([imagePath],
          text: 'formula of ${widget.contentItemModel.title}');
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
    isInBookmark =
        (await widget.dbHelper?.isInBookMark(widget.contentItemModel.id))!;
  }

  void requestStoragePermission() async {
    var status = await Permission.mediaLibrary.request();
    var status2 = await Permission.storage.request();
    if (status.isGranted || status2.isGranted) {
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


  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          print('[AdMob] Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  void _showRewardedAd() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        _loadRewardedAd();
        print('ad onAdDismissedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _loadRewardedAd();
        print('ad onAdFailedToShowFullScreenContent: $error');
      },
    );

    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(onUserEarnedReward: (Ad ad, RewardItem reward) {
      print('User rewarded: ${reward.amount}');
      // Implement your reward logic here
      _addToBookmarks();
    });
  }


  void _addToBookmarks() {
    if (isInBookmark) {
      widget.dbHelper!.deleteFromFavorite(
          widget.contentItemModel.id);
      setState(() {
        isInBookmark = false;
      });
    } else {
      widget.dbHelper!
          .insert(FavoriteModel(
        id: widget.contentItemModel.id,
        title: widget.contentItemModel.title,
        image: widget.contentItemModel.imageUrl,
        pdf: widget.contentItemModel.pdfUrl,
      ))
          .then((value) {
        setState(() {
          isInBookmark = true;
        });
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }
  }
}
