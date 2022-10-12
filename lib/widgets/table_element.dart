import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/meal_model.dart';
import './timer.dart';

class TableElement extends StatefulWidget {
  int selectedCard;
  int selectedItemIndex;
  int guestsNumber;
  Timestamp lastCheck;

  TableElement({
    required this.selectedCard,
    required this.selectedItemIndex,
    required this.guestsNumber,
    required this.lastCheck,
  });

  @override
  State<TableElement> createState() => _TableElementState();
}

class _TableElementState extends State<TableElement> {
  late bool isSelected = widget.selectedCard == widget.selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timer,
              color: Colors.white,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TimerWidget(
                    timeStampMiliseconds:
                        DateTime.now().millisecondsSinceEpoch -
                            widget.lastCheck.toDate().millisecondsSinceEpoch),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              color: Colors.white,
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(widget.guestsNumber.toString()),
              ),
            )
          ],
        ),
        Container(
          child: Icon(Icons.table_bar,
              size: 60,
              color: widget.selectedCard == widget.selectedItemIndex
                  ? Color.fromARGB(255, 32, 214, 38)
                  : widget.guestsNumber > 0
                      ? Colors.red
                      : Colors.white),
        ),
      ],
    );
  }
}
