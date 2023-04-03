import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import "package:intl/intl.dart";
import 'package:flutter_slidable/flutter_slidable.dart';

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
  TextEditingController paidController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    itemNameController.dispose();
    costController.dispose();
    quantityController.dispose();
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

  TextFormField buildTextFormField(
      controller, validate, icon, hintText, digitsOnly, currency) {
    return TextFormField(
        controller: controller,
        validator: (value) {
          if (validate) {
            if (value == null || value.isEmpty) {
              return 'Enter data';
            }
          }
          return null;
        },
        decoration: InputDecoration(
          icon: Icon(icon),
          hintText: hintText,
        ),
        keyboardType: digitsOnly ? TextInputType.number : TextInputType.text,
        inputFormatters: digitsOnly
            ? [
                FilteringTextInputFormatter.digitsOnly,
              ]
            : [],
        onChanged: currency
            ? (value) => formatCurrencyHandler(value, costController)
            : (value) {});
  }

  Text buildItemList(name) {
    return Text(name);
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
          ElevatedButton(onPressed: () {}, child: const Text('Save'))
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
                        child: Form(
                            key: _itemFormKey,
                            child: Column(children: [
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
                                        true,
                                        Icons.attach_money_rounded,
                                        'Cost',
                                        true,
                                        true)),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Expanded(
                                    flex: 3,
                                    child: buildTextFormField(
                                        quantityController,
                                        true,
                                        Icons.numbers_rounded,
                                        'Quantity',
                                        true,
                                        false)),
                              ]),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_itemFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            items = [
                                              ...items,
                                              {
                                                "name": itemNameController.text,
                                                "cost": double.parse(
                                                    costController.text
                                                        .replaceAll(',', '')),
                                                "quantity": int.parse(
                                                    quantityController.text),
                                              }
                                            ];
                                          });

                                          print(items);

                                          itemNameController.clear();
                                          costController.clear();
                                          quantityController.clear();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text('Item added!')),
                                          );
                                        }
                                      },
                                      child: const Text('Add Item')))
                            ])),
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
                            const Expanded(
                                flex: 5,
                                child: TextField(
                                  decoration: InputDecoration(
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
                                  onPressed: () {},
                                  child: const Text('Add Payee')))
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
                  const SizedBox(
                    height: 5.0,
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
                          child: ListTile(
                            title: Text(items[i]['name'] != ''
                                ? items[i]['name']
                                : 'Item ${i + 1}'),
                            leading: Text((i + 1).toString()),
                            subtitle: Text(
                                "Cost: ${items[i]['cost']}, Quantity: ${items[i]['quantity']}"),
                            trailing: Text(
                                (items[i]['cost'] * items[i]['quantity'])
                                    .toStringAsFixed(2)),
                            minLeadingWidth: 12,
                          ),
                        ),
                    ],
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
