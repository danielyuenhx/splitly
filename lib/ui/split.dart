import 'package:flutter/material.dart';
import 'dart:math';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class SplitScreen extends StatefulWidget {
  SplitScreen(
      {Key? key,
      required this.items,
      required this.cost,
      required this.payees,
      required this.paid})
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
  var splitAmount;

  var payTo;
  var receive;

  @override
  void initState() {
    super.initState();
    peopleAmount = [
      for (var i = max(widget.payees.length as int, 2); i <= 20; i++)
        '${i.toString()} people'
    ];
  }

  @override
  void dispose() {
    super.dispose();
    peopleController.dispose();
  }

  String buildPayToStringHelper(name, remainder, overpaid, payingToIndex) {
    // amount needed to be paid to the overpayer
    double toBePaid = overpaid[payingToIndex]['toBePaid'];
    String res = '';

    // check if the remainder < amount to be paid {minus the amount to be paid}
    // if remainder == amount to be paid {increase payingToIndex}
    // if remainder > amount to be paid {increase payingToIndex and minus amount to be paid from next}
    if (remainder <= toBePaid) {
      overpaid[payingToIndex]['toBePaid'] -= remainder;
      res =
          '$name pays RM ${remainder.toStringAsFixed(2)} to ${overpaid[payingToIndex]['name']}';
      overpaid[payingToIndex]['paidBy'].add({"name": name, "paid": remainder});

      if (remainder == toBePaid) {
        payingToIndex += 1;
      }
    } else {
      overpaid[payingToIndex]['toBePaid'] -= toBePaid;
      overpaid[payingToIndex]['paidBy'].add({"name": name, "paid": toBePaid});
      payingToIndex += 1;
      overpaid[payingToIndex]['toBePaid'] -= remainder - toBePaid;
      overpaid[payingToIndex]['paidBy']
          .add({"name": name, "paid": remainder - toBePaid});

      res =
          '$name pays RM ${toBePaid.toStringAsFixed(2)} to ${overpaid[payingToIndex - 1]['name']} and RM ${(remainder - toBePaid).toStringAsFixed(2)} to ${overpaid[payingToIndex]['name']}';
    }
    return res;
  }

  String buildReceiveString(name, remainder, toBePaid, paidBy) {
    String fromString = '';
    paidBy.forEach((payee) => {
          fromString +=
              ', RM ${payee['paid'].toStringAsFixed(2)} from ${payee['name']}'
        });

    String remainderString = '';
    if (toBePaid.floor() > 0) {
      int numOfPeople = (toBePaid/splitAmount).floor();
      // paid partially
      double partially = toBePaid - (splitAmount*numOfPeople.floor());
      print(splitAmount);
      print(toBePaid);
      
      remainderString +=
          ', RM ${numOfPeople >= 1 ? splitAmount.toStringAsFixed(2) : toBePaid.toStringAsFixed(2)} ${numOfPeople >= 1 ? 'from $numOfPeople ${numOfPeople > 1 ? 'people' : 'person'}' : 'paid partially by 1 person'} ${splitAmount < toBePaid && partially > 0 ? 'and RM ${partially.toStringAsFixed(2)} paid partially by 1 person' : ''}';
    }

    return '$name receives RM ${remainder.toStringAsFixed(2)}$fromString$remainderString';
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
          onChanged: (value) {
            setState(() {
              splitAmount =
                  widget.cost / int.parse(peopleController.text.split(' ')[0]);
              var underpaid = [];
              var overpaid = [];

              // loop through to add data
              widget.payees
                  .asMap()
                  .forEach((index, payee) => payee['paid'] < splitAmount
                      ? underpaid.add({
                          "name": payee['name'] != ''
                              ? payee['name']
                              : 'Payee ${(index + 1).toString()}',
                          "remainder": splitAmount - payee['paid']
                        })
                      : payee['paid'] > splitAmount
                          ? overpaid.add({
                              "name": payee['name'] != ''
                                  ? payee['name']
                                  : 'Payee ${(index + 1).toString()}',
                              "remainder": payee['paid'] - splitAmount,
                              "toBePaid": payee['paid'] - splitAmount,
                              "paidBy": [],
                            })
                          : '');

              // get the payTo values
              var payToLocal = [];
              int payingToIndex = 0;
              for (var i = 0; i < underpaid.length; i++) {
                payToLocal.add(Text(buildPayToStringHelper(underpaid[i]['name'],
                    underpaid[i]['remainder'], overpaid, payingToIndex)));
              }

              // get receive values
              var receiveLocal = [];
              for (var i = 0; i < overpaid.length; i++) {
                receiveLocal.add(Text(buildReceiveString(
                    overpaid[i]['name'],
                    overpaid[i]['remainder'],
                    overpaid[i]['toBePaid'],
                    overpaid[i]['paidBy'])));
              }

              setState(() {
                payTo = payToLocal;
                receive = receiveLocal;
              });
            });
          },
        ),
        if (splitAmount != null)
          Column(
            children: [...payTo, ...receive],
          ),
        // widget.payees[i]['paid'] > splitAmount
        // paid more than expected. to receive money from others
        // remainder to be paid/actual amount = number of people to pay
        // paid less than expected. to pay money to others
        // : Text(((splitAmount - widget.payees[i]['paid']) / splitAmount)
        //     .floor()
        //     .toString()),
        // if (splitAmount != null)
        //   for (var i = 0; i < overpaid.length; i++)
        //     Text(buildReceiveString(overpaid[i]['name'],
        //         overpaid[i]['remainder'], overpaid[i]['paidBy'])),
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
