import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/res/styles.dart';
import 'package:formula_user/screens/subscription_purchase_screen.dart';
import 'package:formula_user/screens/search_bar_screen.dart';
import 'package:formula_user/screens/tab_contents.dart';
import 'package:formula_user/subscription_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../models/tab_model.dart';
import '../res/colours.dart';
import '../utilities.dart';
import 'auth/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String testDevice = 'YOUR_DEVICE_ID';
  int maxFailedLoadAttempts = 3;
  final db = FirebaseFirestore.instance;
  List<TabModel> list = [];

  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData(); // Start fetching data
    if (Common.isAdEnable) {
      MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: [testDevice]));
    }
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    CollectionReference formulatab =
        FirebaseFirestore.instance.collection('formulatab');
    final prefs = await SharedPreferences.getInstance();
    const cacheKey = 'formulatab_cache';

    try {
      // Fetch cached data
      String? cachedData = prefs.getString(cacheKey);

      if (cachedData != null) {
        // Load data from cache
        List<dynamic> jsonData = json.decode(cachedData);
        list = jsonData.map((item) => TabModel.fromJson(item)).toList();
        // Initialize TabController with cached data
        _tabController = TabController(length: list.length, vsync: this);
      }

      // Fetch data from Firestore
      QuerySnapshot querySnapshot =
          await formulatab.get(const GetOptions(source: Source.serverAndCache));

      if (querySnapshot.docs.isNotEmpty) {
        List<TabModel> newList = querySnapshot.docs
            .map((doc) => TabModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        newList.sort((a, b) => a.index.compareTo(b.index));

        // Check if new data is different from cached data
        String newJsonData =
            json.encode(newList.map((item) => item.toJson()).toList());
        if (newJsonData != cachedData) {
          // Update list with new data
          list = newList;

          // Initialize TabController with new data
          _tabController = TabController(length: list.length, vsync: this);

          // Save fetched data to cache
          await prefs.setString(cacheKey, newJsonData);
        }
      } else {
        list.add(TabModel("No Tab", "0", 0));
      }

      // Sort the list
      list.sort((a, b) => a.index.compareTo(b.index));
      // Update the UI with cached data
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose the TabController when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 30,
        title: ChangeNotifierProvider(
          create: (_) => SubscriptionManager(),
          child: Padding(
            padding: const EdgeInsets.only(right: 6.0, top: 6.0),
            child: Text(
                "Mathematics ${Provider.of<SubscriptionManager>(context).isPrimeMember(context) ? "Prime" : ""}",
                style: Styles.textWith18withBold(Colours.white)),
          ),
        ),
        backgroundColor: Colours.buttonColor2,
        actions: [
          Common.isAdEnable
              ? IconButton(
                  icon: Image.asset(
                    'assets/prime.png',
                    color: Colors.white,
                  ),
                  onPressed: () {
                    pushToNewRoute(context, const SubscriptionPurchaseScreen());
                  },
                )
              : Container(),
          Common.isLogin
              ? IconButton(
                  icon: Icon(Icons.logout, color: Colours.white),
                  onPressed: () {
                    _signOut();
                  },
                )
              : Container(),
        ],
      ),
      body: DefaultTabController(
          length: list.length,
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverAppBar(
                        backgroundColor: Colours.buttonColor2,
                        floating: true,
                        pinned: true,
                        snap: true,
                        toolbarHeight: 50,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 6.0, right: 6.0),
                          child: InkWell(
                            onTap: () {
                              pushToNewRoute(context, SearchBarScreen());
                            },
                            child: Container(
                              height: 38,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      color: Colors.black26,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "Search here",
                                      style: Styles.textWith14withBold(
                                          Colours.greyLight700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.square(50),
                          child: Material(
                            color: Colours.listBackground,
                            child: TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                labelStyle: Styles.textWith14withBold(
                                    Colours.buttonColor2),
                                indicatorColor: Colors.pinkAccent,
                                indicatorPadding:
                                    const EdgeInsets.only(left: 20.0),
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: MaterialIndicator(
                                  color: Colors.pinkAccent,
                                  height: 3,
                                  bottomLeftRadius: 5,
                                  bottomRightRadius: 5,
                                ),
                                labelPadding: const EdgeInsets.only(
                                    right: 10.0, left: 10.0),
                                tabs: List.generate(
                                    list.length,
                                    (index) => Row(
                                          children: [
                                            Container(
                                              height: 30,
                                              width: 1.5,
                                              decoration: BoxDecoration(
                                                  color: Colours.greyLight),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Tab(
                                              text: list[index].name,
                                            ),
                                          ],
                                        ))),
                          ),
                        ),
                      )
                    ];
                  },
                  body: list.isEmpty
                      ? Container()
                      : DefaultTabController(
                          length: list.length, // length of tabs
                          initialIndex: 0,
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : TabBarView(
                                  controller: _tabController,
                                  children: List.generate(
                                      list.length,
                                      (index) => TabContents(list[index], () {
                                            pushToNewRouteAndClearAll(
                                                context, const HomePage());
                                          })),
                                ),
                        ))),
    );
  }

  Future<void> _signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Common.isLogin = false;
      prefs.setBool("isLoggedIn", false);

      pushToNewRouteAndClearAll(context, const LoginPage());
    }
  }
}
