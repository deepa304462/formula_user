import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formula_user/models/user_model.dart';

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
        title: Text("Subscriptions", style: Styles.textWith18withBold(Colours.white)),
    backgroundColor: Colours.appbar,
           iconTheme: IconThemeData(
             color: Colours.white
           ),
    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Click here to become prime member !!!",
              style: Styles.textWith18withBold500(Colours.black),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(onPressed: (){
              //SignInWithGoogle();
            },
                style: ElevatedButton.styleFrom(
                  primary: Colours.buttonColor2,
                  onPrimary: Colors.black,
                  minimumSize: const Size(300,40),
                ),
                icon:  Image.asset("assets/prime.png",color: Colors.white,height: 24,width: 24,),
                label:  Text('Take Subscription',style: Styles.textWith16bold(Colours.white),)),
          ],
        ),

      ),
    );

  }

  updateSubscription(String userId, bool isPrimeMember ) async {

    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(userId).update({'isPrimeMember': isPrimeMember});

      print('User email updated successfully');
    } catch (e) {
      print('Error updating user email: $e');
    }
  }

}
