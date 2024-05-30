import 'package:flutter/material.dart';
import 'package:formula_user/res/styles.dart';

import '../res/colours.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colours.buttonColor2,
        toolbarHeight: 30,
        title: Text('About',style: Styles.textWith20withBold500(Colours.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mathematics Formula App',
                style: Styles.textWith24withBold(Colours.black)
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: Styles.textWith18withBold(Colours.black)
              ),
              Text(
                'Your app description goes here. Explain what your app does and how it can help users with mathematical formulas.',
                style: Styles.textWith16(Colours.black),
              ),
              SizedBox(height: 16),
              Text(
                'Features:',
                style: Styles.textWith18withBold(Colours.black)
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '1. ',
                      style: Styles.textWith16bold(Colors.black)
                    ),
                    TextSpan(
                      text: 'Bookmarking: ',
                      style: Styles.textWith16bold(Colors.blue)
                    ),
                    TextSpan(
                      text: 'Users can bookmark their favorite formulas for quick access later.',
                      style: Styles.textWith16(Colours.black)
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: '2. ',
                        style: Styles.textWith16bold(Colors.black)
                    ),
                    TextSpan(
                        text: 'Formula Search:',
                        style: Styles.textWith16bold(Colors.blue)
                    ),
                    TextSpan(
                        text: 'Users can search for specific formulas by keywords or categories, making it easy to find what they need.',
                        style: Styles.textWith16(Colours.black)
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: '3. ',
                        style: Styles.textWith16bold(Colors.black)
                    ),
                    TextSpan(
                        text: 'Ad-Free Subscription:',
                        style: Styles.textWith16bold(Colors.blue)
                    ),
                    TextSpan(
                        text: 'Users have the option to subscribe to a premium version of the app to remove ads and enjoy an uninterrupted experience.',
                        style: Styles.textWith16(Colours.black)
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: '4. ',
                        style: Styles.textWith16bold(Colors.black)
                    ),
                    TextSpan(
                        text: 'Formula Sharing:',
                        style: Styles.textWith16bold(Colors.blue)
                    ),
                    TextSpan(
                        text: 'Users can share formulas with friends or colleagues via various platforms such as email, messaging apps, or social media.',
                        style: Styles.textWith16(Colours.black)
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
             /* RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: 'Contact: ',
                        style: Styles.textWith16bold(Colors.black)
                    ),

                    TextSpan(
                        text: 'thelightspeedofficial@gmail.com',
                        style: Styles.textWithUnderLine(Colors.blue)
                    ),
                  ],
                ),
              ),*/

              SizedBox(height: 16),
              Text(
                'Version: 1.0.2',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
