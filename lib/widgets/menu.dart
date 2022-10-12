import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class Menu extends StatefulWidget {
  List<ProductModel> listOfProducts;
  List<dynamic> mealsId;
  String? tableId;

  Menu(
      {required this.listOfProducts,
      required this.mealsId,
      required this.tableId});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'MENU',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.listOfProducts.length,
            itemBuilder: (context, index) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        widget.listOfProducts[index].name,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.listOfProducts[index].price.toString() + ' \$',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.mealsId.add(widget.listOfProducts[index].id);
                          FirebaseFirestore.instance
                              .collection('/tables')
                              .doc(widget.tableId)
                              .set({'orderedMealsList': widget.mealsId},
                                  SetOptions(merge: true));
                        },
                        child: Text('+'),
                        style: ElevatedButton.styleFrom(shape: CircleBorder()),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
