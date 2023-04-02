import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String title = "";

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(
            top: 45.0, left: 15.0, right: 15.0, bottom: 20.0),
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
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.title_rounded),
                    hintText: 'Title (Optional)',
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
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
                          onChanged: (val) {
                            setState(() {
                              title = val;
                            });
                          }),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(children: [
                        Expanded(
                            flex: 5,
                            child: TextField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money_rounded),
                                  hintText: 'Cost',
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                })),
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
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                })),
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
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                })),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            flex: 3,
                            child: TextField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money_rounded),
                                  hintText: 'Paid',
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    title = val;
                                  });
                                })),
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
            ],
          ))
    ]);
  }
}
