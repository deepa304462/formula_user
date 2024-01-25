import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formula_user/res/styles.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../res/colours.dart';
import '../../utilities.dart';
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


  void SignInWithGoogle()async {
    GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
      '//www.googleapis.com/auth/drive',
    ],).signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken:googleAuth?.idToken,
    );

   UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
   print(userCredential.user?.displayName);
   if(context.mounted){
     pushToNewRouteAndClearAll(context, const HomePage());
   }

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
      return showDialog(
        context: context,
        builder:(context) {
          return AlertDialog(
            title: Text('Alert!'),
            content: Text('Somthing went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  // Close the AlertDialog
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
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
    Map<String, dynamic> body = {
      'id': id,
      'email': email,
      'verified_email': verifiedEmail,
      'name': name,
      'given_name': givenName,
      'family_name': familyName,
      'picture': picture,
      'locale': locale
    };
    setState(() {
      _isLoading = false;
    });
   // LOGIN SUCCES
  }
}
