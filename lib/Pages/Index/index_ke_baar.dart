
import 'package:flutter/material.dart';
import 'package:foodie/Pages/Index/sections/mainsection.dart';

class indexKeBaad extends StatefulWidget {
  final List<dynamic> recipes;
  final Map<String, dynamic> userData;
  final List<dynamic>? recommendedrecipes;
  final Function() openDrawerCallback;
  const indexKeBaad(
      {super.key,
      required this.recipes,
      this.recommendedrecipes,
      required this.userData,
      required this.openDrawerCallback});

  @override
  State<indexKeBaad> createState() => _indexKeBaadState();
}

class _indexKeBaadState extends State<indexKeBaad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: homePageMain(
          openDrawerCallback: widget.openDrawerCallback,
          userData: widget.userData,
          recipes: widget.recipes,
        ),
      ),
    );
  }
}
