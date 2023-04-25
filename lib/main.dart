import 'package:chat_app/res/styles/colors.dart';
import 'package:chat_app/view_models/auth_view_model.dart';
import 'package:chat_app/view_models/chat_room_view_model.dart';
import 'package:chat_app/views/auth/auth_view.dart';
import 'package:chat_app/views/auth/verify_email_view.dart';
import 'package:chat_app/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Firebase.apps.isEmpty){
    await Firebase.initializeApp(
      name: 'osama-chat-def1b',
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }else{
    Firebase.app();
  }


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatRoomViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      context.read<AuthViewModel>().changeUserState(user);
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Provider.of<AuthViewModel>(context, listen: false)
            .setIsEmailVerified(user.emailVerified);
        print('User is signed in!');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<AuthViewModel>(context).user;
    bool? isEmailVerified = Provider.of<AuthViewModel>(context).isEmailVerified;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CustomColors.darkBlue,
          secondary: CustomColors.lightBlue,
        ),
      ),
      home: (user == null)
          ? const AuthView()
          : (isEmailVerified != null && !isEmailVerified)
              ? const VerifyEmailView()
              : const HomeView(),
    );
  }
}
