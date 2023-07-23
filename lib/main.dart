import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth_project/Screens/HomeScreen/homescreen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Screens/Login Screen/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyAHiQ103h4UTBxz-CMr2cRpneHQ6JOC1PQ",
    appId: "1:144979479990:android:fcbbdc425039932ce64517",
    messagingSenderId: "144979479990",
    projectId: "emailpasswordauth-ee356",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                final User? user = snapshot.data;
                return user == null ? const LoginScreen() : const HomeScreen();
              }
            },
          ),
        );
      },
    );
  }
}
