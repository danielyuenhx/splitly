import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:intl/intl.dart";
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'split.dart';
import '../globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _itemFormKey = GlobalKey<FormState>();
  final _payeeFormKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  double costSum = 0;

  TextEditingController payeeNameController = TextEditingController();
  TextEditingController paidController = TextEditingController();

  double paidSum = 0;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    itemNameController.dispose();
    costController.dispose();
    quantityController.dispose();

    payeeNameController.dispose();
    paidController.dispose();
  }

  var items = [];
  var payees = [];

  void formatCurrencyHandler(value, controller) {
    String newValue = value.replaceAll(',', '').replaceAll('.', '');
    if (value.isEmpty || newValue == '00') {
      controller.clear();
      return;
    }
    double value1 = double.parse(newValue);
    value =
        NumberFormat.currency(customPattern: '###,###.##').format(value1 / 100);
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  TextFormField buildTextFormField(TextEditingController controller,
      IconData icon, String hintText, bool currency) {
    return TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter data';
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hintText,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: currency
            ? (value) => formatCurrencyHandler(value, controller)
            : (value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          child: Padding(
        padding: const EdgeInsets.only(
            top: 45.0, left: 15.0, right: 15.0, bottom: 15.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: const [
              Icon(Icons.spa_outlined, color: Colors.black),
              SizedBox(
                width: 15.0,
              ),
              Text('Add a Split',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1)),
            ],
          ),
          ElevatedButton(
              onPressed: () {
                print(items.toString());
                print(payees.toString());
              },
              child: const Text('Save'))
        ]),
      )),
      Expanded(
          child: ListView(
        padding: const EdgeInsets.only(top: 10.0),
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextField(
                  //     maxLength: 30,
                  //     decoration: const InputDecoration(
                  //       // icon: Icon(Icons.title_rounded),
                  //       hintText: 'Title (Optional)',
                  //     ),
                  //     controller: titleController),
                  Card(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Form(
                            key: _itemFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Add Items',
                                    style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextField(
                                    controller: itemNameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Item Name (optional)',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(children: [
                                    Expanded(
                                        flex: 5,
                                        child: buildTextFormField(
                                            costController,
                                            Icons.attach_money_rounded,
                                            'Cost',
                                            true)),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: buildTextFormField(
                                            quantityController,
                                            Icons.numbers_rounded,
                                            'Quantity',
                                            false)),
                                  ]),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            onPressed: paidSum <= costSum ||
                                                    paidSum.toStringAsFixed(
                                                            2) ==
                                                        costSum
                                                            .toStringAsFixed(2)
                                                ? null
                                                : () {
                                                    if (paidSum > costSum) {
                                                      double remainder =
                                                          paidSum - costSum;
                                                      if (quantityController
                                                              .text ==
                                                          '') {
                                                        quantityController
                                                            .text = '1';
                                                      } else {
                                                        int quantity = int.parse(
                                                            quantityController
                                                                .text);
                                                        remainder = remainder /
                                                            quantity;
                                                      }
                                                      costController.text =
                                                          remainder
                                                              .toStringAsFixed(
                                                                  2);
                                                    }
                                                  },
                                            child:
                                                const Text('Fill Remainder')),
                                        const SizedBox(width: 10.0),
                                        SizedBox(
                                            width: 110,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_itemFormKey.currentState!
                                                      .validate()) {
                                                    double cost = double.parse(
                                                        costController.text
                                                            .replaceAll(
                                                                ',', ''));
                                                    int quantity = int.parse(
                                                        quantityController
                                                            .text);
                                                    setState(() {
                                                      items = [
                                                        ...items,
                                                        {
                                                          "name":
                                                              itemNameController
                                                                  .text,
                                                          "cost": cost,
                                                          "quantity": quantity,
                                                        }
                                                      ];
                                                    });

                                                    costSum += cost * quantity;

                                                    itemNameController.clear();
                                                    costController.clear();
                                                    quantityController.clear();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Item added!')),
                                                    );
                                                  }
                                                },
                                                child: const Text('Add Item')))
                                      ])
                                ])),
                      )),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Card(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Form(
                            key: _payeeFormKey,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Add Payees',
                                    style: TextStyle(
                                        fontSize: 17.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(children: [
                                    Expanded(
                                        flex: 5,
                                        child: TextField(
                                          controller: payeeNameController,
                                          decoration: const InputDecoration(
                                            hintText: 'Payee Name (optional)',
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: buildTextFormField(
                                            paidController,
                                            Icons.attach_money_rounded,
                                            'Paid',
                                            true)),
                                  ]),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton(
                                            onPressed: costSum <= paidSum ||
                                                    paidSum.toStringAsFixed(
                                                            2) ==
                                                        costSum
                                                            .toStringAsFixed(2)
                                                ? null
                                                : () {
                                                    if (costSum > paidSum) {
                                                      paidController.text =
                                                          (costSum - paidSum)
                                                              .toStringAsFixed(
                                                                  2);
                                                    }
                                                  },
                                            child:
                                                const Text('Fill Remainder')),
                                        const SizedBox(width: 10.0),
                                        SizedBox(
                                            width: 110,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  if (_payeeFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    double paid = double.parse(
                                                        paidController.text
                                                            .replaceAll(
                                                                ',', ''));
                                                    setState(() {
                                                      payees = [
                                                        ...payees,
                                                        {
                                                          "name":
                                                              payeeNameController
                                                                  .text,
                                                          "paid": paid,
                                                        }
                                                      ];
                                                    });

                                                    paidSum += paid;

                                                    payeeNameController.clear();
                                                    paidController.clear();

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Payee added!')),
                                                    );
                                                  }
                                                },
                                                child:
                                                    const Text('Add Payee'))),
                                      ]),
                                ])),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Divider(
                    height: 5.0,
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Split Details',
                    style:
                        TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              setState(() {
                                costSum -=
                                    items[i]['cost'] * items[i]['quantity'];
                                items.removeAt(i);
                              });
                            }),
                            extentRatio: 0.3,
                            children: [
                              SlidableAction(
                                autoClose: false,
                                onPressed: (BuildContext context) {
                                  Slidable.of(context)!.dismiss(ResizeRequest(
                                      const Duration(milliseconds: 300), () {
                                    setState(() {
                                      costSum -= items[i]['cost'] *
                                          items[i]['quantity'];
                                      items.removeAt(i);
                                    });
                                  }));
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: i == 0
                                          ? BorderSide(
                                              color: Colors.grey.shade200)
                                          : BorderSide.none,
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: ListTile(
                                title: Text(items[i]['name'] != ''
                                    ? items[i]['name']
                                    : 'Item ${i + 1}'),
                                leading: Text((i + 1).toString()),
                                subtitle: Text(
                                    "Cost: RM ${items[i]['cost'].toStringAsFixed(2)}, Quantity: ${items[i]['quantity']}"),
                                trailing: Text(
                                    'RM ${(items[i]['cost'] * items[i]['quantity']).toStringAsFixed(2)}'),
                                minLeadingWidth: 12,
                              )),
                        ),
                    ],
                  ),
                  Text('Total: RM ${costSum.toStringAsFixed(2)}'),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Payees',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    children: [
                      for (var i = 0; i < payees.length; i++)
                        Slidable(
                          key: UniqueKey(),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            dismissible: DismissiblePane(onDismissed: () {
                              setState(() {
                                paidSum -= payees[i]['paid'];
                                payees.removeAt(i);
                              });
                            }),
                            extentRatio: 0.3,
                            children: [
                              SlidableAction(
                                autoClose: false,
                                onPressed: (BuildContext context) {
                                  Slidable.of(context)!.dismiss(ResizeRequest(
                                      const Duration(milliseconds: 300), () {
                                    setState(() {
                                      paidSum -= payees[i]['paid'];
                                      payees.removeAt(i);
                                    });
                                  }));
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: i == 0
                                          ? BorderSide(
                                              color: Colors.grey.shade200)
                                          : BorderSide.none,
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              child: ListTile(
                                title: Text(payees[i]['name'] != ''
                                    ? payees[i]['name']
                                    : 'Payee ${i + 1}'),
                                leading: Text((i + 1).toString()),
                                trailing: Text(
                                    'RM ${payees[i]['paid'].toStringAsFixed(2)}'),
                                minLeadingWidth: 12,
                              )),
                        ),
                    ],
                  ),
                  Text('Total: RM ${paidSum.toStringAsFixed(2)}'),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: costSum.toStringAsFixed(2) !=
                                  paidSum.toStringAsFixed(2) ||
                              costSum.toStringAsFixed(2) == '0.00'
                          ? null
                          : () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen:
                                    SplitScreen(items: items, cost: costSum, payees: payees, paid: paidSum),
                                withNavBar: false,
                              );
                            },
                      child: const Text('Split',
                          style: TextStyle(fontSize: 17.5))),
                  const SizedBox(height: 10.0),
                ],
              ))
        ],
      ))
    ]);
  }
}
