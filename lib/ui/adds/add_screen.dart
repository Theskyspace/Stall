import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stall/app_colors.dart';
import 'package:stall/models/orders.dart';
import 'package:stall/utils/database_helper.dart';

import '../../app_const.dart';

class AddScreen extends StatefulWidget {
  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
  Map<int, int> counter = {};
}

class _AddScreenState extends State<AddScreen> {
  @override
  void initState() {
    // TODO: implement initState
    for (int index = 0; index < dishesList.length; index++) {
      if (widget.counter[index] == null) {
        widget.counter[index] = 0;
      } else {
        widget.counter[index] = 0;
      }
    }
    super.initState();
  }

  double amount = 0.0;
  String? name = "";
  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text(
            "Add Item",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
          ),
          backgroundColor: kcprimary,
          elevation: 0,
        ),
        backgroundColor: kcprimary,
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: UnderlineInputBorder(),
                  hintText: 'Akash Joshi',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: UnderlineInputBorder(),
                  hintText: '8169840285',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 17),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Amount",
                      style: TextStyle(fontSize: kcfontsize),
                    ),
                    Text(
                      "$amount",
                      style: const TextStyle(
                          fontSize: kcfontsize, color: kcsuccesscolor),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Catalogue",
                style: TextStyle(color: Colors.grey),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dishesList.length,
                itemBuilder: (context, index) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dishesList.keys.elementAt(index),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text("${dishesList.values.elementAt(index)}"),
                              ],
                            )),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kcneutralcolor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                  onTap: () => setState(() {
                                        if (widget.counter[index] == 0) {
                                          widget.counter[index];
                                        } else {
                                          amount -= dishesList.values
                                              .elementAt(index);
                                          if (widget.counter[index] != null) {
                                            int? a = widget.counter[index];
                                            widget.counter[index] = a! - 1;
                                          }
                                        }
                                      }),
                                  child: const Icon(Icons.remove)),
                              Text(widget.counter[index].toString()),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      amount +=
                                          dishesList.values.elementAt(index);
                                      if (widget.counter[index] != null) {
                                        int? a = widget.counter[index];
                                        widget.counter[index] = a! + 1;
                                        log(widget.counter[index].toString());
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.add)),
                            ],
                          ),
                        )
                      ]);
                },
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please enter a name")));
              return;
            }
            if (amount == 0.0) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Bhai Kuch to order karo 😋")));
              return;
            }

            // Feed this data into the sqflite.
            for (int index = 0; index < dishesList.length; index++) {
              if (widget.counter[index] != 0) {
                log("Name: ${nameController.text} Amount: $amount");
                log("Dish: ${dishesList.keys.elementAt(index)} Quantity: ${widget.counter[index]}");
                for (int i = 0; i < widget.counter[index]!.toInt(); i++) {
                  final order = Order(
                    name: nameController.text,
                    amount: dishesList.values.elementAt(index),
                    dish: dishesList.keys.elementAt(index),
                    phoneNumber: phoneNumberController.text,
                  );
                  await OrderDatabase.instance.create(order);
                }
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Order Placed Successfully")));

            Navigator.pop(context);
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Items"),
          backgroundColor: kcsuccesscolor,
        ));
  }
}
