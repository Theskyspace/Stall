import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stall/app_colors.dart';
import 'package:stall/models/orders.dart';
import 'package:stall/ui/adds/add_screen.dart';
import 'package:stall/ui/home/slideable_widget.dart';
import 'package:stall/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Order> orderList = [];
  List<Order> completedList = [];
  List<Order> pendingList = [];

  @override
  void initState() {
    getallOrder();
    super.initState();
  }

  double pending = 1.0;
  double completed = 1.0;
  double revenue = 0;

  getallOrder() async {
    orderList = await OrderDatabase.instance.readAll();
    completedList =
        orderList.where((element) => element.iscompleted == 1).toList();
    pendingList =
        orderList.where((element) => element.iscompleted == 0).toList();

    pending = pendingList.length.toDouble();

    revenue = 0;
    for (int i = 0; i < completedList.length; i++) {
      revenue += completedList[i].amount;
    }

    completed = completedList.length.toDouble();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kcprimary,
        appBar: AppBar(
          title: const Text(
            "Profitable Stall",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 17),
          ),
          backgroundColor: kcprimary,
          elevation: 0,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: kcprimary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              getallOrder();
            },
            child: SizedBox(
              child: ListView(children: [
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 0.2,
                      ),
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Pending"),
                            Text(
                              "$pending",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 255, 106, 96),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Completed"),
                            Text(
                              "$completed",
                              style: const TextStyle(
                                fontSize: 18,
                                color: kcsuccesscolor,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Revenue"),
                            Text(
                              "$revenue",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 96, 178, 255),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return OrderBlock(
                        id: pendingList[index].id!.toInt(),
                        orderitem: pendingList[index].dish,
                        customername: pendingList[index].name,
                        order: pendingList[index],
                      );
                    }),
                    itemCount: pendingList.length),
              ]),
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: const Alignment(0.97, 0.97),
          child: FloatingActionButton(
            onPressed: () {
              // Navigater to the other screen
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => AddScreen(),
                ),
              );
            },
            backgroundColor: const Color.fromARGB(255, 255, 106, 96),
            child: const Icon(Icons.add),
          ),
        ));
  }
}
