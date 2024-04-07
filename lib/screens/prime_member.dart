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
        body: Common.isPrime
            ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Yooo!!! you already a prime member \nenjoy the formulas with solution 😃",
                  style: Styles.textWith18withBold(Colours.greyLight700),
                  maxLines: 40,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colours.buttonColor2
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                            Size(
                                300,
                                40
                            )
                        )
                    ),
                    onPressed: (){},
                    child: Text("Monthly @49 Rs.",style: Styles.textWith18withBold(Colours.white),)
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colours.buttonColor1
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                            Size(
                                300,
                                40
                            )
                        )
                    ),
                    onPressed: (){},
                    child: Text("Six Month @249 Rs.",style: Styles.textWith18withBold(Colours.white),)
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Colours.buttonColor2
                        ),
                        fixedSize: const MaterialStatePropertyAll(
                            Size(
                                300,
                                40
                            )
                        )
                    ),
                    onPressed: (){},
                    child: Text("Yearly @549 Rs.",style: Styles.textWith18withBold(Colours.white),)
                ),
              ],
            ))
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Click here to become prime member !!!",
                style: Styles.textWith18withBold500(Colours.black),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    //SignInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colours.buttonColor2,
                    onPrimary: Colors.black,
                    minimumSize: const Size(300, 40),
                  ),
                  icon: Image.asset(
                    "assets/prime.png",
                    color: Colors.white,
                    height: 24,
                    width: 24,
                  ),
                  label: Text(
                    Common.isLogin
                        ? 'Take Subscription'
                        : "Login to take Subscription",
                    style: Styles.textWith16bold(Colours.white),
                  )),
            ],
          ),
        ));
  }

  updateSubscription() async {
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
                /*Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const SplashScreen()));*/
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