import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';
import '../models/subscription_list_model.dart';
import '../models/subscription_model.dart';
import '../res/colours.dart';
import '../res/styles.dart';

class SubscriptionPurchaseScreen extends StatefulWidget {
  const SubscriptionPurchaseScreen({super.key});

  @override
  State<SubscriptionPurchaseScreen> createState() => _SubscriptionPurchaseScreenState();
}

class _SubscriptionPurchaseScreenState extends State<SubscriptionPurchaseScreen> {
  bool _isLoading = false;
  List<SubscriptionListModel> subscriptionsPurchasedList = [];

  List<PurchasedItem> _purchasedItems = [];
  final List<IAPItem> _itemsForPurchase = [];
  late dynamic _connectionSubscription;

  final List<String> _productLists = [];



  @override
  void initState() {
    super.initState();
    fetchAllSubscriptions();
  }

  @override
  void dispose() {
    if (_connectionSubscription != null) {
      _connectionSubscription.cancel();
      _connectionSubscription = null;
    }
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // prepare
    var result = await FlutterInappPurchase.instance.initialize();
    if (kDebugMode) {
      print('result: $result');
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      if (kDebugMode) {
        print('consumeAllItems: $msg');
      }
    } catch (err) {
      if (kDebugMode) {
        print('consumeAllItems error: $err');
      }
    }

    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      if (kDebugMode) {
        print('connected: $connected');
      }
    });


    _getPurchases();
    _getProduct();

  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestSubscription(item.productId!);
  }

  Future _getProduct() async {
    if (Platform.isAndroid) {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getSubscriptions(_productLists);
      for (var item in items) {
        if (kDebugMode) {
          print('${item.title}');
        }
        _itemsForPurchase.add(item);
      }
    } else {
      List<IAPItem> items =
          await FlutterInappPurchase.instance.getProducts(_productLists);
      for (var item in items) {
        if (kDebugMode) {
          print('${item.title}');
        }
        _itemsForPurchase.add(item);
      }
    }

    _itemsForPurchase.forEach((element) {

      subscriptionsPurchasedList.forEach((elementInSide) {

        if(element.productId == elementInSide.subscriptionsId){
          elementInSide.price = element.price ?? '';
          elementInSide.title = element.title ?? '';
          elementInSide.description = element.description ?? '';
          elementInSide.subscriptionsId = element.productId ?? '';
        }

      });

    });

    setState(() {

    });

  }

  Future _getPurchases() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      if (kDebugMode) {
        print(item.toString());
      }
      _purchasedItems.add(item);
    }

    _purchasedItems.forEach((element) {

      subscriptionsPurchasedList.forEach((elementInSide) {

        if(element.productId == elementInSide.subscriptionsId){

          //setting item id
          elementInSide.subscriptionsId = element.productId ?? '';

          //setting purchase status
          if(Platform.isAndroid){
            elementInSide.isPurchased = element.purchaseStateAndroid == PurchaseState.purchased;
          }else{
            elementInSide.isPurchased = true;
          }


        }else{

        }

      });

    });

  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      if (kDebugMode) {
        print(item.toString());
      }
      _purchasedItems.add(item);
    }

    setState(() {
      _purchasedItems = items;
    });
  }

  List<Widget> _renderInApps() {
    List<Widget> widgets = subscriptionsPurchasedList
        .map((item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '${item.title ?? ''} - Rs. ${item.price ?? ''}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  MaterialButton(
                    color: Colors.orange,
                    onPressed: item.isPurchased ? null : () {

                      _itemsForPurchase.forEach((element) {
                        if(element.productId == item.subscriptionsId){
                          _requestPurchase(element);
                        }
                      });

                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 48.0,
                            alignment: const Alignment(-1.0, 0.0),
                            child: Text(item.isPurchased ? 'Purchased' : 'Buy Item'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))
        .toList();
    return widgets;
  }

  List<Widget> _renderPurchases() {
    List<Widget> widgets = _purchasedItems
        .map((item) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      '${item.productId ?? ''} - Purchased ${(item.purchaseStateAndroid == PurchaseState.purchased ? "true" : "false")}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ))
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text("Subscriptions",
            style: Styles.textWith18withBold(Colours.white)),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(color: Colours.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: _renderInApps(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> fetchAllSubscriptions() async {
    setState(() {
      _isLoading = true;
    });
    subscriptionsPurchasedList = [];
    CollectionReference subscriptionRef =
        FirebaseFirestore.instance.collection('subscriptions');

    try {
      QuerySnapshot querySnapshot = await subscriptionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final subscriptions =
              SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>);
          if (Platform.isAndroid) {
            _productLists.add(subscriptions.subscriptionsIdAndroid);
            subscriptionsPurchasedList.add(SubscriptionListModel(
                subscriptionsId: subscriptions.subscriptionsIdAndroid,
                title: "",
                description: "",
                price: "",
                isPurchased: false));
          } else {
            _productLists.add(subscriptions.subscriptionsIdIos);
            subscriptionsPurchasedList.add(SubscriptionListModel(
                subscriptionsId: subscriptions.subscriptionsIdIos,
                title: "",
                description: "",
                price: "",
                isPurchased: false));
          }
        }
        setState(() {
          _isLoading = false;
        });
        initPlatformState();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }


  void _showPopupMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Yeh 😃',
            style: Styles.textWith18withBold(Colours.black),
          ),
          content: Text(
            'You are now prime member enjoy study',
            style: Styles.textWith18withBold500(Colours.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()));
              },
              child: Text(
                'Close',
                style: Styles.textWith18withBold(Colours.buttonColor1),
              ),
            ),
          ],
        );
      },
    );
  }

}
