import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formula_user/main.dart';
import 'package:formula_user/models/user_model.dart';
import 'package:formula_user/res/common.dart';
import 'package:formula_user/screens/auth/login_page.dart';
import 'package:formula_user/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/colours.dart';
import '../res/styles.dart';

class BecomePrimeMember extends StatefulWidget {
  const BecomePrimeMember({super.key});

  @override
  State<BecomePrimeMember> createState() => _BecomePrimeMemberState();
}

class _BecomePrimeMemberState extends State<BecomePrimeMember> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 200,top: 24),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colours.planBackgroundColour,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset("assets/calender_icon.png",height: 100,width: 100,),
                          const SizedBox(
                            height: 12,
                          ),
                          Text("1 Month Plan",style: Styles.textWith20withBold(Colours.buttonColor1),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("₹49 Month Plan",style: Styles.textWith20withBold500(Colours.white),),
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
                              onPressed: (){},
                              child: Text("Buy",style: Styles.textWith18withBold(Colours.white),))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 200,top: 24),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colours.planBackgroundColour,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset("assets/calender_icon.png",height: 100,width: 100,),
                          const SizedBox(
                            height: 12,
                          ),
                          Text("6 Month Plan",style: Styles.textWith20withBold(Colours.buttonColor1),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("₹199 Month Plan",style: Styles.textWith20withBold500(Colours.white),),
                              Padding(
                                padding: const EdgeInsets.only(left: 8,top: 24),
                                child: Text("/6 months",style: Styles.textWith12(Colours.white),),
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
                              onPressed: (){},
                              child: Text("Buy",style: Styles.textWith18withBold(Colours.white),))
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 200,top: 24),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colours.planBackgroundColour,
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Image.asset("assets/calender_icon.png",height: 100,width: 100,),
                          const SizedBox(
                            height: 12,
                          ),
                          Text("1 Year Plan",style: Styles.textWith20withBold(Colours.buttonColor1),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("₹349 Yearly Plan",style: Styles.textWith20withBold500(Colours.white),),
                              Padding(
                                padding: const EdgeInsets.only(left: 8,top: 24),
                                child: Text("/12 months",style: Styles.textWith12(Colours.white),),
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
                              onPressed: (){},
                              child: Text("Buy",style: Styles.textWith18withBold(Colours.white),))
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 170,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3, // Number of dots (change according to the number of slides)
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index ? Colours.buttonColor1 : Colours.buttonColor2, // Active dot color
                        ),
                      ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: Column(
                children: [
                  Text("You can join 7 days free trial",style: Styles.textWith16(Colours.black),),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          fixedSize: const MaterialStatePropertyAll(
                              Size(
                                  175,35
                              )
                          ),
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)
                              )
                          ),
                          backgroundColor: MaterialStatePropertyAll(
                              Colours.buttonColor1
                          ),
                        side: MaterialStatePropertyAll(
                          BorderSide(
                            color: Colours.buttonColor2,
                            width: 0.5
                          )
                        )
                      ),
                      onPressed: (){},
                      child: Text("Try now",style: Styles.textWith18withBold(Colours.white),))
                ],
              )
            ),
          ],
        ));
  }

 /* updateSubscription() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users
          .doc(prefs.getString('userId'))
          .update({'isPrimeMember': true});
      _showPopupMessage(context);

      print('User email updated successfully');
    } catch (e) {
      print('Error updating user email: $e');
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
                *//*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()));*//*
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
  }*/
}
