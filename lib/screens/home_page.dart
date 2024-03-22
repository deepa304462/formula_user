import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/res/styles.dart';
import 'package:formula_user/screens/prime_member.dart';
import 'package:formula_user/screens/search_bar_screen.dart';
import 'package:formula_user/screens/tab_contents.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: [testDevice]));
  }

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    CollectionReference formulatab =
        FirebaseFirestore.instance.collection('formulatab');
    QuerySnapshot querySnapshot = await formulatab.get();
    if (querySnapshot.docs.isNotEmpty) {
      list = querySnapshot.docs
          .map((doc) => TabModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => a.index.compareTo(b.index));
      _tabController = TabController(length: list.length, vsync: this);
      setState(() {
        _isLoading = false;
      });
    } else {
      list.add(TabModel("No Tab", "0", 0));
      _tabController = TabController(length: list.length, vsync: this);
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
        title: Padding(
          padding: const EdgeInsets.only(right: 6.0,top: 6.0),
          child: Text("Mathematics",
              style: Styles.textWith18withBold(Colours.white)),
        ),
        backgroundColor: Colours.buttonColor2,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/prime.png',
              color: Colors.white,
            ),
            onPressed: () {
              pushToNewRoute(context, const BecomePrimeMember());
            },
          ),
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
                              pushToNewRoute(context, const SearchBarScreen());
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
                                labelColor: Colors.pinkAccent,
                                labelStyle: Styles.textWith14withBold(
                                    Colours.buttonColor2),
                                indicatorColor: Colors.pinkAccent,
                                indicatorSize: TabBarIndicatorSize.label,
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
      Common.isPrime = false;
      prefs.setBool("isLoggedIn", false);

      pushToNewRouteAndClearAll(context, const LoginPage());
    }
  }
}
