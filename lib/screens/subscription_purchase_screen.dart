import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../res/colours.dart';
import '../res/styles.dart';
import '../subscription_manager.dart';

class SubscriptionPurchaseScreen extends StatelessWidget {
  const SubscriptionPurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<SubscriptionManager>(context, listen: false)
        .fetchAllSubscriptionsFromFirebase(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 40,
        title: Text(
          "Subscriptions",
          style: Styles.textWith18withBold(Colours.white),
        ),
        backgroundColor: Colours.buttonColor2,
        iconTheme: IconThemeData(color: Colours.white),
      ),
      body: Consumer<SubscriptionManager>(
        builder: (context, subscriptionManager, _) {
          return subscriptionManager.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: _renderInApps(subscriptionManager),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  List<Widget> _renderInApps(SubscriptionManager subscriptionManager) {
    return subscriptionManager.subscriptionsUIList
        .map(
          (item) => Container(
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
                  onPressed: item.isPurchased
                      ? null
                      : () {
                          subscriptionManager.purchaseRequest(item);
                        },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 48.0,
                          alignment: const Alignment(-1.0, 0.0),
                          child:
                              Text(item.isPurchased ? 'Purchased' : 'Buy Item'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
