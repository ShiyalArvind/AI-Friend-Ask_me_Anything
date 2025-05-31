

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:friend/provider/auth_provider.dart';
import 'package:friend/provider/chat_provider.dart';
import 'package:friend/services/shared_pref.dart';
import 'package:friend/view/chat_view/provider_chat_view.dart';

import 'package:provider/provider.dart';

import 'Common/custom_textfield.dart';
import 'auth/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // Initialize Firebase
  await SharedPreference().init(); // Initialize Shared Preferences

  bool isLoggedIn = await SharedPreference().getBooleanPref(SharedPreference.stayLoggedIn);
  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => ScreenDimensProvider()),

        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => TextFieldNotifier()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isLoggedIn});

  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(home: isLoggedIn ? ProviderChatView() : LoginPage(), debugShowCheckedModeBanner: false);
  }
}
