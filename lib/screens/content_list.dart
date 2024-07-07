
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/res/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_item_model.dart';
import '../models/content_model.dart';
import '../res/ads.dart';
import '../subscription_manager.dart';
import 'list_items/content_list_item.dart';

class ContentList extends StatefulWidget {
  ContentModel item;


  ContentList(this.item,{super.key});

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {

  List<ContentItemModel> list = [];
  DBHelper? dbHelper;


  @override
  void initState() {
    getContentItemData();
    dbHelper = DBHelper();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    bool isPrimeUser = Provider.of<SubscriptionManager>(context).isPrimeMember(context);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (isPrimeUser ? list.length : list.length + (list.length ~/ (Common.adDisplayInterval + 1))),
      itemBuilder: (BuildContext context, int index) {
        if(isPrimeUser){
          return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:AssetImage("assets/app_background.png"),
                      fit: BoxFit.fill
                  )
              ),
              child: ContentListItem(list[index],dbHelper,));
        }else{
          if (!isPrimeUser && (index + 1) % (Common.adDisplayInterval + 1) == 0) {
            // Ads are available, show the ad widget after every specified interval
            return const BannerAdWidget();
          } else {
            // Adjusted index to account for the inserted widgets
            final adjustedIndex = !isPrimeUser ? index - (index ~/ (Common.adDisplayInterval + 1)) : index;
            return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/app_background.png"),
                        fit: BoxFit.fill
                    )
                ),
                child: ContentListItem(list[adjustedIndex], dbHelper,)
            );
          }
        }
      },
    );
  }

  static const cacheDuration = Duration(hours: 1); // Set your refresh interval here

  Future<void> getContentItemData() async {
    list = [];
    CollectionReference contentItemRef =
    FirebaseFirestore.instance.collection('contentItem');
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'contentItem_${widget.item.id}';
    final cacheTimestampKey = '${cacheKey}_timestamp';

    try {
      // Fetch cached data and timestamp
      String? cachedData = prefs.getString(cacheKey);
      int? cacheTimestamp = prefs.getInt(cacheTimestampKey);

      bool shouldFetchFromFirestore = true;
      if (cacheTimestamp != null) {
        final cacheDateTime = DateTime.fromMillisecondsSinceEpoch(cacheTimestamp);
        if (DateTime.now().difference(cacheDateTime) < cacheDuration) {
          shouldFetchFromFirestore = false;
        }
      }

      if (!shouldFetchFromFirestore && cachedData != null) {
        // Load data from cache
        List<dynamic> jsonData = json.decode(cachedData);
        list = jsonData.map((item) => ContentItemModel.fromJson(item)).toList();
      } else {
        // Fetch data from Firestore
        QuerySnapshot querySnapshot = await contentItemRef
            .where("contentId", isEqualTo: widget.item.id.toString())
            .get(const GetOptions(
          source: Source.serverAndCache,
        ));

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            final contentItemModel =
            ContentItemModel.fromJson(doc.data() as Map<String, dynamic>);
            list.add(contentItemModel);
          }
        }

        // Save fetched data and timestamp to cache
        String jsonData = json.encode(list.map((item) => item.toJson()).toList());
        await prefs.setString(cacheKey, jsonData);
        await prefs.setInt(cacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
      }

      // Sort the list
      list.sort((a, b) => a.index.compareTo(b.index));
      setState(() {});
    } catch (e) {
      print("Error fetching content data: $e");
    }
  }




}
