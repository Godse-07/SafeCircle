import 'dart:math';

import 'package:flutter/material.dart';
import 'package:woman_safety/utils/quetos.dart';
import 'package:woman_safety/widgets/customCarouel.dart';
import 'package:woman_safety/widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 1;

  getRandomQuote() {
    setState(() {
      index = Random().nextInt(quotes.length);
    });
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
              child: CustomAppbar(
                onTap: getRandomQuote,
                qIndex: index,
              ),
            ),
            Customcarouel(),
          ],
        ),
      ),
    );
  }
}
