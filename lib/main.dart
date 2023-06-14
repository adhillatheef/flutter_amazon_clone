import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:flutter_amazon_clone/screens/admin_screen.dart';
import 'package:flutter_amazon_clone/screens/auth_screen.dart';
import 'package:flutter_amazon_clone/services/auth_service.dart';
import 'package:flutter_amazon_clone/services/routes.dart';
import 'package:flutter_amazon_clone/widgets/bottom_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> UserProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme:
            const ColorScheme.light(primary: GlobalVariables.secondaryColor),
        appBarTheme: const AppBarTheme(
            elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home:Provider.of<UserProvider>(context).user.token.isNotEmpty?
      Provider.of<UserProvider>(context).user.type == 'user'?
      const BottomBar():const AdminScreen(): const AuthScreen(),
    );
  }
}
