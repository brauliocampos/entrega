import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:random_string/random_string.dart';
import 'package:user_web/constant.dart';
import 'package:user_web/Providers/auth.dart';
// import 'package:icons_plus/icons_plus.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKeyLogin = GlobalKey<FormBuilderState>();
  final _emailFieldKeyLogin = GlobalKey<FormBuilderFieldState>();
  bool showPassword = true;
  String email = '';
  String password = '';
  String tokenID = '';
  // getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   setState(() {
  //     tokenID = token!;
  //   });
  // }

  @override
  void initState() {
    // getToken();
    super.initState();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
    // clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  // Check if user exists in Firestore
  Future<bool> _checkIfUserExists(String uid) async {
    final docSnapshot = await _firestore.collection('users').doc(uid).get();
    return docSnapshot.exists;
  }

  // Save new user to Firestore
  Future<void> _saveNewUser(User user) async {
    try {
      // First check if this user already exists
      bool userExists = await _checkIfUserExists(user.uid);

      if (!userExists) {
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'fullname': user.displayName,
          'created': DateFormat.yMMMMEEEEd().format(DateTime.now()).toString(),
          'id': user.uid,
          'phone': '',
          'photoUrl': '',
          'address': '',
          'DeliveryAddress': '',
          'HouseNumber': '',
          'ClosestBustStop': '',
          'DeliveryAddressID': '',
          'CurrentMarketID': '',
          'deliveryFee': 0,
          'wallet': 0,
          'tokenID': '',
          'referralCode': '',
          'awardReferral': false,
          'personalReferralCode': '',
          'Coupon Reward': 0
        });

        FirebaseFirestore.instance.collection('users').doc(user.uid).update(
            {'personalReferralCode': randomAlphaNumeric(8)}).then((value) {
          if (context.mounted) {
            context.go('/parcel-delivery');
          }
        });
        Fluttertoast.showToast(
            msg: "Please update your phone number in your profile".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
      } else {
        Fluttertoast.showToast(
                msg: "Welcome.".tr(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                fontSize: 14.0)
            .then((value) {
          if (context.mounted) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .update({'tokenID': ''});
            context.go('/parcel-delivery');
          }
        });
      }
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Sign in with Google and then Firebase
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get authentication details from Google Sign-In
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Check if this is a new user and save to Firestore
        await _saveNewUser(user);
      }
    } catch (error) {
      print('Error signing in with Google: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKeyLogin,
      child: Column(
        mainAxisAlignment: MediaQuery.of(context).size.width >= 1100
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (MediaQuery.of(context).size.width <= 1100) const Gap(50),
          if (MediaQuery.of(context).size.width <= 1100)
            Image.asset(
              logo,
              scale: 10,
            ),
          const Gap(10),
          Align(
            alignment: MediaQuery.of(context).size.width >= 1100
                ? Alignment.bottomLeft
                : Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width >= 1100 ? 50 : 0),
              child: Text(
                'Sign in to continue.',
                style: TextStyle(
                    color: appColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width >= 1100 ? 20 : 15),
              ).tr(),
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: FormBuilderTextField(
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : null,
              ),
              onChanged: (v) {
                setState(() {
                  email = v!;
                });
              },
              key: _emailFieldKeyLogin,
              name: 'login email',
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null),
                fillColor: const Color.fromARGB(255, 236, 234, 234),
                hintText: 'Email'.tr(),
                //border: OutlineInputBorder()
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.email(),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: FormBuilderTextField(
              style: TextStyle(
                color: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  password = value!;
                });
              },
              name: 'login password',
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.black
                        : null),
                suffixIcon: showPassword == true
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = false;
                          });
                        },
                        child: const Icon(
                          Icons.visibility,
                          color: Colors.grey,
                          size: 30,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            showPassword = true;
                          });
                        },
                        child: const Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                filled: true,
                border: InputBorder.none,
                fillColor: const Color.fromARGB(255, 236, 234, 234),
                hintText: 'Password'.tr(),
                //   border: OutlineInputBorder()
              ),
              obscureText: showPassword,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
          ),
          const Gap(10),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    context.go('/forgot-password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: appColor),
                  ).tr(),
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const BeveledRectangleBorder(),
                  backgroundColor: appColor,
                  textStyle: const TextStyle(color: Colors.white)),
              // color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                if (_formKeyLogin.currentState!.validate()) {
                  context.loaderOverlay.show();
                  AuthService()
                      .signIn(email, password, context, tokenID)
                      .then((value) {
                    if (context.mounted) {
                      context.loaderOverlay.hide();
                    }
                  });
                  // Validate and save the form values
                  // _formKeyLogin.currentState?.saveAndValidate();
                  // debugPrint(_formKeyLogin.currentState?.value.toString());

                  // // On another side, can access all field values without saving form with instantValues
                  // _formKeyLogin.currentState?.validate();
                  //   debugPrint(_formKeyLogin.currentState?.instantValue.toString());
                }
              },
              child: const Text(
                'SIGN IN',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ).tr(),
            ),
          ),
          Gap(20),
          SizedBox(
            width: MediaQuery.of(context).size.width >= 1100
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1.2,
            height: 50,
            child: GoogleAuthButton(
              style: AuthButtonStyle(
                elevation: 0,
                textStyle: TextStyle(
                    color: AdaptiveTheme.of(context).mode.isDark == true
                        ? Colors.white
                        : Colors.black),
                buttonColor: AdaptiveTheme.of(context).mode.isDark == true
                    ? Colors.black
                    : Colors.white,
                iconType: AuthIconType.secondary,
              ),
              onPressed: _isLoading == true
                  ? null
                  : () {
                      _signInWithGoogle();
                    },
            ),
          ),
          // Icon(Bootstrap.google)
        ],
      ),
    );
  }
}
