import 'package:flutter/material.dart';
import 'package:formula_user/screens/buy_final_plan_screen.dart';
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
              : SizedBox(
            height: 800,
            child: PageView.builder(
              itemCount: subscriptionManager.subscriptionsUIList.length,
              itemBuilder: (context, index) {
                var item = subscriptionManager.subscriptionsUIList[index];
                return  Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            child: Container(
                              height: 425,
                              width: 400,
                              decoration: BoxDecoration(
                                  color: Colours.planBackgroundColour,
                                  borderRadius: BorderRadius.circular(12)
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Image.asset("assets/calender_icon.png",height: 100,width: 100,),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                      child: Text("${item.title}",style: Styles.textWith20withBold(Colours.buttonColor1),textAlign: TextAlign.center,)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("₹${item.price}0",style: Styles.textWith20withBold500(Colours.white),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8,top: 24),
                                        child: Text("/1 months",style: Styles.textWith12(Colours.white),),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12,left: 30),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colours.buttonColor1
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text("Premium Study Material",style: Styles.textWith12(Colours.white),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,left: 30),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colours.buttonColor1
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text("Read Offline",style: Styles.textWith12(Colours.white),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,left: 30),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colours.buttonColor1
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text("Ad free",style: Styles.textWith12(Colours.white),),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4,left: 30),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(12),
                                              color: Colours.buttonColor1
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text("Plan activate instantly",style: Styles.textWith12(Colours.white),),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          fixedSize: const MaterialStatePropertyAll(
                                              Size(
                                                  175,45
                                              )
                                          ),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12)
                                              )
                                          ),
                                          backgroundColor: MaterialStatePropertyAll(
                                              Colours.buttonColor1
                                          )
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (_)=>BuyFinalPlanScreen(subscriptionsUIList:subscriptionManager.subscriptionsUIList[index])));
                                      },
                                      child: Text("Buy",style: Styles.textWith18withBold(Colours.white),))
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3, // Number of dots (change according to the number of slides)
                                  (indexDot) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: indexDot == index ? Colours.buttonColor1 : Colours.buttonColor2, // Active dot color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
