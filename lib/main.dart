import 'package:asset_managment_app/providers/assets_accounts_provider.dart';
import 'package:asset_managment_app/providers/auth_provider.dart';
import 'package:asset_managment_app/screens/account_details.dart';
import 'package:asset_managment_app/screens/home_screen.dart';
import 'package:asset_managment_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './firebase_options.dart' as firebase_config;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: firebase_config.FirebaseOptions.apiKey,
      appId: firebase_config.FirebaseOptions.appId,
      messagingSenderId: firebase_config.FirebaseOptions.messagingSenderID,
      projectId: firebase_config.FirebaseOptions.projectId,
    ),
  );

  Provider.debugCheckInvalidValueType = null;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Accounts())
      ],
      child: MaterialApp(
        title: 'Assets Management',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: {
          LoginScreen.route: (context) => const LoginScreen(),
          HomeScreen.route: (context) => const HomeScreen(),
          AccountDetails.route: (context) => const AccountDetails()
        },
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const HomeScreen();
              } else {
                return const LoginScreen();
              }
            }),
      ),
    );
  }
}
