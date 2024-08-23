import 'package:chaty/Constants.dart';
import 'package:chaty/Helpers/ThemeNotifier.dart';
import 'package:chaty/Pages/LoginPage.dart';
import 'package:chaty/Pages/RegisterPage.dart';
import 'package:chaty/Pages/SplashScreen.dart';
import 'package:chaty/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

late ThemeData darkbutton;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ThemeNotifier themeNotifier = ThemeNotifier(lightMode);
  await themeNotifier.loadTheme();
  darkbutton = themeNotifier.themedata;
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => themeNotifier,
      child: const Chaty(),
    ),
  );
}

class Chaty extends StatelessWidget {
  const Chaty({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.themedata,
          debugShowCheckedModeBanner: false,
          routes: {
            LoginPage.ID: (context) => LoginPage(),
            RegisterPage.ID: (context) => RegisterPage(),
            SplashScreen.ID: (context) => SplashScreen(),
          },
          initialRoute: SplashScreen.ID,
        );
      },
    );
  }
}
