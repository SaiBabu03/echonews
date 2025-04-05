import 'package:echonews/homescreen.dart';
import 'package:echonews/login_screen.dart';
import 'package:echonews/providers/auth_provider.dart';
import 'package:echonews/providers/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp
      (
      debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,  // Use theme from provider
        theme: ThemeData.light(), // Light Theme
        darkTheme: ThemeData.dark(),
      home: Consumer<AuthProvider>(builder: (context,auth,_){
        return auth.isLoggedIn?const Homescreen():const LoginScreen();
      },)
    );
  }
}
