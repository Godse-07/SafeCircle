import 'dart:math';

import 'package:flutter/material.dart';
import 'package:woman_safety/utils/quetos.dart';
import 'package:woman_safety/widgets/home_widgets/Emergency_card.dart';
import 'package:woman_safety/widgets/home_widgets/customCarouel.dart';
import 'package:woman_safety/widgets/home_widgets/custom_appbar.dart';

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
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Customcarouel(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(
                      "Emergency",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  EmergencyCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
