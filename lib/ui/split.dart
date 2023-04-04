import 'package:flutter/material.dart';
import 'dart:math';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class SplitScreen extends StatefulWidget {
  SplitScreen({Key? key, required this.items, required this.cost, required this.payees, required this.paid})
      : super(key: key);

  var items;
  var cost;
  var payees;
  var paid;

  @override
  State<StatefulWidget> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  TextEditingController peopleController = TextEditingController();
  var peopleAmount;

  @override
  void initState() {
    super.initState();
    peopleAmount = [
      for (var i=max(widget.items.length as int, 2); i <= 20; i++) '${i.toString()} people'
    ];
  }

  Padding buildEqualSplitTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        CustomDropdown(
          hintText: 'Number of people (including payees)',
          items: peopleAmount,
          controller: peopleController,
          excludeSelected: false,
        ),
        Text(widget.items.toString()),
        Text(widget.cost.toString()),
        Text(widget.payees.toString()),
        Text(widget.paid.toString()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Split"),
              bottom: const TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Split Equally", icon: Icon(Icons.people)),
                  Tab(text: "Buy Over", icon: Icon(Icons.emoji_people_rounded)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                buildEqualSplitTab(),
                Icon(Icons.directions_transit),
              ],
            )));
  }
}
