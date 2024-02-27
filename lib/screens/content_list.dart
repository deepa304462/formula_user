
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/res/db_helper.dart';
import '../models/content_item_model.dart';
import '../models/content_model.dart';
import '../res/ads.dart';
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length + (Common.isPrime ? (list.length ~/ 4) : 0),
      itemBuilder: (BuildContext context, int index) {
        if (Common.isPrime && index % 4 == 3) {
          // Ads are available, show the ad widget at this index
          return BannerAdWidget();
        } else {
          // Adjusted index to account for the inserted widgets
          final adjustedIndex = Common.isPrime ? index - (index ~/ 4) : index;
          return ContentListItem(list[adjustedIndex], dbHelper);
        }
      },
    );
  }

  Future<void> getContentItemData() async {
    list = [];
    CollectionReference contentItemRef =
        FirebaseFirestore.instance.collection('contentItem');

    try {
      QuerySnapshot querySnapshot = await contentItemRef
          .where("contentId", isEqualTo: widget.item.id.toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final contentItemModel =
              ContentItemModel.fromJson(doc.data() as Map<String, dynamic>);
          list.add(contentItemModel);
        }
      }
      list.sort((a, b) => a.index.compareTo(b.index));


      //list.insert(2, BannerAdWidget());
      setState(() {
        print("list.length: ${list.length}");
      });
    } catch (e) {
      print("Error fetching content data: $e");
    }
  }

  void deleteImage(ContentItemModel item) {

    DocumentReference documentRef =
        FirebaseFirestore.instance.collection('contentItem').doc(item.id);

    // Delete the document
    documentRef.delete().then((value) {
      // widget.function();
    }).catchError((error) => print('Failed to delete document: $error'));
  }






}
