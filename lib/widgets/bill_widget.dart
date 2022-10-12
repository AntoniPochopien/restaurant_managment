import 'package:flutter/material.dart';
import 'package:restaurant_managment/models/meal_model.dart';

import '../models/product_model.dart';

class Bill extends StatefulWidget {
  List<dynamic> mealsId;
  List<ProductModel> listOfProducts;

  Bill(this.mealsId, this.listOfProducts);

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  String findMealNameByID(int id) {
    var result =
        widget.listOfProducts.indexWhere((element) => element.id == id);
    return widget.listOfProducts[result].name;
  }

  double sumBill(List<dynamic> orderedMeals) {
    double sum = 0.0;
    orderedMeals.forEach((orderedElement) {
      widget.listOfProducts.forEach((menuElement) {
        if (orderedElement == menuElement.id) {
          sum += menuElement.price;
        }
      });
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          'Bill',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        )),
        Divider(
          color: Colors.white,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: widget.mealsId.length,
          itemBuilder: (context, index) {
            return Text(
              findMealNameByID(widget.mealsId[index]),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            );
          },
        )),
        Divider(
          color: Colors.white,
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Sum: ${sumBill(widget.mealsId)}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
