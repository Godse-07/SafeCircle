import 'package:flutter/material.dart';
import 'package:woman_safety/widgets/home_widgets/live_safe/BustopCard.dart';
import 'package:woman_safety/widgets/home_widgets/live_safe/HospitalCard.dart';
import 'package:woman_safety/widgets/home_widgets/live_safe/PharmeccuCard.dart';
import 'package:woman_safety/widgets/home_widgets/live_safe/PoliceStationCard.dart';

class LiveSafe extends StatelessWidget {
  const LiveSafe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceStationCard(),
          HospitalCard(),
          PharmeccuCard(),
          Bustopcard(),
        ],
      ),
    );
  }
}
