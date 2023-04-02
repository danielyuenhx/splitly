import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:intl/intl.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController paidController = TextEditingController();

  var items = [];
  var payees = [];

  void formatCurrencyHandler(value, controller) {
    bool isFirst = true;
    String newValue = value.replaceAll(',', '').replaceAll('.', '');
    if (value.isEmpty || newValue == '00') {
      controller.clear();
      isFirst = true;
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

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(
            top: 45.0, left: 15.0, right: 15.0, bottom: 15.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: const [
              Icon(Icons.spa_outlined),
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
          ElevatedButton(onPressed: () {}, child: Text('Save'))
        ]),
      ),
      Expanded(
          child: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                      maxLength: 30,
                      decoration: const InputDecoration(
                        // icon: Icon(Icons.title_rounded),
                        hintText: 'Title (Optional)',
                      ),
                      controller: titleController),
                  const Text(
                    'Add Items',
                    style: TextStyle(fontSize: 17.5),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Column(children: [
                          TextField(
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
                                child: TextField(
                                    controller: costController,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.attach_money_rounded),
                                      hintText: 'Cost',
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) => formatCurrencyHandler(
                                        value, costController))),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                flex: 3,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.numbers_rounded),
                                    hintText: 'Quantity',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                )),
                          ]),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text('Add Item')))
                        ]),
                      )),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Add Payees',
                    style: TextStyle(fontSize: 17.5),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Card(
                      clipBehavior: Clip.hardEdge,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5.0, left: 20.0, right: 20.0, bottom: 10.0),
                        child: Column(children: [
                          Row(children: [
                            Expanded(
                                flex: 5,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Payee Name (optional)',
                                  ),
                                )),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: paidController,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.attach_money_rounded),
                                    hintText: 'Paid',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) => formatCurrencyHandler(
                                      value, paidController),
                                )),
                          ]),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                  onPressed: () {}, child: Text('Add Payee')))
                        ]),
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
                    style: TextStyle(fontSize: 17.5),
                  ),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [Chip(label: Text("Text"))],
                    ),
                  )
                ],
              ))
        ],
      ))
    ]);
  }
}
