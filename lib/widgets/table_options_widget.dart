import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_managment/widgets/bill_widget.dart';

import '../models/product_model.dart';
import './timer.dart';
import './menu.dart';

class TableOptionsWidget extends StatefulWidget {
  int selectedIndex;
  String? selectedTableId;
  int guestsNumber;
  Timestamp? lastCheck;
  List<dynamic> mealsId;
  List<ProductModel> listOfProducts;

  TableOptionsWidget({
    required this.guestsNumber,
    required this.selectedIndex,
    required this.lastCheck,
    this.selectedTableId,
    required this.mealsId,
    required this.listOfProducts,
  });

  @override
  State<TableOptionsWidget> createState() => _TableOptionsWidgetState();
}

class _TableOptionsWidgetState extends State<TableOptionsWidget> {
  bool optionsButtonsHelper = false;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 3, 58, 80),
      child: widget.selectedIndex == -1
          ? Center(
              child: Text(
                'SELECT TABLE',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'TABLE OPTIONS',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                optionsButtonsHelper = !optionsButtonsHelper;
                                if (!optionsButtonsHelper) {
                                  pageController.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                } else {
                                  pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                }
                              }),
                              child: Container(
                                color: optionsButtonsHelper
                                    ? Colors.red
                                    : Colors.green,
                                child: const Center(
                                  child: Text(
                                    'OPTIONS / BILL',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () => setState(() {
                                optionsButtonsHelper = !optionsButtonsHelper;
                                if (!optionsButtonsHelper) {
                                  pageController.animateToPage(0,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                } else {
                                  pageController.animateToPage(1,
                                      duration: Duration(milliseconds: 250),
                                      curve: Curves.easeIn);
                                }
                              }),
                              child: Container(
                                color: optionsButtonsHelper
                                    ? Colors.green
                                    : Colors.red,
                                child: Center(
                                  child: Text(
                                    'MENU',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ), //TODO Table options + 2x buttons
                Expanded(
                  child: PageView(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          if (value == 0) {
                            optionsButtonsHelper = false;
                          } else {
                            optionsButtonsHelper = true;
                          }
                        });
                      },
                      children: [
                        Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.guestsNumber -= 1;
                                        });

                                        FirebaseFirestore.instance
                                            .collection('/tables')
                                            .doc(widget.selectedTableId)
                                            .update({
                                          'guestsNumber': widget.guestsNumber
                                        });
                                      }, //minus one person from table
                                      child: Text(
                                        '-',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(
                                      widget.guestsNumber.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          widget.guestsNumber += 1;
                                        });

                                        FirebaseFirestore.instance
                                            .collection('/tables')
                                            .doc(widget.selectedTableId)
                                            .update({
                                          'guestsNumber': widget.guestsNumber
                                        });
                                      }, //plus one person to table
                                      child: Text(
                                        '+',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.timer,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                          child: TimerWidget(
                                        timeStampMiliseconds: DateTime.now()
                                                .millisecondsSinceEpoch -
                                            widget.lastCheck!
                                                .toDate()
                                                .millisecondsSinceEpoch,
                                      )
                                          // Text(
                                          //   '00:00',
                                          //   style: TextStyle(
                                          //       fontSize: 20,
                                          //       fontWeight: FontWeight.bold,
                                          //       color: Colors.white),
                                          // ),
                                          ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Check')),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Expanded(
                                child: Bill(
                                    widget.mealsId, widget.listOfProducts)),
                          ],
                        ),
                        Menu(
                            mealsId: widget.mealsId,
                            listOfProducts: widget.listOfProducts,
                            tableId: widget.selectedTableId),
                      ]),
                )
              ],
            ),
    );
  }
}
