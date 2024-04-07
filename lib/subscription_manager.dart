import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:formula_user/res/colours.dart';
import 'package:formula_user/res/styles.dart';
import 'package:provider/provider.dart';

import 'models/subscription_list_model.dart';
import 'models/subscription_model.dart';

class SubscriptionManager extends ChangeNotifier {
  bool _isPrime = false;
  bool _isLoading = false;
  List<SubscriptionListModel> subscriptionsUIList = [];
  bool get isPrime => _isPrime;
  bool get isLoading => _isLoading;

  Future<void> initializeInAppPurchasesForPrimeCheck() async {
    try {
      final result = await FlutterInappPurchase.instance.initialize();
      if (result == "Billing client ready" ||
          result ==
              "Already started. Call endConnection method if you want to start over.") {
        if (kDebugMode) {
          print('In-app purchase initialization successful');
        }
        await _getPurchasesItems();
      } else {
        if (kDebugMode) {
          print('In-app purchase initialization failed: $result');
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error initializing in-app purchases: $error');
      }
    }
  }

  Future<void> _getPurchasesItems() async {
    try {
      final List<PurchasedItem>? items =
          await FlutterInappPurchase.instance.getAvailablePurchases();
      if (items != null) {
        _updateSubscriptionStatus(items);
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error retrieving purchases: $error');
      }
    }
  }

  Future _getUsersPurchasedItemFromStore() async {
    List<PurchasedItem>? usersPurchasedItemList =
        await FlutterInappPurchase.instance.getAvailablePurchases();

    for (var purchasedItem in usersPurchasedItemList ?? []) {
      for (var uiItem in subscriptionsUIList) {
        if (purchasedItem.productId == uiItem.subscriptionsId) {
          //setting purchase status
          if (Platform.isAndroid) {
            uiItem.isPurchased =
                purchasedItem.purchaseStateAndroid == PurchaseState.purchased;
          } else {
            uiItem.isPurchased = true;
          }
        }
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isPrimeMember(BuildContext context) {
    return Provider.of<SubscriptionManager>(context).isPrime;
  }

  setPrimeManual(bool isPrime) {
    _isPrime = isPrime;
    notifyListeners();
  }

  void _updateSubscriptionStatus(List<PurchasedItem> items) {
    for (var item in items) {
      if (item.purchaseStateAndroid == PurchaseState.purchased) {
        _isPrime = true;
        notifyListeners();
        break;
      }
    }
  }

  ///purchase code for subscription

  Future<void> fetchAllSubscriptionsFromFirebase(BuildContext context) async {
    final List<String> subscriptionIdFirebaseList = [];
    _isLoading = true;
    subscriptionsUIList = [];
    CollectionReference subscriptionRef =
        FirebaseFirestore.instance.collection('subscriptions');

    try {
      QuerySnapshot querySnapshot = await subscriptionRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          final subscriptions =
              SubscriptionModel.fromMap(doc.data() as Map<String, dynamic>);
          if (Platform.isAndroid) {
            subscriptionIdFirebaseList
                .add(subscriptions.subscriptionsIdAndroid);

            subscriptionsUIList.add(SubscriptionListModel(
                subscriptionsId: subscriptions.subscriptionsIdAndroid,
                title: "",
                description: "",
                price: "",
                isPurchased: false));
          } else {
            subscriptionIdFirebaseList.add(subscriptions.subscriptionsIdIos);

            subscriptionsUIList.add(SubscriptionListModel(
                subscriptionsId: subscriptions.subscriptionsIdIos,
                title: "",
                description: "",
                price: "",
                isPurchased: false));
          }
        }

        initializeForPurchased(subscriptionIdFirebaseList,context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> initializeForPurchased(
      List<String> subscriptionIdFirebaseList, BuildContext context) async {
    var result = await FlutterInappPurchase.instance.initialize();
    if (kDebugMode) {
      print('result: $result');
    }

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

    FlutterInappPurchase.connectionUpdated.listen((connected) {
      print('connected: $connected');
    });

    FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      print('purchase-updated: $productItem');
      SubscriptionListModel purchasedItem =  subscriptionsUIList.firstWhere((element) => element.subscriptionsId == productItem?.productId);
      showPopupMessage(context, true, "${purchasedItem.title} is purchased successfully");
      fetchAllSubscriptionsFromFirebase(context);
      setPrimeManual(true);
    });

    FlutterInappPurchase.purchaseError.listen((purchaseError) {
      print('purchase-error: $purchaseError');
      showPopupMessage(context, false, purchaseError?.message ?? '');
    });

    _getAvailableProductsInStore(subscriptionIdFirebaseList);
  }

  Future _getAvailableProductsInStore(
      List<String> subscriptionIdFirebaseList) async {
    List<IAPItem> availableSubscriptionsListFromStore = [];
    if (Platform.isAndroid) {
      availableSubscriptionsListFromStore = await FlutterInappPurchase.instance
          .getSubscriptions(subscriptionIdFirebaseList);
    } else {
      availableSubscriptionsListFromStore = await FlutterInappPurchase.instance
          .getProducts(subscriptionIdFirebaseList);
    }

    for (var element in availableSubscriptionsListFromStore) {
      for (var elementInSide in subscriptionsUIList) {
        if (element.productId == elementInSide.subscriptionsId) {
          elementInSide.price = element.price ?? '';
          elementInSide.title = element.title ?? '';
          elementInSide.description = element.description ?? '';
        }
      }
    }
    _getUsersPurchasedItemFromStore();
  }

  void _requestPurchase(String productId) {
    FlutterInappPurchase.instance.requestSubscription(productId);
  }

  purchaseRequest(SubscriptionListModel item) {
    _requestPurchase(item.subscriptionsId);
  }

  Future _getPurchaseHistory() async {
    List<PurchasedItem>? items =
        await FlutterInappPurchase.instance.getPurchaseHistory();
    //_purchasedItems = items ?? [];
  }

  void showPopupMessage(BuildContext context,bool isPositive,String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isPositive ? 'Yeh 😃' : 'Oops 😢',
            style: Styles.textWith18withBold(Colours.black),
          ),
          content: Text(
            message,
            style: Styles.textWith18withBold500(Colours.black),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
