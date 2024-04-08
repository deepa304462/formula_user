import 'package:flutter/material.dart';
import 'package:formula_user/models/subscription_list_model.dart';

import '../res/colours.dart';
import '../res/styles.dart';

class BuyFinalPlanScreen extends StatefulWidget {
  SubscriptionListModel subscriptionsUIList;
  BuyFinalPlanScreen({required this.subscriptionsUIList, super.key});

  @override
  State<BuyFinalPlanScreen> createState() => _BuyFinalPlanScreenState();
}

class _BuyFinalPlanScreenState extends State<BuyFinalPlanScreen> {
  bool _isChecked = false;
  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.7,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colours.planBackgroundColour),
            child: Column(
              children: [
                Image.asset(
                  "assets/calender_icon.png",
                  height: 100,
                  width: 100,
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text("${widget.subscriptionsUIList.title}",style: Styles.textWith20withBold(Colours.buttonColor1),textAlign: TextAlign.center,)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "₹${widget.subscriptionsUIList.price}0",
                      style: Styles.textWith20withBold500(Colours.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 24),
                      child: Text(
                        "/1 months",
                        style: Styles.textWith12(Colours.white),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colours.buttonColor1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Premium Study Material",
                        style: Styles.textWith12(Colours.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colours.buttonColor1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Read Offline",
                        style: Styles.textWith12(Colours.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colours.buttonColor1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Ad free",
                        style: Styles.textWith12(Colours.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colours.buttonColor1),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Plan activate instantly",
                        style: Styles.textWith12(Colours.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Proceed to paymant gateway",
              style: Styles.textWith16bold(Colours.greyLight700),
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isChecked = !_isChecked;
                    });
                  },
                  child: Text(
                    'Accept terms & conditions',
                    style: Styles.textWithUnderLine(Colors.blue)
                  ),
                ),
              ),
              TextButton(
                onPressed: (){},
                child: Text(
                  "Read",
                  style: Styles.textWith16(Colours.greyLight700),
                ),
                
              ),
            ],
          ),
          Spacer(),
          Center(
            child: ElevatedButton(
                style: ButtonStyle(
                    fixedSize:
                    const MaterialStatePropertyAll(Size(200, 40)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    backgroundColor:
                    MaterialStatePropertyAll(Colours.buttonColor1)),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>BuyFinalPlanScreen(subscriptionsUIList:subscriptionManager.subscriptionsUIList[index])));
                },
                child: Text(
                  "Buy",
                  style: Styles.textWith18withBold(Colours.white),
                )),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
