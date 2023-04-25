import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

import '../../res/styles/colors.dart';
import '../../view_models/auth_view_model.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  late Timer _timer;

  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      print(user!.emailVerified);
      user!.reload();
      user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified == true) {
        Provider.of<AuthViewModel>(context, listen: false)
            .setIsEmailVerified(true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final AuthViewModel _authViewModel = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            child: Container(
              width: width,
              height: height * 0.30,
              decoration: BoxDecoration(
                color: CustomColors.lightBlue,
              ),
            ),
            clipper: WaveClipperTwo(),
          ),
          ClipPath(
            child: Container(
              width: width,
              height: height * 0.25,
              decoration: BoxDecoration(
                color: CustomColors.darkBlue,
              ),
            ),
            clipper: WaveClipperTwo(),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ClipPath(
              child: Container(
                width: width,
                height: height * 0.15,
                decoration: BoxDecoration(
                  color: CustomColors.darkBlue,
                ),
              ),
              clipper: WaveClipperTwo(reverse: true, flip: true),
            ),
          ),
          Positioned(
            top: 32.0,
            right: 16.0,
            child: TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontSize: 24.0),
              ),
              onPressed: () {
                _authViewModel.signOut();
              },
            ),
          ),
          const Positioned(
            top: 32.0,
            left: 16.0,
            child: Text(
              'Verify your email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Please check your email.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                const Text(
                  "Didn't you receive email?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _authViewModel.sendEmailVerification();
                  },
                  child: Text(
                    'Resend',
                    style: TextStyle(
                      color: CustomColors.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
