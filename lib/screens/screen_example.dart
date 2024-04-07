import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';


class ScreenExample extends StatefulWidget {
  const ScreenExample({super.key});

  @override
  State<ScreenExample> createState() => _ScreenExampleState();
}

class _ScreenExampleState extends State<ScreenExample> {
  late dynamic _purchaseUpdatedSubscription;
  late dynamic _purchaseErrorSubscription;
  late dynamic _connectionSubscription;
  final List<String> _productLists = Platform.isAndroid
      ? [
    'one_month_49_ad_free',
    '6_month_subscription',
    'year_subscriptions',
    'android.test.canceled',
  ]
      : ['com.cooni.point1000', 'com.cooni.point5000'];

  List<IAPItem> _items = [];
  List<PurchasedItem> _purchases = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
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
    print('result: $result');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // refresh items for android
    try {
      String msg = await FlutterInappPurchase.instance.consumeAll();
      print('consumeAllItems: $msg');
    } catch (err) {
      print('consumeAllItems error: $err');
    }

    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
          print('connected: $connected');
        });

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
          print('purchase-updated: $productItem');
        });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
          print('purchase-error: $purchaseError');
        });
  }

  void _requestPurchase(IAPItem item) {
    FlutterInappPurchase.instance.requestSubscription(item.productId!);
  }

  Future _getProduct() async {

    if(Platform.isAndroid){
      List<IAPItem> items =
      await FlutterInappPurchase.instance.getSubscriptions(_productLists);
      for (var item in items) {
        print('${item.title}');
        _items.add(item);
      }

      setState(() {
        _items = items;
        _purchases = [];
      });
    }else{
      List<IAPItem> items =
      await FlutterInappPurchase.instance.getProducts(_productLists);
      for (var item in items) {
        print('${item.title}');
        _items.add(item);
      }

      setState(() {
        _items = items;
        _purchases = [];
      });
    }



  }

  Future _getPurchases() async {
    List<PurchasedItem>? items =
    await FlutterInappPurchase.instance.getAvailablePurchases();
    for (var item in items!) {
      print('${item.toString()}');
      _purchases.add(item);
    }

    setState(() {
      _items = [];
      _purchases = items;
    });
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
    await FlutterInappPurchase.instance.getPurchaseHistory();
    for (var item in items!) {
      print('${item.toString()}');
      _purchases.add(item);
    }

    setState(() {
      _items = [];
      _purchases = items;
    });
  }

  List<Widget> _renderInApps() {
    List<Widget> widgets = _items
        .map((item) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                '${item.title ?? ''} - Rs.${item.price ?? ''}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            MaterialButton(
              color: Colors.orange,
              onPressed: () {
                print("---------- Buy Item Button Pressed");
                _requestPurchase(item);
              },
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 48.0,
                      alignment: Alignment(-1.0, 0.0),
                      child: Text('Buy Item'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ))
        .toList();
    return widgets;
  }

  List<Widget> _renderPurchases() {
    List<Widget> widgets = _purchases
        .map((item) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                '${item.productId ?? ''} - Purchased ${(item.purchaseStateAndroid == PurchaseState.purchased ? "true" : "false") ?? ''}',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    ))
        .toList();
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double buttonWidth = (screenWidth / 3) - 20;

    return Scaffold(
      appBar: AppBar(
        title: Text("Example App"),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Running on: ${Platform.operatingSystem} - ${Platform.operatingSystemVersion}\n',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: buttonWidth,
                          height: 60.0,
                          margin: EdgeInsets.all(7.0),
                          child: MaterialButton(
                            color: Colors.amber,
                            padding: EdgeInsets.all(0.0),
                            onPressed: () async {
                              print("---------- Connect Billing Button Pressed");
                              await FlutterInappPurchase.instance.initialize();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              alignment: Alignment(0.0, 0.0),
                              child: Text(
                                'Connect Billing',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: buttonWidth,
                          height: 60.0,
                          margin: EdgeInsets.all(7.0),
                          child: MaterialButton(
                            color: Colors.amber,
                            padding: EdgeInsets.all(0.0),
                            onPressed: () async {
                              print("---------- End Connection Button Pressed");
                              await FlutterInappPurchase.instance.finalize();
                              if (_purchaseUpdatedSubscription != null) {
                                _purchaseUpdatedSubscription.cancel();
                                _purchaseUpdatedSubscription = null;
                              }
                              if (_purchaseErrorSubscription != null) {
                                _purchaseErrorSubscription.cancel();
                                _purchaseErrorSubscription = null;
                              }
                              setState(() {
                                _items = [];
                                _purchases = [];
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              alignment: Alignment(0.0, 0.0),
                              child: Text(
                                'End Connection',
                                style: TextStyle(
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                              width: buttonWidth,
                              height: 60.0,
                              margin: EdgeInsets.all(7.0),
                              child: MaterialButton(
                                color: Colors.green,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  print("---------- Get Items Button Pressed");
                                  _getProduct();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  alignment: Alignment(0.0, 0.0),
                                  child: Text(
                                    'Get Items',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              width: buttonWidth,
                              height: 60.0,
                              margin: EdgeInsets.all(7.0),
                              child: MaterialButton(
                                color: Colors.green,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  print(
                                      "---------- Get Purchases Button Pressed");
                                  _getPurchases();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  alignment: Alignment(0.0, 0.0),
                                  child: Text(
                                    'Get Purchases',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              )),
                          Container(
                              width: buttonWidth,
                              height: 60.0,
                              margin: EdgeInsets.all(7.0),
                              child: MaterialButton(
                                color: Colors.green,
                                padding: EdgeInsets.all(0.0),
                                onPressed: () {
                                  print(
                                      "---------- Get Purchase History Button Pressed");
                                  _getPurchaseHistory();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  alignment: Alignment(0.0, 0.0),
                                  child: Text(
                                    'Get Purchase History',
                                    style: TextStyle(
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              )),
                        ]),
                  ],
                ),
                Column(
                  children: _renderInApps(),
                ),
                Column(
                  children: _renderPurchases(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
