import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:math';

import 'package:animated_custom_dropdown/custom_dropdown.dart';

class BuyOverTab extends StatefulWidget {
  BuyOverTab(
      {Key? key, required this.items, required this.payees, required this.paid})
      : super(key: key);

  var items;
  var payees;
  var paid;

  @override
  State<StatefulWidget> createState() => _BuyOverState();
}

class _BuyOverState extends State<BuyOverTab> {
  TextEditingController peopleController = TextEditingController();
  var peopleAmount;
  var numOfPeople;
  var splitAmount;

  TextEditingController buyOverController = TextEditingController();
  List<String> buyOverStrategy = [];
  var buyOverIndex;

  @override
  void initState() {
    super.initState();
    peopleAmount = [
      for (var i = max(widget.payees.length as int, 2); i <= 20; i++)
        '${i.toString()} people'
    ];
    for (var payee in widget.payees) {
      buyOverStrategy.add('${payee['name']} buys over');
    }
  }

  @override
  void dispose() {
    super.dispose();
    buyOverController.dispose();
  }

  Widget buildBuyOverSection(name, pay, receive, buyOver) {
    return Column(children: [
      const SizedBox(
        height: 10.0,
      ),
      Text('$name ${buyOver ? '(Buyer)' : ''}',
          style: const TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      // const Divider(),
      const SizedBox(
        height: 5.0,
      ),
      IntrinsicHeight(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade300, width: 1.25))),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Receive',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                          for (var e in receive) Text(e)
                        ],
                      )))),
          VerticalDivider(
            color: Colors.grey.shade300,
            width: 0,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.grey.shade300, width: 1.25))),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pay',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                          for (var e in pay) Text(e)
                        ],
                      )))),
        ],
      )),
      const SizedBox(
        height: 5.0,
      ),
    ]);
  }

  List<Widget> buildBuyOverSections() {
    List<Widget> res = [];
    String buyOverName = widget.payees[buyOverIndex]['name'];
    double buyOverPaid = widget.payees[buyOverIndex]['paid'];

    var paidTo = [];
    var receiveFrom = [];

    // other payees
    for (int i = 0; i < widget.payees.length; i++) {
      if (i != buyOverIndex) {
        String name = widget.payees[i]['name'];
        double paid = widget.payees[i]['paid'];

        // if paid more than supposed to, receive money from buyoverer
        if (paid > splitAmount) {
          paidTo.add(widget.payees[i]);
          res.add(buildBuyOverSection(
              name,
              [],
              [
                'RM ${(paid - splitAmount).toStringAsFixed(2)} from $buyOverName'
              ],
              false));
          // if paid less than supposed to, pay money to buyoverer
        } else if (paid < splitAmount) {
          receiveFrom.add(widget.payees[i]);
          res.add(buildBuyOverSection(
              name,
              ['RM ${(splitAmount - paid).toStringAsFixed(2)} to $buyOverName'],
              [],
              false));
        }
      }
    }

    // other payees whether have to pay or receive
    var pay = [];
    for (var paid in paidTo) {
      pay.add(
          'RM ${(paid['paid'] - splitAmount).toStringAsFixed(2)} to ${paid['name']}');
    }

    var receive = [];
    for (var paid in receiveFrom) {
      //   receive.add(RichText(
      //       text: TextSpan(
      //     text: "RM ${(splitAmount - paid['paid']).toStringAsFixed(2)}",
      //     style: const TextStyle(fontWeight: FontWeight.bold),
      //     children: [
      //       const TextSpan(text: 'from'),
      //       TextSpan(text: "${paid['name']}"),
      //     ],
      //   )));
      // }
      receive.add(
          'RM ${(splitAmount - paid['paid']).toStringAsFixed(2)} from ${paid['name']}');
    }

    // the buyover checking who to pay/receive from
    int numOfOthers = numOfPeople - widget.payees.length;
    double toBePaid = (numOfOthers * splitAmount).toDouble();

    receive.add(numOfOthers > 0
        ? 'RM ${toBePaid.toStringAsFixed(2)} from others, RM ${splitAmount.toStringAsFixed(2)} each from ${numOfPeople - widget.payees.length} ${numOfOthers == 1 ? "person" : 'people'}'
        : '');

    res.insert(0, buildBuyOverSection(buyOverName, pay, receive, true));
    // Text(
    //     '$buyOverName $payeeText ${numOfOthers > 0 ? 'receives a total of RM ${toBePaid.toStringAsFixed(2)} from others, RM ${splitAmount.toStringAsFixed(2)} each from ${numOfPeople - widget.payees.length} people' : ''}'));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          CustomDropdown(
              hintText: 'Buy over strategy',
              items: buyOverStrategy,
              controller: buyOverController,
              excludeSelected: false,
              onChanged: (value) {
                setState(() {
                  buyOverIndex = buyOverStrategy.indexOf(value);
                });
              }),
          const SizedBox(
            height: 10.0,
          ),
          CustomDropdown(
              hintText: 'Number of people (including payees)',
              items: peopleAmount,
              controller: peopleController,
              excludeSelected: false,
              onChanged: (value) {
                setState(() {
                  numOfPeople = int.parse(peopleController.text.split(' ')[0]);
                  splitAmount = widget.paid /
                      int.parse(peopleController.text.split(' ')[0]);
                });
              }),
          const SizedBox(
            height: 15.0,
          ),
          if (buyOverIndex != null && splitAmount != null)
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  ...buildBuyOverSections(),
                ])),
          const SizedBox(
            height: 15.0,
          ),
          if (buyOverIndex != null && splitAmount != null)
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40)),
                onPressed: () {},
                child:
                    const Text('Save Split', style: TextStyle(fontSize: 17.5))),
        ]));
  }
}
