import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formula_user/res/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../models/user_model.dart';
import '../../res/colours.dart';
import '../../utilities.dart';
import '../bottom_navigation.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child:  Column(
          children: [
            Lottie.asset("assets/animation1.json"),
            const Spacer(),
            Text("Please select option to SignUp",style: Styles.textWith18withBold500(Colours.black)),
            const SizedBox(
              height: 20,
            ),
          _isLoading?Center(child: CircularProgressIndicator(color: Colours.buttonColor1,)):  ElevatedButton.icon(onPressed: (){
              _signInWithGoogle();
            },
                style: ElevatedButton.styleFrom(
                  primary: Colours.buttonColor1,
                  onPrimary: Colors.black,
                  minimumSize: const Size(300,40),
                ),
                icon: const FaIcon(FontAwesomeIcons.google,color: Colors.white,),
                label:  Text('Sign up with Google',style: Styles.textWith16bold(Colours.white),)),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(onPressed: (){
              //SignInWithGoogle();
            },
                style: ElevatedButton.styleFrom(
                  primary: Colours.buttonColor2,
                  onPrimary: Colors.black,
                  minimumSize: const Size(300,40),
                ),
                icon: const FaIcon(FontAwesomeIcons.apple,color: Colors.white,),
                label:  Text('Sign up with Apple',style: Styles.textWith16bold(Colours.white),)),
            const Spacer()
          ],
        ),
      ),
    );
  }


  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    // Show loading
    GoogleSignInAccount? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    const List<String> scopes = <String>['email'];

    GoogleSignIn googleSignIn =
    GoogleSignIn(scopes: scopes, signInOption: SignInOption.standard);
    currentUser = await googleSignIn.signIn();
    if (currentUser == null) {
      // ignore: use_build_context_synchronously
      return showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            title: const Text('Alert!'),
            content: const Text('Somthing went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the AlertDialog
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    final authentication = await currentUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken);
    final userCredentials = await firebaseAuth.signInWithCredential(credential);
    final profile = userCredentials.additionalUserInfo!.profile;
    String? givenName = profile?['given_name'];
    String? locale = profile?['locale'];
    String? familyName = profile?['family_name'];
    String? picture = profile?['picture'];
    String? id = profile?['id'];
    String? name = profile?['name'];
    String? email = profile?['email'];
    bool? verifiedEmail = profile?['verified_email'];
    // String? grantedScopes = profile?['granted_scopes'];
    if(!await userExists(UserModel(
        id: userCredentials.user?.uid ?? "",
        name: name ?? "",
        email: email ?? "",
        isPrimeMember: false))){
      addUserToFirebase(
          UserModel(
              id: userCredentials.user?.uid ?? "",
              name: name ?? "",
              email: email ?? "",
              isPrimeMember: false)

      );
    }

    setState(() {
      _isLoading = false;
    });
    storeToSharedPreference(true);
    if(context.mounted){
      pushToNewRouteAndClearAll(context,  MyBottomNavigation());
    }
  }

  Future<void> addUserToFirebase(UserModel user) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      await users.doc(user.id).set(user.toMap());
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<bool> userExists(UserModel user) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot doc = await users.doc(user.id).get();
      return doc.exists;
    } catch (e) {
      print('Error checking user existence: $e');
      return false;
    }
  }
}
