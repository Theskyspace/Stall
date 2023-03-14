import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stall/app_colors.dart';
import 'package:stall/models/orders.dart';
import 'package:stall/utils/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderBlock extends StatefulWidget {
  final int id;
  final String orderitem;
  final String customername;
  Order order;
  OrderBlock({
    super.key,
    this.id = -1,
    this.orderitem = "Food Item",
    this.customername = "Customer Nameasasd",
    required this.order,
  });

  @override
  State<OrderBlock> createState() => OrderBlockState();
}

class OrderBlockState extends State<OrderBlock> {
  _makingPhoneCall(phonenumber) async {
    await launchUrlString("tel:$phonenumber");
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        color: Colors.green,
      ),
      secondaryBackground: Container(
        color: Colors.red,
      ),
      onDismissed: ((direction) {
        if (direction == DismissDirection.endToStart) {
          widget.order.iscompleted = 1;
          OrderDatabase.instance.update(widget.order);
        } else {
          if (widget.order.phoneNumber != "") {
            log("Calling ${widget.order.phoneNumber}");
            _makingPhoneCall(widget.order.phoneNumber);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No Phone Number Found"),
              ),
            );
          }
        }
      }),
      key: UniqueKey(),
      child: Container(
        height: 100,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kcneutralcolor,
              width: 0.2,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.1,
                  ),
                ),
              ),
              height: 40,
              width: double.infinity,
              child: RichText(
                text: TextSpan(
                    text: "#${widget.id}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "   ${widget.orderitem}",
                          style: const TextStyle(fontWeight: FontWeight.w300))
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                      text: "Ordered By : ",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        TextSpan(
                            text: " ${widget.customername}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 25))
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
