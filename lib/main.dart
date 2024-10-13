import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:woman_safety/child/bottom_page.dart';
import 'package:woman_safety/constant.dart';
import 'package:woman_safety/db/shared_pref.dart';
import 'package:woman_safety/firebase_options.dart';
import 'package:woman_safety/home_screen.dart';
import 'package:woman_safety/login_screen.dart';
import 'package:woman_safety/parent/parent_homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPref.init(); // Wait for SharedPref initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.firaSansTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder(
            future: SharedPref.getUserType(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == "child") {
                return BottomPage();
              }
              if (snapshot.data == "parent") {
                return ParentHomescreen();
              }
              return Progress();
            }));
  }
}


// class CheckAuth extends StatelessWidget {
//   checkData() {
//     if (SharedPref().getUserType() == 'parent') {
//       return const ParentHomescreen();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }
